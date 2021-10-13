-- 1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
SELECT model, speed, hd FROM PC WHERE price < '500';

-- 2. Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker FROM product WHERE type = 'printer';

-- 3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT model, ram, screen FROM laptop WHERE price > '1000';

-- 4. Найдите все записи таблицы Printer для цветных принтеров.
SELECT * FROM printer WHERE color = 'y';

-- 5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT model, speed, hd FROM pc WHERE (cd = '12x' OR cd = '24x') AND price < '600';

-- 6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
SELECT DISTINCT maker as Maker, laptop.speed FROM laptop 
	INNER JOIN product ON product.model = laptop.model 
	WHERE laptop.hd >= '10' ORDER BY Maker ASC, laptop.speed;

-- 7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
SELECT DISTINCT PC.model, PC.price FROM Product 
	INNER JOIN PC ON Product.model = PC.model WHERE Product.maker = 'B'
UNION 
SELECT DISTINCT Laptop.model, Laptop.price FROM Product 
	INNER JOIN Laptop ON Product.model = Laptop.model WHERE Product.maker = 'B'
UNION
SELECT DISTINCT Printer.model, Printer.price FROM Product 
	INNER JOIN Printer ON Product.model = Printer.model WHERE Product.maker = 'B';

-- 8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT maker FROM Product WHERE type = 'PC'
EXCEPT
SELECt maker FROM PRoduct WHERE type = 'Laptop';

-- 9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT DISTINCT product.maker AS Maker FROM product INNER JOIN pc ON product.model = pc.model WHERE pc.speed >= '450';

-- 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
SELECT model, price FROM printer WHERE price = (SELECT MAX(price) FROM printer);

-- 11. Найдите среднюю скорость ПК.
SELECT AVG(speed) as Avg_speed FROM pc;

-- 12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
SELECT AVG(speed) FROM laptop WHERE price > '1000';

-- 13. Найдите среднюю скорость ПК, выпущенных производителем A.
SELECT AVG(speed) as Avg_speed FROM pc INNER JOIN product ON pc.model = product.model WHERE product.maker = 'A';

-- 15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT DISTINCT hd FROM pc GROUP BY hd HAVING COUNT(hd) >=2;

-- 16. Найдите пары моделей PC, имеющих одинаковые скорость и RAM. 
--     В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), 
--     Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram FROM pc AS pc1, pc AS pc2 
WHERE (pc1.speed = pc2.speed AND pc1.ram = pc2.ram) AND pc1.model > pc2.model;

-- 17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed
SELECT DISTINCT Product.type AS Type, Laptop.model AS Model, Laptop.speed FROM Product 
	INNER JOIN Laptop ON Product.model = Laptop.model 
	WHERE Laptop.speed < ALL (SELECT MIN(speed) FROM PC);

-- 18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
SELECT DISTINCT Product.maker AS Maker, Printer.price AS price FROM Product 
	INNER JOIN Printer ON Product.model = Printer.model 
	WHERE Printer.color = 'y' AND Printer.price = (SELECT MIN(price) FROM Printer WHERE color = 'y');

-- 19. Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
--	   Вывести: maker, средний размер экрана.
SELECT DISTINCT p.maker, AVG(l.screen) FROM product AS p INNER JOIN laptop AS l ON p.model = l.model GROUP BY p.maker;

-- 20. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
SELECT maker AS Maker, COUNT(model) AS Count_Model FROM Product WHERE type = 'PC' GROUP BY Maker HAVING COUNT(model) > 2;

-- 21. Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
--     Вывести: maker, максимальная цена.
SELECT p.maker, MAX(pc.price) AS max FROM product AS p INNER JOIN pc ON p.model = pc.model GROUP BY p.maker;

-- 22. Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью.
--     Вывести: speed, средняя цена.
SELECT speed, AVG(price) AS avg FROM pc WHERE speed > '600' GROUP BY speed;

-- 23. Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц,
--     так и ПК-блокноты со скоростью не менее 750 МГц. Вывести: Maker
SELECT DISTINCT Product.maker FROM Product
    INNER JOIN PC ON Product.model = PC.model WHERE PC.speed >= 750
INTERSECT
SELECT DISTINCT Product.maker FROM Product
    INNER JOIN Laptop ON Product.model = Laptop.model WHERE Laptop.speed >= 750;

-- 24. Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
WITH union_tables(model, price) AS (
    SELECT model, price FROM PC
    UNION
    SELECT model, price FROM Laptop
    UNION
    SELECT model, price FROM Printer)
SELECT model FROM union_tables WHERE price >= ALL(SELECT MAX(price) FROM union_tables);
