/*
Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0) и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию, количество гонок, в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок для каждого класса. Отсортировать результаты по количеству автомобилей с низкой средней позицией.
 */

WITH AvgPositions AS (
    -- Получение средних значений в разрезе модели
    SELECT
        c.name,
        c.class,
        ROUND(AVG(r.position), 4) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
        INNER JOIN Results r ON (c.name = r.car)
    GROUP BY c.name, c.class
),
TotalAvgPositions AS (
    -- Получение средних значений в разрезе марки
    SELECT 
        c.class,
        COUNT(r.race) AS total_race_count
    FROM Cars c
        INNER JOIN Results r ON (c.name = r.car)
    GROUP BY c.class
)

SELECT 
    ap.name AS car_name,
    ap.class AS car_class,
    ap.average_position,
    ap.race_count,
    cl.country,
    tap.total_race_count,
    COUNT(ap.name) AS low_position_count
FROM AvgPositions ap
    INNER JOIN Classes cl ON (ap.class = cl.class)
    INNER JOIN TotalAvgPositions tap ON (ap.class = tap.class)
WHERE ap.average_position > 3.0
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY tap.total_race_count DESC, ap.average_position ASC;
