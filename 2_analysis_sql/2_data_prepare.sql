-- 1. В таблиці лідерів замінити посилання на країну, де код країни це останні 2 літери, на повну назву країни англійською

--1.1 Додаю нову таблицю із кодами країн та їх відповідні назви англійською

CREATE TABLE country_code_info (
    name VARCHAR(50),
    code VARCHAR(2)
);

COPY country_code_info(name, code)
FROM '/tmp/country_code_info.csv'
DELIMITER ','
CSV HEADER;

--1.2 Додаю в таблицю лідерів стовпчик із назвами країн (на основі даних ISO 3166-1 alpha-2 codes):
-- (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 - посилання на інфо з кодами)

SELECT 
        cal.*,
        cci.name AS country_name
FROM chesscom_all_leaders cal
LEFT JOIN country_code_info cci ON
    cci.code = RIGHT(cal.country, 2)

--1.3 Маємо невідомі значення в даних: XX, XO, XE, EU, XW
-- EU - 'European Union', XO - 'South Ossetia', XX, XE, XW - 'Unknown'
-- Вручну додамо ці дані в таблицю:

INSERT INTO country_code_info (name, code)
VALUES
    ('European Union', 'EU'),
    ('South Ossetia', 'XO'),
    ('Unknown', 'XX'),
    ('Unknown', 'XE'),
    ('Unknown', 'XW')
;