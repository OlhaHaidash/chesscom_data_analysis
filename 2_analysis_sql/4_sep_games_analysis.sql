-- 15.10.2025

-- Які гравці серед лідерів найбільше грали у вересні 2025 (загальна кількість ігор) у кожному типі активності?
SELECT 
        username,
        time_class,
        COUNT(*) AS games_count,
        COUNT(*)/30 AS games_per_day,
        COUNT(*)/30/24 AS games_per_hour
FROM top_players_games_2025_09_flat
GROUP BY username, time_class
ORDER BY COUNT(*) DESC;

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

-- З таблиці видно, що 'judenyc' 07.09.2025 р зіграв 392 гри за один день, що складає 16 ігор на годин протягом всіх 24 годин (в режимі bullet)

-- Які гравці показали найкращі результати (кількість перемог) у кожному типі активності?

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

-- Рейтинг з великим відривом очолюють 'judenyc' та 'DaniielNaroditsky' із 1107 та 1041 перемог за вересень 2025 відповідно.

-- Які гравці маю найбільшу результативність в іграх (найбільший відсоток перемог)?
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

-- Якщо порахувати розподіл кількості зіграних ігор і обмежити екстра малі (1-100 ігор, наприклад)




-- Наступні питання для дослідження:

-- Які гравці мають найбільшу різницю між поточним рейтингом та кращим досягнутим рейтингом?
-- Чи існує кореляція між кількістю зіграних партій і поточним рейтингом у кожному типі активності?
-- Яка середня кількість зіграних партій серед топ-50 гравців для кожного виду активності?
-- Які гравці мають найбільшу різницю між поточним рейтингом та кращим досягнутим рейтингом?
-- Які гравці показують найбільшу стабільність у рейтингах (мінімальна різниця між поточним і кращим рейтингом)?
-- Які гравці мають найменшу кількість зіграних партій у топ-50, і чи це впливає на їхнє місце у рейтингу?
-- Чи дає перевагу, якщо граєш білими? Відношення перемог білих до чорних.

