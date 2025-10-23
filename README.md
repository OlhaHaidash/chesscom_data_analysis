# Chess.com Top Players Activity Analysis
### Data Analytics / Game Analytics

## Description and Purpose
In this ongoing project, I analyze the profiles, ratings, activity, and game statistics of Chess.com leaders.

The analysis allows understanding:  
1. Which factors influence top players’ performance (frequency of games, time controls, win/loss ratios);
2. How leaders’ activity changes over time;
3. Which strategies or openings are most common among top players;
4. How stable leaders’ rankings are over time.

This research helps identify patterns in the behavior of successful players and combines behavioral analysis with game analysis, providing a foundation for predicting future performance and developing tools to analyze games.

# Data
No CSV files are included. Data is fetched directly from the Chess.com API (the method is described in the file [chesscom_stat_analysis.ipynb](https://github.com/OlhaHaidash/data_analysis_pet_projects/blob/main/chesscom_data_analysis/chesscom_stat_analysis.ipynb). Running the scripts will create local CSV files for analysis.

The overview of the data is contained in the file [0_data_overview.ipynb](https://github.com/OlhaHaidash/chesscom_data_analysis/blob/main/2_analysis_sql/0_data_overview.ipynb).

## Data Structure

<img align="left" width="1153" height="1272" src="https://github.com/OlhaHaidash/chesscom_data_analysis/blob/main/chesscom_schema.png">


# Data Version and Update Info
The data was last collected on October 13, 2025 using the Chess.com Public API.

# Tech Stack
**Python** - collect data from Chess.com API, process it, and prepare CSVs.  
**SQL(PostgreSQL) + pgAdmin** - create database, organize tables, load data, run queries.  
**VSCode** - write Python scripts and SQL queries, manage project locally.  
**Tableau** - visualize analysis results.

# Results and Recommendations
