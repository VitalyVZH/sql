-- 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
SELECT cl.class, s.name, cl.country FROM classes AS cl 
	INNER JOIN ships AS s ON cl.class = s.class WHERE cl.numGuns >= '10';