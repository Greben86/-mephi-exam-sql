/*
Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе (то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них). Вывести информацию об этих автомобилях, включая их имя, класс, среднюю позицию, количество гонок, в которых они участвовали, и страну производства класса автомобиля. Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.
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
    -- Получение статистики по маркам автомобилей
    SELECT 
        c.class,
        AVG(r.position) AS avg_class_position,
        COUNT(DISTINCT c.name) AS car_count
    FROM Cars c
        INNER JOIN Results r ON (c.name = r.car)
    GROUP BY c.class
)

SELECT 
    ca.name AS car_name,
    ca.class AS car_class,
    ROUND(ca.average_position, 4) AS average_position,
    ca.race_count,
    cl.country AS car_country
FROM AvgPositions ca
    INNER JOIN AvgClasses cla ON (ca.class = cla.class) AND (ca.average_position < cla.avg_class_position) AND (cla.car_count > 1)
    INNER JOIN Classes cl ON (ca.class = cl.class) 
ORDER BY ca.class, ca.average_position;
