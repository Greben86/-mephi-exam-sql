/*
Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей, и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок, в которых он участвовал, и страну производства класса автомобиля. Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).
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
    ap.race_count,
    cl.country AS car_country
FROM AvgPositions ap
    INNER JOIN (
        -- Получение минимального среднего значения
        SELECT class, MIN(average_position) AS min_average_position
        FROM AvgPositions
        GROUP BY class
    ) mn ON (ap.class = mn.class AND ap.average_position = mn.min_average_position)
    INNER JOIN Classes cl ON (cl.class = mn.class)
ORDER BY average_position
LIMIT 1;
