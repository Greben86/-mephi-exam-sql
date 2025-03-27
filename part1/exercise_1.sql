/*
Найдите производителей (maker) и модели всех мотоциклов, которые имеют мощность более 150 лошадиных сил, стоят менее 20 тысяч долларов и являются спортивными (тип Sport). Также отсортируйте результаты по мощности в порядке убывания.
 */

SELECT
    v.maker,
    m.model
FROM Motorcycle m
    INNER JOIN Vehicle v ON (v.model = m.model AND v.type = 'Motorcycle')
WHERE m.horsepower > 150 AND m.price < 20000 AND m.type = 'Sport';
