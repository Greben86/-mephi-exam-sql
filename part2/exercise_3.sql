/*
Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию, количество гонок, в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок, в которых участвовали автомобили этих классов. Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
 */

WITH AvgPositions AS (
    -- Получение средних значений
    SELECT
        c.name,
        c.class,
        ROUND(AVG(r.position), 4) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
        INNER JOIN Results r ON (c.name = r.car)
    GROUP BY c.name, c.class
),  
AvgClasses AS (
    -- Получение марок автомобилей
    SELECT ca.class, ca.average_position, ca.race_count
    FROM AvgPositions ca
        INNER JOIN (SELECT MIN(average_position) AS min_avg_position FROM AvgPositions) ma ON (ca.average_position = ma.min_avg_position)
)

SELECT 
    ca.name AS car_name,
    ca.class AS car_class,
    ca.average_position,
    ca.race_count,
    cl.country,
    sc.race_count AS total_races
FROM AvgPositions ca
    INNER JOIN AvgClasses sc ON (ca.class = sc.class)
    INNER JOIN Classes cl ON (ca.class = cl.class)
ORDER BY average_position, name;
