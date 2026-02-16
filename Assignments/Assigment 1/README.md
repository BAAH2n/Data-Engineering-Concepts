# Assignment 1 — Indian Railway Stations Analysis

## Dataset

**Source:** `stations.json`

The dataset contains information about Indian railway stations, including their name, code, state, railway zone, address, and geographic coordinates.

## Data Loading

The JSON file is loaded into a `stations` table by unnesting the `features` array and extracting properties and coordinates using `read_json_auto()` and `UNNEST()`.

## Analysis

### 1. Top-3 states by number of stations in each zone

  There you can see biggest zones (with the most number of stations) and TOP-3 biggest state in the each zone. 

### 2. Comparing station count per state with zone average

  Data has been sorted by increasing in difference (the states with the largest gap in the number of stations from the average for the zone go first), so we can easily say which states should be allocated more resources in order to develop more infrastructure there to level the playing field.
