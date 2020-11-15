-- 1-- Utwórz tabelę obiekty. W tabeli umieść nazwy i geometrie obiektów przedstawionych poniżej.
-- Układ odniesienia ustal jako niezdefiniowany

DROP TABLE obiekty;
CREATE TABLE obiekty
(
    id_obiektu serial,
    nazwa      varchar(10),
    geometria  geometry
);

--a)
INSERT INTO obiekty(nazwa, geometria)
VALUES ('obiekt1', ST_COLLECT(ARRAY [
    'LINESTRING(0 1, 1 1)',
    'CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1)',
    'LINESTRING(5 1, 6 1)'
    ]));

-- b
INSERT INTO obiekty(nazwa, geometria)
VALUES ('obiekt2', ST_COLLECT(ARRAY [
    'LINESTRING(10 2, 10 6, 14 6)',
    'CIRCULARSTRING(14 6, 16 4, 14 2)',
    'CIRCULARSTRING(14 2, 12 0, 10 2)',
    'CIRCULARSTRING(13 2, 11 2, 13 2)'
    ]));

-- c
INSERT INTO obiekty (nazwa, geometria)
VALUES ('obiekt3', 'POLYGON((10 17, 12 13, 7 15, 10 17))');

-- d
INSERT INTO obiekty (nazwa, geometria)
VALUES ('obiekt4', 'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)');

--e)
INSERT INTO obiekty (nazwa, geometria)
VALUES ('obiekt5', 'MULTIPOINT(30 30 59, 38 32 234)');

--f)
INSERT INTO obiekty (nazwa, geometria)
VALUES ('obiekt6', ST_Collect('LINESTRING(1 1, 3 2)', 'POINT(4 2)'));

-- 2
-- Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół
-- najkrótszej linii łączącej obiekt 3 i 4
SELECT ST_Area(ST_Buffer(ST_ShortestLine(a.geometria, b.geometria), 5))
FROM obiekty a,
     obiekty b
WHERE a.nazwa = 'obiekt3'
  AND b.nazwa = 'obiekt4';

-- 3
-- Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to
-- zadanie? Zapewnij te warunki.
-- musi byc figura zamknieta
UPDATE obiekty
SET geom = ST_MakePolygon(ST_AddPoint(geom, 'POINT(20 20)'))
WHERE nazwa = 'obiekt4';

-- 4
--  W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4.
INSERT INTO obiekty(nazwa, geometria)
VALUES ('obiekt7', ST_Collect(
            (SELECT geometria FROM obiekty WHERE nazwa LIKE 'obiekt3'),
            (SELECT geometria FROM obiekty WHERE nazwa LIKE 'obiekt4')
    ));
-- 5
-- Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone
-- wokół obiektów nie zawierających łuków
SELECT SUM(ST_Area(ST_Buffer(geometria, 5)))
FROM obiekty
WHERE ST_HasArc(geometria) = FALSE;
