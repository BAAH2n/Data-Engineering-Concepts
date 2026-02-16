# Assignment 1 — Indian Railway Stations Analysis

## Dataset

**Source:** `stations.json`, [link](https://www.kaggle.com/datasets/sripaadsrinivasan/indian-railways-dataset)

The dataset contains information about Indian railway stations, including their name, code, state, railway zone, address, and geographic coordinates.

## Data Loading

The JSON file is loaded into a `stations` table by unnesting the `features` array and extracting properties and coordinates using `read_json_auto()` and `UNNEST()`.

## Analysis

### 1. Top-3 states by number of stations in each zone
<img width="2616" height="1510" alt="TOP-3" src="https://github.com/user-attachments/assets/63e341e4-44f0-460e-b06c-d8de617b90ce" />

  There you can see the biggest zones (with the largest number of stations) and the TOP-3 biggest states in each zone. 

### 2. Comparing station count per state with the zone average

  Data has been sorted by increasing difference (the states with the largest gap in the number of stations from the average for the zone go first), so we can easily say which states should be allocated more resources in order to develop more infrastructure there to level the playing field.
<img width="1788" height="1560" alt="Comparing" src="https://github.com/user-attachments/assets/ea94bf77-10ed-4398-ac26-8dda39154b99" />
