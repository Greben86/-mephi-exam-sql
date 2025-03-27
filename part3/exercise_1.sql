/*
Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию о каждом таком клиенте, включая его имя, электронную почту, телефон, общее количество бронирований, а также список отелей, в которых они бронировали номера (объединенные в одно поле через запятую с помощью CONCAT). Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям. Отсортировать результаты по количеству бронирований в порядке убывания.
 */

SELECT
    c.name,
    c.email,
    c.phone,
    COUNT(b.ID_booking) AS cnt,
    GROUP_CONCAT(DISTINCT h.name)
FROM Booking b
    LEFT JOIN Customer c ON (b.ID_customer = c.ID_customer)
    LEFT JOIN Room r ON (r.ID_room = b.ID_room)
    LEFT JOIN Hotel h ON (h.ID_hotel = r.ID_hotel)
GROUP BY
    c.name,
    c.email,
    c.phone
HAVING
    COUNT(DISTINCT h.ID_hotel) > 1 AND cnt >= 3;
