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

### chesscom_all_leaders
| Column   | Type       | Description |
|----------|------------|-------------|
| type     | VARCHAR(50)| Type of game: blitz, bullet, rapid, daily |
| rank     | INT        | Player's ranking position |
| username | VARCHAR(100)| Unique player nickname |
| score    | INT        | Player score/rating points |
| country  | VARCHAR(255)| Country link (Chess.com API) |

### top_players_detailed_info
| Column                 | Type       | Description |
|------------------------|------------|-------------|
| username               | VARCHAR(100)| Unique player nickname (Primary Key) |
| title                  | VARCHAR(10)| Chess title: GM, IM, FM, etc. |
| country                | VARCHAR(255)| Country link |
| status                 | VARCHAR(50)| Account type: premium/basic |
| followers              | INT        | Number of followers |
| is_streamer            | BOOLEAN    | Streaming status |
| twitch_url             | VARCHAR(255)| Twitch profile link |
| youtube_url            | VARCHAR(255)| YouTube profile link |
| joined                 | TIMESTAMP  | Date joined |
| last_online            | TIMESTAMP  | Last online timestamp |
| chess_blitz_rating      | FLOAT      | Current blitz rating |
| chess_blitz_best_rating | FLOAT      | Best blitz rating |
| chess_blitz_wins        | INT        | Blitz wins |
| chess_blitz_losses      | INT        | Blitz losses |
| chess_blitz_draws       | INT        | Blitz draws |
| chess_bullet_rating     | FLOAT      | Current bullet rating |
| chess_bullet_best_rating| FLOAT      | Best bullet rating |
| chess_bullet_wins       | INT        | Bullet wins |
| chess_bullet_losses     | INT        | Bullet losses |
| chess_bullet_draws      | INT        | Bullet draws |
| chess_rapid_rating      | FLOAT      | Current rapid rating |
| chess_rapid_best_rating | FLOAT      | Best rapid rating |
| chess_rapid_wins        | INT        | Rapid wins |
| chess_rapid_losses      | INT        | Rapid losses |
| chess_rapid_draws       | INT        | Rapid draws |
| chess_daily_rating      | FLOAT      | Current daily rating |
| chess_daily_best_rating | FLOAT      | Best daily rating |
| chess_daily_wins        | INT        | Daily wins |
| chess_daily_losses      | INT        | Daily losses |
| chess_daily_draws       | INT        | Daily draws |
| tactics_rating          | FLOAT      | Tactics rating |
| tactics_best_rating     | FLOAT      | Best tactics rating |
| tactics_wins            | INT        | Tactics wins |
| tactics_losses          | INT        | Tactics losses |
| tactics_draws           | INT        | Tactics draws |

### top_players_games_2025_09_flat
| Column          | Type       | Description |
|-----------------|------------|-------------|
| username        | VARCHAR(100)| References top_players_detailed_info |
| url             | VARCHAR(255)| Link to the game |
| time_class      | VARCHAR(50)| Game type: blitz, bullet, rapid |
| rules           | VARCHAR(50)| Chess rules: chess/chess960 |
| end_time        | BIGINT     | Timestamp in seconds |
| rated           | BOOLEAN    | Rated game indicator |
| white_result    | VARCHAR(50)| Result for white |
| black_result    | VARCHAR(50)| Result for black |
| eco             | TEXT       | Opening URL |
| tcn             | TEXT       | Game identifier |
| white_username  | VARCHAR(100)| White player nickname |
| white_rating    | INT        | White player rating |
| white_uuid      | UUID       | White player UUID |
| white_api_url   | VARCHAR(255)| White API link |
| black_username  | VARCHAR(100)| Black player nickname |
| black_rating    | INT        | Black player rating |
| black_uuid      | UUID       | Black player UUID |
| black_api_url   | VARCHAR(255)| Black API link |

# Data Version and Update Info
The data was last collected on October 13, 2025 using the Chess.com Public API.

# Tech Stack
**Python** - collect data from Chess.com API, process it, and prepare CSVs.  
**SQL(PostgreSQL) + pgAdmin** - create database, organize tables, load data, run queries.  
**VSCode** - write Python scripts and SQL queries, manage project locally.  
**Tableau** - visualize analysis results.

# Results and Recommendations
