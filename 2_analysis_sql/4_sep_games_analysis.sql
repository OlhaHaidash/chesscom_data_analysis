-- 15.10.2025

-- 1. Які гравці серед лідерів найбільше грали у вересні 2025 (загальна кількість ігор) у кожному типі активності?
SELECT 
        username,
        time_class,
        COUNT(*) AS games_count,
        COUNT(*)/30 AS games_per_day,
        COUNT(*)/30/24 AS games_per_hour
FROM top_players_games_2025_09_flat
GROUP BY username, time_class
ORDER BY COUNT(*) DESC;

-- ВИСНОВОК:
-- Найбільшу кількість ігор, зіграних у вересні 2025 року показали гравці з ніками 'judenyc' - 1965, 'DanielNaroditsky' - 1407, 'kreysmyr' - 1312, 'Badfarma07' - 990
-- Отже, за такої активності ці гравці протягом вересня щодня грали більше 30 ігор і щогодини грали мінімум 1 гру

-- Варто також зважати на тип активності:
-- Bullet: дуже швидкі ігри, зазвичай 1–2 хвилини на партію на кожного гравця
-- Blitz: швидкі ігри, зазвичай 3–5 хвилин на партію на гравця
-- Rapid: середньошвидкі ігри, зазвичай 10–25 хвилин на партію на гравця
-- Daily: ігри від кількох днів до тижнів на хід

-- Гравці грали щодня 30 ігор в таких активностях, як blitz та bullet, що продовжуються від 1 до 5 хвилин за гру

-- Дослідимо скільки ігор на день грали кожен з цих 4 гравців протягом вересня(кількість ігор в конкретний день):

SELECT 
        username,
        time_class,
        (to_timestamp(end_time) AT TIME ZONE 'UTC')::DATE AS date,
        COUNT(*),
        COUNT(*)/24
FROM top_players_games_2025_09_flat
GROUP BY username, time_class, (to_timestamp(end_time) AT TIME ZONE 'UTC')::DATE
ORDER BY COUNT(*) DESC;

-- З таблиці видно, що 'judenyc' 07.09.2025 р зіграв 392 гри за один день, що складає 16 ігор на годину протягом всіх 24 годин (в режимі bullet)


-- 2. Які гравці показали найкращі результати (кількість перемог) у кожному типі активності?

SELECT 
        player_name,
        time_class,
        COUNT(*) as wins_count
FROM (
        SELECT 
                white_username AS player_name,
                time_class
        FROM top_players_games_2025_09_flat
        WHERE white_result = 'win'

        UNION ALL

        SELECT 
                black_username AS player_name,
                time_class
        FROM top_players_games_2025_09_flat
        WHERE black_result = 'win'
) as all_wins
GROUP BY time_class, player_name
ORDER BY COUNT(*) DESC;


-- ВИСНОВОК:
-- Рейтинг з великим відривом очолюють 'judenyc' та 'DaniielNaroditsky' із 1107 та 1041 перемог за вересень 2025 відповідно.


-- 3. Які гравці маю найбільшу результативність в іграх (найбільший відсоток перемог)?
-- Обмежимо кількість зіграних ігор до умови (не менше 100 ігор), щоб уникнути ситуації, коли гравець зіграв 1 гру і виграв

SELECT
    player_name,
    time_class,
    COUNT(*) AS total_games,
    SUM(CASE 
            WHEN (player_name = white_username AND white_result = 'win') 
              OR (player_name = black_username AND black_result = 'win') 
            THEN 1 ELSE 0 
        END) AS total_wins,
    ROUND(
        SUM(CASE 
                WHEN (player_name = white_username AND white_result = 'win') 
                  OR (player_name = black_username AND black_result = 'win') 
                THEN 1 ELSE 0 
            END)::decimal / COUNT(*) * 100,
        2
    ) AS win_rate_percent
FROM (
    SELECT white_username AS player_name, white_username, white_result, black_username, black_result, time_class
    FROM top_players_games_2025_09_flat
    UNION ALL
    SELECT black_username AS player_name, white_username, white_result, black_username, black_result, time_class
    FROM top_players_games_2025_09_flat
) AS all_players
GROUP BY player_name, time_class
HAVING COUNT(*) > 100
ORDER BY win_rate_percent DESC;

-- ВИСНОВОК:
-- Якщо порахувати розподіл кількості зіграних ігор і виключити дуже малоактивних гравців (наприклад, тих, хто зіграв менше 100 ігор), 
-- то найвищий відсоток перемог показав Hikaru — 83,6 %. До першої десятки за результативністю входять гравці з показником понад 65 % перемог.



-- 4. Які гравці мають найбільшу різницю між поточним рейтингом та кращим досягнутим рейтингом?
SELECT
    tpdi.username,
    type,
    rank,
    (chess_blitz_best_rating - chess_blitz_rating) AS chess_blitz_diff,
    (chess_bullet_best_rating - chess_bullet_rating) AS chess_bullet_diff,
    (chess_rapid_best_rating - chess_rapid_rating) AS chess_rapid_diff,
    (chess_daily_best_rating - chess_daily_rating) AS chess_daily_diff,
    ROUND(
        (
            COALESCE(chess_blitz_best_rating - chess_blitz_rating, 0) +
            COALESCE(chess_bullet_best_rating - chess_bullet_rating, 0) +
            COALESCE(chess_rapid_best_rating - chess_rapid_rating, 0) +
            COALESCE(chess_daily_best_rating - chess_daily_rating, 0)
        )::numeric
        / NULLIF(
            (CASE WHEN chess_blitz_best_rating IS NOT NULL AND chess_blitz_rating IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN chess_bullet_best_rating IS NOT NULL AND chess_bullet_rating IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN chess_rapid_best_rating IS NOT NULL AND chess_rapid_rating IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN chess_daily_best_rating IS NOT NULL AND chess_daily_rating IS NOT NULL THEN 1 ELSE 0 END), 0
        ),
    2
    ) AS avg_diff
FROM top_players_detailed_info tpdi
JOIN chesscom_all_leaders cal ON cal.username = tpdi.username
ORDER BY cal.rank, avg_diff;

-- ВИСНОВОК:
-- Таблиця відсортована спочатку по рейтингу гравця з таблиці chesscom_all_leaders, а потім від найменшої різниці між кращим рейтингом і поточним рейтинго до найбільшої
-- Спостерігаємо повторення імен гравців в різних типах активності, що свідчить про їх стабільний розвиток в декількох активностях
-- Першим у списку є гравець ArkadiiKhromaev, котрий є першим в live_bullet та покращує або утримує свій найкращий рейтинг


-- 5. Яка середня кількість зіграних партій серед топ-50 гравців для кожного виду активності (september 2025)?

WITH games_count AS (
    SELECT
        username,
        time_class,
        COUNT(DISTINCT end_time || white_username || black_username) AS count_games
    FROM top_players_games_2025_09_flat
    GROUP BY username, time_class
)

SELECT
    time_class,
    ROUND(AVG(count_games)::numeric, 2) AS avg_games
FROM games_count
GROUP BY time_class
ORDER BY avg_games DESC;

-- ВИСНОВОК:
-- В середньому за вересень гравці зіграли 167 ігор в bullet, 164 - blitz, 16 - rapid та 6 - daily. Ця різниця пояснюється часом на 1 гру в різних режимах гри (різних активностях)




-- Наступні питання для дослідження:


-- Чи існує кореляція між кількістю зіграних партій і поточним рейтингом у кожному типі активності?

-- Які гравці мають найбільшу різницю між поточним рейтингом та кращим досягнутим рейтингом?
-- Які гравці показують найбільшу стабільність у рейтингах (мінімальна різниця між поточним і кращим рейтингом)?
-- Які гравці мають найменшу кількість зіграних партій у топ-50, і чи це впливає на їхнє місце у рейтингу?
-- Чи дає перевагу, якщо граєш білими? Відношення перемог білих до чорних.

