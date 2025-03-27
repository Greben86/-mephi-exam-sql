/*
Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:

Категоризация отелей.
Определите категорию каждого отеля на основе средней стоимости номера:

«Дешевый»: средняя стоимость менее 175 долларов.
«Средний»: средняя стоимость от 175 до 300 долларов.
«Дорогой»: средняя стоимость более 300 долларов.
Анализ предпочтений клиентов.
Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:

Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
Вывод информации.
Выведите для каждого клиента следующую информацию:

ID_customer: уникальный идентификатор клиента.
name: имя клиента.
preferred_hotel_type: предпочитаемый тип отеля.
visited_hotels: список уникальных отелей, которые посетил клиент.
Сортировка результатов.
Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».
 */

SELECT
    c.ID_customer,
    c.name,
    statistic.hotel_category,
    statistic.visited_hotels
FROM Customer c
  INNER JOIN(
      -- Распределение цен на три категории по средней цене
      SELECT
        b.ID_customer,
        GROUP_CONCAT(DISTINCT h.name) AS visited_hotels,
        CASE
          WHEN MAX(bookings.avg_price) < 175 THEN 'Дешевый'
          WHEN MAX(bookings.avg_price) BETWEEN 175 AND 300 THEN 'Средний'
          WHEN MAX(bookings.avg_price) > 300 THEN 'Дорогой'
        END AS hotel_category
      FROM Booking b
        INNER JOIN Room r ON (b.ID_room = r.ID_room)
        INNER JOIN Hotel h ON (r.ID_hotel = h.ID_hotel)
        INNER JOIN (
          -- Получение средней цены
          SELECT 
            h.ID_hotel,
            AVG(r.price) avg_price
          FROM Hotel h
            JOIN Room r ON h.ID_hotel = r.ID_hotel
          GROUP BY h.ID_hotel
          ) as bookings ON (bookings.ID_hotel = h.ID_hotel)
      GROUP BY b.ID_customer
      ) statistic ON (statistic.ID_customer = c.ID_customer)
ORDER BY 
    -- Сортировка по средней цене
    CASE statistic.hotel_category
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END;
