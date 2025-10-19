-- 1. Дослідимо розподіл лідерів в топі по країнам в розрізі ігрової активності (якщо гравець є більш ніж в 1 рейтингу, 
-- він зараховуватиметься лише 1 раз) + в скількох рейтингах зустрічаються унікальні гравці по країнам

WITH country_names_table AS (
SELECT 
        cal.*,
        cci.name AS country_name
FROM chesscom_all_leaders cal
LEFT JOIN country_code_info cci ON
    cci.code = RIGHT(cal.country, 2)
)

SELECT 
        DISTINCT(country_name) AS country,
        COUNT(DISTINCT(username)) AS count_users,
        COUNT(DISTINCT(type)) AS count_types
FROM country_names_table
GROUP BY country_name
ORDER BY COUNT(DISTINCT(username)) DESC

-- 2. Топ-10 найуспішніших гравців в усіх типах активностей: live_blitz, live_bullet, live_rapid, daily 
-- (середнє між всіма score по гравцю)

SELECT 
        username,
        ROUND(AVG(score),0) AS avg_score,
        RIGHT(country, 2)
FROM chesscom_all_leaders
GROUP BY username, RIGHT(country, 2)
ORDER BY AVG(score) DESC
LIMIT 10

-- Найвищий рейтинг має Аркадій Хромаєв - 3500 рейтингу - Дослідити чи змінювався рейтинг протягом 2025 року!!!

-- Дані Магнуса Карлсена

SELECT AVG(score)
FROM chesscom_all_leaders
WHERE username LIKE 'Magnus%'

-- 3. Які 5 гравців серед лідерів на Chess.com є найпопулярнішими на платформі (мають найбільш фоловерів):
-- А також чи цей гравець стрімер

SELECT 
        username,
        followers,
        cci.name AS country_name,
        is_streamer
FROM top_players_detailed_info tpdi
LEFT JOIN country_code_info cci ON
    cci.code = RIGHT(tpdi.country,2)
ORDER BY followers DESC
LIMIT 5

-- Значну популярність топ юзерів на платформі можна пояснити їх популярністю через проведені стріми (Hikaru, Daniel Naroditsky, Jospem).
-- Другий за популярністю Магнус Карлсен є відомим норвезьким шаховим гросмейстером, 16-м чемпіоном світу з класичних шахів, який беззмінно посідає перше місце у рейтингу ФІДЕ з 1 липня 2011 року.

