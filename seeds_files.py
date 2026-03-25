import pandas as pd
import numpy as np
from datetime import datetime, timedelta

num_rides = 20000 
num_drivers = 500  
start_time = datetime(2025, 12, 1)
timestamps = [start_time + timedelta(days=np.random.randint(0, 90), 
                                     minutes=np.random.randint(0, 1440)) 
              for _ in range(num_rides)]

data = {
    'ride_id': range(1, num_rides + 1),
    'driver_id': np.random.randint(1, num_drivers + 1, size=num_rides),
    'pickup_location_id': np.random.randint(1, 266, size=num_rides),
    'dropoff_location_id': np.random.randint(1, 266, size=num_rides),
    'pickup_datetime': timestamps,
}

df_rides = pd.DataFrame(data)

df_rides = df_rides.sort_values('pickup_datetime').reset_index(drop=True)


df_rides['trip_duration_minutes'] = np.random.randint(5, 61, size=num_rides)

df_rides['fare_amount'] = 3.0 + (df_rides['trip_duration_minutes'] * 1.5) + np.random.normal(0, 2, size=num_rides)
df_rides['fare_amount'] = df_rides['fare_amount'].round(2)


error_indices = np.random.choice(df_rides.index, size=50, replace=False)
df_rides.loc[error_indices, 'fare_amount'] = 0.0


df_rides.to_csv('seeds/rides.csv', index=False)
print("Файл rides.csv успішно згенеровано!")


driver_ids = range(1, num_drivers + 1)

vehicle_types = np.random.choice(['sedan', 'suv', 'minivan', 'economy'], size=num_drivers, p=[0.5, 0.2, 0.1, 0.2])

ratings = np.random.uniform(3.0, 5.0, size=num_drivers).round(1)

statuses = np.random.choice(['active', 'inactive'], size=num_drivers, p=[0.85, 0.15])

df_drivers = pd.DataFrame({
    'driver_id': driver_ids,
    'vehicle_type': vehicle_types,
    'rating': ratings,
    'status': statuses
})

df_drivers.to_csv('seeds/drivers.csv', index=False)
print("Файл drivers.csv готовий!")


num_events = 30
start_time = datetime(2025, 12, 1)

data = {
    'event_id': range(101, 101 + num_events),
    'event_name': np.random.choice(['Concert', 'Sports Match', 'Festival', 'Conference'], size=num_events),
    # Прив'язуємо до реальних ID районів з твого taxi_zones.csv
    'location_id': np.random.randint(1, 266, size=num_events), 
    # Розкидаємо дати в тому ж діапазоні, що і поїздки
    'event_date': [(start_time + timedelta(days=np.random.randint(0, 90))).strftime('%Y-%m-%d') for _ in range(num_events)],
    'estimated_attendance': np.random.randint(1000, 50000, size=num_events)
}

df_events = pd.DataFrame(data)
df_events.to_csv('seeds/events.csv', index=False)
print("Файл events.csv готовий!")