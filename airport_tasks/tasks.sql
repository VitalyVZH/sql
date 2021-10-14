-- 1.	Вывести список самолетов с кодами 320, 321, 733;
SELECT model FROM lanit.aircrafts_data WHERE aircraft_code IN ('320', '321', '733');

-- 2.	Вывести список самолетов с кодом не на 3;
SELECT model FROM lanit.aircrafts_data WHERE aircraft_code NOT LIKE '3%';

-- 3.	Найти билеты оформленные на имя «OLGA», с емайлом «OLGA» или без емайла;
SELECT * FROM lanit.tickets WHERE passenger_name LIKE 'OLGA%' AND (email LIKE ('%olga%') OR email IS NULL);

-- 4.	Найти самолеты с дальностью полета 5600, 5700. Отсортировать список по убыванию дальности полета;
SELECT model FROM lanit.aircrafts_data WHERE range IN ('5600', '5700') ORDER BY range DESC;

-- 5.	Найти аэропорты в Moscow. Вывести название аэропорта вместе с городом. Отсортировать по полученному названию;
SELECT airport_name AS AIRPORT, city FROM lanit.airports_data WHERE city = 'Moscow' ORDER BY airport_name;

-- 6.	Вывести список всех городов без повторов в зоне «Europe»;
SELECT city FROM lanit.airports_data WHERE timezone LIKE 'Europe%' GROUP BY city;

-- 7.	Найти бронирование с кодом на «3A4» и вывести сумму брони со скидкой 10%
SELECT book_ref, (total_amount * 0.9) AS WITH_DISCOUNT_10 FROM lanit.bookings WHERE book_ref LIKE '3A4%';

-- 8.	Вывести все данные по местам в самолете с кодом 320 и классом «Business»в формате «Данные по месту: номер места»
SELECT 'Seating data: '||seat_no AS  "Business class seats" FROM lanit.seats
    WHERE aircraft_code = '320' AND fare_conditions = 'Business';

-- 9.	Найти максимальную и минимальную сумму бронирования в 2017 году;
SELECT MAX(total_amount) AS MAX_SUM, MIN(total_amount) AS MIN_SUM FROM lanit.bookings
    WHERE TRUNC(book_date, 'YEAR') = '01.01.2017';

-- 10.	Найти количество мест во всех самолетах;
SELECT ad.model, COUNT(s.seat_no) AS NUMBER_OF_SEATS FROM lanit.seats s
    INNER JOIN lanit.aircrafts_data ad ON s.aircraft_code = ad.aircraft_code
    GROUP BY ad.model
    ORDER BY ad.model;

-- 11.	Найти количество мест во всех самолетах с учетом типа места;
SELECT ad.model, s.fare_conditions, COUNT(s.seat_no) AS NUMBER_OF_SEATS FROM lanit.seats s
    INNER JOIN lanit.aircrafts_data ad ON s.aircraft_code = ad.aircraft_code
    GROUP BY ad.model, s.fare_conditions
    ORDER BY ad.model, s.fare_conditions;

-- 12.	Найти количество билетов пассажира ALEKSANDR STEPANOV, телефон которого заканчивается на 11;
SELECT COUNT(passenger_name) AS AMOUNT_TICKETS FROM lanit.tickets
    WHERE passenger_name = 'ALEKSANDR STEPANOV' AND phone LIKE '%11';

-- 13.	Вывести всех пассажиров с именем ALEKSANDR, у которых количество билетов больше 2000. Отсортировать по убыванию количества билетов;
SELECT passenger_name, COUNT(*) AS AMOUNT_TICKETS FROM lanit.tickets
    WHERE passenger_name LIKE 'ALEKSANDR %' GROUP BY passenger_name
    HAVING COUNT(*) > 2000 ORDER BY amount_tickets DESC;

-- 14.	Вывести дни в сентябре 2017 с количеством рейсов больше 500.
SELECT COUNT(*) AS "AMOUNT", TO_CHAR(date_departure, 'dd') AS "DATE"
    FROM lanit.flights WHERE TRUNC(date_departure, 'mm') = '01.09.17'
    GROUP BY TO_CHAR(date_departure, 'dd') HAVING COUNT(*) > 500
    ORDER BY TO_CHAR(date_departure, 'dd');

-- 15.	Вывести список городов, в которых несколько аэропортов
SELECT city, COUNT(*) AS AMOUNT FROM lanit.airports_data GROUP BY city HAVING COUNT(city) > 1;

-- 16.	Вывести модель самолета и список мест в нем
SELECT ad.model, LISTAGG(s.seat_no, ', ') WITHIN GROUP (ORDER BY s.seat_no) AS SEATS FROM lanit.aircrafts_data ad
    INNER JOIN lanit.seats s ON ad.aircraft_code = s.aircraft_code GROUP BY ad.model;

-- 17.	Вывести информацию по всем рейсам из аэропортов в г.Москва за сентябрь 2017
SELECT ad1.airport_name AS DEPARTURE, ad2.airport_name AS ARRIVAL FROM lanit.flights f
    INNER JOIN lanit.airports_data ad1 ON f.departure_airport = ad1.airport_code
    INNER JOIN lanit.airports_data ad2 ON f.arrival_airport = ad2.airport_code
    WHERE ad1.city = 'Moscow' AND TRUNC(f.date_departure, 'mm') = '01.09.17'
    GROUP BY ad1.airport_name, ad2.airport_name
    ORDER BY ad1.airport_name, ad2.airport_name;

-- 18.	Вывести кол-во рейсов по каждому аэропорту в г.Москва за 2017
SELECT COUNT(*) AS SUM_FLIGHTS, ad.airport_name AS AIRPORT FROM lanit.flights f
    INNER JOIN lanit.airports_data ad ON f.departure_airport = ad.airport_code
    WHERE ad.city = 'Moscow' AND TRUNC(f.date_departure, 'yy') = '01.01.17'
    GROUP BY ad.airport_name;

-- 19.	Вывести кол-во рейсов по каждому аэропорту, месяцу в г.Москва за 2017
SELECT COUNT(ad.airport_name) AS SUM_FLIGHTS, TO_CHAR(f.date_departure, 'mm') AS MONTH, ad.airport_name
    FROM lanit.flights f
    INNER JOIN lanit.airports_data ad ON f.departure_airport = ad.airport_code
    WHERE ad.city = 'Moscow' AND TRUNC(f.date_departure, 'yy') =  '01.01.17'
    GROUP BY TO_CHAR(f.date_departure, 'mm'), ad.airport_name
    ORDER BY TO_CHAR(f.date_departure, 'mm'), ad.airport_name;

-- 20.	Найти все билеты по бронированию на «3A4B»
SELECT ticket_no FROM lanit.tickets WHERE book_ref LIKE '3A4B%';

-- 21.	Найти все перелеты по бронированию на «3A4B»
SELECT tf.flight_id, t.book_ref FROM lanit.tickets t
    INNER JOIN lanit.ticket_flights tf ON t.ticket_no = tf.ticket_no
    WHERE t.book_ref LIKE '3A4B%';
