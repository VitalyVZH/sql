-- 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
SELECT cl.class, s.name, cl.country FROM classes AS cl 
	INNER JOIN ships AS s ON cl.class = s.class WHERE cl.numGuns >= '10';

-- 31. Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
SELECT class, country FROM Classes WHERE bore >= 16.0;

-- 33. Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
SELECT ship FROM outcomes WHERE battle = 'North Atlantic' AND result = 'sunk';

-- 36. Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
SELECT name FROM Ships AS s WHERE s.name = s.class
UNION
SELECT ship FROM Outcomes AS o INNER JOIN Classes AS c ON o.ship = c.class;