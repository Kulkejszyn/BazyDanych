-- 1-3 Import przez gui

-- 4. Wyznacz liczbę budynków (tabela: popp, atrybut: f_codedesc, reprezentowane, jako punkty)
-- położonych w odległości mniejszej niż 100000 m od głównych rzek. Budynki spełniające to
-- kryterium zapisz do osobnej tabeli tableB

CREATE TABLE tableB AS
SELECT popp.*
FROM popp,
     majrivers
WHERE popp.f_codedesc = 'Building'
GROUP BY popp.gid
HAVING MIN(ST_Distance(majrivers.geom, popp.geom)) < 100000;

SELECT COUNT(1)
FROM tableB;


-- 5. Utwórz tabelę o nazwie airportsNew. Z tabeli airports do airportsNew zaimportuj nazwy lotnisk,
-- ich geometrię, a także atrybut elev, reprezentujący wysokość n.p.m.
CREATE TABLE airportsNew AS
SELECT name, geom, elev
FROM airports;
-- a) Znajdź lotnisko, które położone jest najbardziej na zachód i najbardziej na wschód.

SELECT MIN(ST_Y(geom)), MAX(ST_Y(geom))
FROM airportsNew;
--zachod
CREATE VIEW zachod AS
SELECT *
FROM airportsNew
ORDER BY ST_Y(geom) DESC
LIMIT 1;
--wschod
CREATE VIEW wschod AS
SELECT *
FROM airportsNew
ORDER BY ST_Y(geom)
LIMIT 1;

SELECT *
FROM wschod;
SELECT *
FROM zachod;

-- b) Do tabeli airportsNew dodaj nowy obiekt - lotnisko, które położone jest w punkcie
-- środkowym drogi pomiędzy lotniskami znalezionymi w punkcie a. Lotnisko nazwij airportB.
-- Wysokość n.p.m. przyjmij dowolną.

SELECT ST_Centroid(ST_MakeLine((SELECT geom FROM wschod), (SELECT geom FROM zachod)));
INSERT INTO airportsNew (name, geom, elev)
VALUES ('airportB',
        (SELECT ST_Centroid(ST_MakeLine((SELECT geom FROM wschod), (SELECT geom FROM zachod)))),
        12);
-- 6. Wyznacz pole powierzchni obszaru, który oddalony jest mniej niż 1000 jednostek od najkrótszej
-- linii łączącej jezioro o nazwie ‘Iliamna Lake’ i lotnisko o nazwie „AMBLER”
SELECT ST_Area(ST_Buffer(ST_ShortestLine(
                                     (SELECT geom FROM lakes WHERE names LIKE 'Iliamna Lake'),
                                     (SELECT geom FROM airports WHERE name LIKE 'AMBLER')
                             ), 1000));

-- 7. Napisz zapytanie, które zwróci sumaryczne pole powierzchni poligonów reprezentujących
-- poszczególne typy drzew znajdujących się na obszarze tundry i bagien.

SELECT sum(st_area(trees.geom)), trees.cat
FROM trees
         RIGHT JOIN tundra t ON trees.cat = t.cat
         RIGHT JOIN swamp s ON s.cat = s.cat
GROUP BY trees.cat;
