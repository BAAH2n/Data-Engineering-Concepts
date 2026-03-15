from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pymysql
import polars as pl


MYSQL_CONFIG = {
    "host": "host.docker.internal",
    "user": "root",
    "password": "MySQL_Student123",
    "database": "training_dw",
    "port": 3306,
}



def extract_from_mysql(**kwargs):
    conn = pymysql.connect(**MYSQL_CONFIG)
    cursor = conn.cursor()
    query = """SELECT c.city, COUNT(o.order_id), SUM(o.amount_usd)
               FROM customers c JOIN orders o ON c.customer_id = o.customer_id
               WHERE o.status = 'PAID' GROUP BY c.city"""
    cursor.execute(query)
    rows = cursor.fetchall()    
    cursor.close()
    conn.close()
    return rows                  



def transform_polars(**kwargs):
    ti = kwargs["ti"]
    rows = ti.xcom_pull(task_ids="extract_from_mysql")

    df = pl.DataFrame(
        rows,
        schema=["city", "paid_orders_cnt", "paid_revenue_usd"],
        orient="row",
    )

    ds = kwargs["ds"]
    df = df.with_columns(pl.lit(ds).alias("as_of_date"))

    return df.to_dicts()

def write_csv(**kwargs):
    ti = kwargs["ti"]
    data = ti.xcom_pull(task_ids="transform_polars")

    df = pl.DataFrame(data)

    path = f"/usr/local/airflow/data/city_paid_metrics_{kwargs['ds']}.csv"
    df.write_csv(path)


default_args = {
    "owner": "airflow",
    "start_date": datetime(2024, 3, 1),
}

dag = DAG(
    "mysql_polars_to_csv",
    default_args=default_args,
    schedule="@daily",
    catchup=False,
)

task_extract = PythonOperator(
    task_id="extract_from_mysql",
    python_callable=extract_from_mysql,
    dag=dag,
)

task_transform = PythonOperator(
    task_id="transform_polars",
    python_callable=transform_polars,
    dag=dag,
)

task_write = PythonOperator(
    task_id="write_csv",
    python_callable=write_csv,
    dag=dag,
)

task_extract >> task_transform >> task_write
