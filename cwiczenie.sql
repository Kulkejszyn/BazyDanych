-- 3pos
CREATE TABLE budynki
(
    id        SERIAL PRIMARY KEY,
    geometria GEOMETRY,
    nazwa     VARCHAR(50)
);
CREATE TABLE drogi
(
    id        SERIAL PRIMARY KEY,
    geometria GEOMETRY,
    nazwa     VARCHAR(50)
);
CREATE TABLE punkty_informacyjne
(
    id        SERIAL PRIMARY KEY,
    geometria GEOMETRY,
    nazwa     VARCHAR(50)
);


-- 4

INSERT INTO budynki(geometria, nazwa)
VALUES (st_geogfromtext('POLYGON((10.5 4,10.5 1.5, 8 1.5,8 4, 10.5 4))'), 'BuildingA'),
       (st_geogfromtext('POLYGON((6 7, 6 5, 4 5, 4 7, 6 7))'), 'BuildingB'),
       (st_geogfromtext('POLYGON((5 8, 5 6, 3 6, 3 8, 5 8))'), 'BuildingC'),
       (st_geogfromtext('POLYGON((10 9, 10 8, 9 8, 9 9, 10 9))'), 'BuildingD'),
       (st_geogfromtext('POLYGON((2 2, 2 1, 1 1, 1 2, 2 2))'), 'BuildingF');

INSERT INTO drogi(geometria, nazwa)
VALUES (st_makeline(st_makeline('POINT(0 4.5)'), st_makeline('POINT(12 4.5)')), 'RoadX'),
       (st_makeline(st_makeline('POINT(7.5 0)'), st_makeline('POINT(12 10.5)')), 'RoadY');

INSERT INTO punkty_informacyjne(geometria, nazwa)
VALUES (st_geogfromtext('POINT(1 3.5)'), 'G'),
       (st_geogfromtext('POINT(5.5 1.5)'), 'H'),
       (st_geogfromtext('POINT(9.5 6)'), 'I'),
       (st_geogfromtext('POINT(6.5 6)'), 'J'),
       (st_geogfromtext('POINT(6 9.5)'), 'K');

-- ST_Length, ST_Area, ST_Distance, ST_Buffer, ST_Intersection, ST_GeomFromText,
-- ST_Contains, ST_X, ST_Y

-- a. Wyznacz całkowitą długość dróg w analizowanym mieście.
SELECT SUM(st_length(geometria))
FROM drogi;

-- b. Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego
-- budynek o nazwie BuildingA.
SELECT st_asewkt(geometria), st_area(geometria), st_perimeter(geometria)
FROM budynki
WHERE nazwa LIKE '%A';

-- c. Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki
-- posortuj alfabetycznie.
SELECT nazwa, st_area(geometria)
FROM budynki
ORDER BY nazwa;

-- d. Wypisz nazwy i obwody 2 budynków o największej powierzchni.
SELECT nazwa, st_perimeter(geometria)
FROM budynki
ORDER BY st_area(geometria) DESC
LIMIT 2;

-- e. Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem G.
SELECT st_distance(budynki.geometria, punkty_informacyjne.geometria)
FROM budynki,
     punkty_informacyjne
WHERE budynki.nazwa LIKE '%C'
  and punkty_informacyjne.nazwa = 'G';

-- f. Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości
-- większej niż 0.5 od budynku BuildingB.
-- SELECT SELECT st_area(st_difference(
--         st_buffer((SELECT geometria FROM budynki WHERE nazwa LIKE '%B'), 0.5),
--         (SELECT geometria FROM budynki WHERE nazwa LIKE '%C')
--     ));

SELECT st_area(st_intersection(
        st_buffer((SELECT geometria FROM budynki WHERE nazwa LIKE '%B'), 0.5),
        (SELECT geometria FROM budynki WHERE nazwa LIKE '%C')
    ));

-- g. Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi
--  o nazwie RoadX.

SELECT *
FROM budynki
WHERE ST_Y(ST_Centroid(geometria)) > ST_Y(ST_PointN((SELECT geometria FROM drogi WHERE nazwa LIKE 'RoadX'), 1));

-- 8. Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów
SELECT ST_Area(ST_SymDifference(
            (SELECT geometria FROM budynki WHERE nazwa LIKE 'BuildingC'),
            ST_GeomFromText('POLYGON(( 4 7, 6 7, 6  8, 4 8, 4 7))'))
           );

