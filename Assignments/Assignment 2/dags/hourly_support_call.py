from airflow import DAG
from airflow.models import Variable
from airflow.providers.mysql.hooks.mysql import MySqlHook
import json
import os
import logging
import duckdb
import pandas as pd
from airflow.operators.python import PythonOperator

json_dir_path = "/usr/local/airflow/include/telephony_json"
duckdb_path = "/usr/local/airflow/include/support_calls.duckdb"


def on_failure_callback(context):
    task_id = context["task_instance"].task_id
    dag_id = context["task_instance"].dag_id
    logical_date = context.get("logical_date", "unknown")
    error = context.get("exception", "Unknown error")
    logging.error(f"Task FAILED: dag={dag_id}, task={task_id}, date={logical_date}, error={error}")

def detect_new_calls():
    last_time = Variable.get("last_call_time", default_var="0001-01-01 00:00:00")
    hook = MySqlHook(mysql_conn_id="assignment2_conn")
    df = hook.get_pandas_df(
        """SELECT call_id, call_time
           FROM calls
           WHERE call_time > %s
           ORDER BY call_time""",
        parameters=[last_time]
    )

    if df.empty:
        logging.info("No new calls found.")
        return []

    new_call_ids = df["call_id"].tolist()
    logging.info(f"Found {len(new_call_ids)} new calls")
    return new_call_ids


def load_telephony_details(**kwargs):
    ti = kwargs["ti"]
    new_call_ids = ti.xcom_pull(task_ids="detect_new_calls")

    if not new_call_ids:
        logging.info("No new call IDs to process.")
        return []

    required_fields = ["call_id", "duration_sec", "short_description"]
    valid_records = []

    for call_id in new_call_ids:
        filepath = os.path.join(json_dir_path, f"call_{call_id}.json")
        try:
            with open(filepath, "r") as f:
                data = json.load(f)

            missing = []
            for field in required_fields:
                if field not in data:
                    missing.append(field)
            if missing:
                logging.warning(f"call_{call_id}.json missing fields: {missing}")
                continue
            if data["duration_sec"] < 0:
                logging.warning(f"call_{call_id}.json has invalid duration")
                continue

            valid_records.append(data)
            logging.info(f"Loaded call_{call_id}.json successfully")

        except FileNotFoundError:
            logging.warning(f"JSON file not found for call_id={call_id}")
        except json.JSONDecodeError:
            logging.warning(f"Invalid JSON format in call_{call_id}.json")

    logging.info(f"Loaded {len(valid_records)} of {len(new_call_ids)} telephony records")
    return valid_records

def transform_and_load_duckdb(**kwargs):

    ti = kwargs["ti"]
    new_call_ids = ti.xcom_pull(task_ids="detect_new_calls")
    telephony_records = ti.xcom_pull(task_ids="load_telephony_details")

    if not new_call_ids:
        logging.info("No new calls to load into DuckDB.")
        return

    hook = MySqlHook(mysql_conn_id="assignment2_conn")
    calls_df = hook.get_pandas_df(
        f"""SELECT c.call_id, c.employee_id, c.call_time, c.phone, c.direction, c.status, e.full_name, e.team, e.role, e.hire_date
            FROM calls c
            INNER JOIN employees e ON c.employee_id = e.employee_id
            WHERE c.call_id IN ({",".join(str(cid) for cid in new_call_ids)})"""
    )


    if telephony_records:
        telephony_df = pd.DataFrame(telephony_records)
    else:
        telephony_df = pd.DataFrame(columns=["call_id", "duration_sec", "short_description"])

    df_2 = calls_df.merge(telephony_df, on="call_id", how="left")

    logging.info(f"Enriched DataFrame has {len(df_2)} rows")

    con = duckdb.connect(duckdb_path)

    con.execute("""
        CREATE TABLE IF NOT EXISTS support_call_enriched (
            call_id         INTEGER PRIMARY KEY,
            employee_id     INTEGER,
            call_time       TIMESTAMP,
            phone           VARCHAR,
            direction       VARCHAR,
            status          VARCHAR,
            full_name       VARCHAR,
            team            VARCHAR,
            role            VARCHAR,
            hire_date       DATE,
            duration_sec    DOUBLE,
            short_description VARCHAR
        )""")

    if not df_2.empty:
        ids_to_delete = df_2["call_id"].tolist()
        con.execute(
            f"DELETE FROM support_call_enriched WHERE call_id IN ({','.join(str(i) for i in ids_to_delete)})"
        )
        con.execute("INSERT INTO support_call_enriched SELECT * FROM df_2")
        logging.info(f"Inserted {len(df_2)} rows into support_call_enriched")

    con.close()

    new_max_time = str(calls_df["call_time"].max())
    Variable.set("last_call_time", new_max_time)
    logging.info(f"Watermark updated to {new_max_time}")
    
default_args = {
    "owner": "airflow",
    "retries": 2,
    "retry_delay": pd.Timedelta(seconds=30),
    "on_failure_callback": on_failure_callback,
}

dag = DAG(
    "hourly_support_call",
    default_args=default_args,
    schedule="@hourly",
    start_date=pd.Timestamp("2026-03-15"),
    catchup=False,
)

task_extract = PythonOperator(
    task_id="detect_new_calls",
    python_callable=detect_new_calls,
    dag=dag,
)

task_transform = PythonOperator(
    task_id="load_telephony_details",
    python_callable=load_telephony_details,
    dag=dag,
)

task_write = PythonOperator(
    task_id="transform_and_load_duckdb",
    python_callable=transform_and_load_duckdb,
    dag=dag,
)

task_extract >> task_transform >> task_write

