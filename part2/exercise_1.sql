/*
Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом таком автомобиле для данного класса, включая его класс, среднюю позицию и количество гонок, в которых он участвовал. Также отсортировать результаты по средней позиции.
 */

WITH AvgPositions AS (
    -- Получение средних значений
    SELECT
        c.name,
        c.class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
        INNER JOIN Results r ON (c.name = r.car)
    GROUP BY c.name, c.class
)

SELECT
    ap.name AS car_name,
    ap.class AS car_class,
    ap.average_position,
    ap.race_count
FROM AvgPositions ap
    INNER JOIN (
        -- Получение минимального среднего значения
        SELECT class, MIN(average_position) AS min_average_position
        FROM AvgPositions
        GROUP BY class
    ) mn ON (ap.class = mn.class AND ap.average_position = mn.min_average_position)
ORDER BY average_position;
