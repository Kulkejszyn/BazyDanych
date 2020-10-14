-- aby zaimportowac ddl nalezy w psql wraz z wybrana baza uzyc komendy
-- \i <path*.sql>

--6
INSERT INTO producenci (nazwa_producenta, mail, telefon)
VALUES ('Producent 1', 'producent1@gmail.com', '12345678'),
       ('Producent 2', 'producent2@gmail.com', '87654321'),
       ('Producent 3', 'producent3@gmail.com', '12312312'),
       ('Producent 4', 'producent4@gmail.com', '23423423'),
       ('Producent 5', 'producent5@gmail.com', '45645645'),
       ('Producent 6', 'producent6@gmail.com', '56756756'),
       ('Producent 7', 'producent7@gmail.com', '67867867'),
       ('Producent 8', 'producent8@gmail.com', '78978978'),
       ('Producent 9', 'producent9@gmail.com', '89089089'),
       ('Producent 0', 'producent0@gmail.com', '90190190');

INSERT INTO produkty (nazwa_produktu, cena, id_producenta)
VALUES ('Klawiatura', 359.99, 1),
       ('Monster', 2.00, 2),
       ('Iphone 10', 2450.00, 3),
       ('Podkladka', 100.00, 4),
       ('Myszka', 299.99, 5),
       ('Rosół', 12799.99, 6),
       ('Porfel', 99.00, 7),
       ('RTX-3070', 2399.99, 8),
       ('Cyberpunk', 259.99, 9),
       ('Roler', 59.99, 10);

INSERT INTO zamowienia (data, ilosc_zamowien, id_producenta, id_produktu)
VALUES ('2020-10-14', 5132331, 10, 1),
       ('2020-10-15', 31981239, 9, 2),
       ('2020-06-24', 516, 1, 3),
       ('2020-01-05', 123, 2, 4),
       ('2020-02-22', 432, 3, 5),
       ('2020-03-19', 2143, 4, 6),
       ('2020-04-28', 234, 5, 7),
       ('2020-05-01', 234, 6, 8),
       ('2020-06-12', 34, 7, 9),
       ('2020-07-09', 2342, 8, 10);

-- 7-10

-- pg_dump -U postgres s298254 > s298254_backup.sql
--
-- DROP DATABASE s298254;
-- CREATE DATABASE backup298254;
--
-- psql -U postgres backup298254 < s283109_backup.sql
-- (psql) \l
-- ALTER DATABASE backup298254 RENAME TO "s298254";

--11
SELECT CONCAT('Producent: ', nazwa_producenta, ', liczba_zamowien: ', COUNT(producenci.id_producenta),
              ', wartosc_zamowienia: ', ilosc_zamowien * cena)
FROM zamowienia
         INNER JOIN produkty ON zamowienia.id_produktu = produkty.id_produktu
         INNER JOIN producenci ON produkty.id_producenta = producenci.id_producenta
GROUP BY producenci.id_producenta, ilosc_zamowien, produkty.cena;

SELECT CONCAT('Producent: ', nazwa_produktu, ', liczba_zamowien: ', COUNT(id_zamowenia))
FROM zamowienia
         INNER JOIN produkty ON produkty.id_produktu = zamowienia.id_produktu
GROUP BY nazwa_produktu;

SELECT *
FROM produkty
         NATURAL JOIN zamowienia;

ALTER TABLE zamowienia
    ADD COLUMN data DATE;

SELECT *
FROM zamowienia
WHERE EXTRACT(MONTH FROM data) = 01;

SELECT EXTRACT(ISODOW FROM data) as day, COUNT(id_zamowenia)
FROM zamowienia
GROUP BY day
ORDER BY COUNT(id_zamowenia) DESC;

SELECT nazwa_produktu, COUNT(zamowienia.id_produktu) as counta
FROM produkty
         INNER JOIN zamowienia ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY produkty.nazwa_produktu
ORDER BY counta DESC;

--  12.
SELECT CONCAT('Produkt ', UPPER(nazwa_produktu), ', którego producentem jest ', LOWER(nazwa_producenta), ', zamówiono ',
              COUNT(id_zamowenia), ' razy') as opis
FROM zamowienia
         RIGHT JOIN produkty ON zamowienia.id_produktu = produkty.id_produktu
         JOIN producenci ON produkty.id_producenta = producenci.id_producenta
GROUP BY nazwa_produktu, nazwa_producenta
ORDER BY(COUNT(id_zamowenia)) DESC;

SELECT zamowienia.*, produkty.*, SUM(ilosc_zamowien * cena) as cena_ilosc
FROM zamowienia
         JOIN produkty ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY zamowienia.id_zamowenia, produkty.id_produktu
ORDER BY cena_ilosc DESC
LIMIT(SELECT COUNT(*) FROM zamowienia) - 3;

CREATE TABLE klienci
(
    id_klienta    SERIAL,
    nazwa_klienta VARCHAR(50) NOT NULL,
    mail          varchar(50) NOT NULL,
    telefon       varchar(17)
);
ALTER TABLE klienci
    ADD PRIMARY KEY (id_klienta);

ALTER TABLE zamowienia
    ADD COLUMN id_klienta INT REFERENCES klienci (id_klienta);

INSERT INTO klienci(mail, telefon, nazwa_klienta)
VALUES ('klient1@klient.pl', '123-123-123', 'klient1'),
       ('klient2@klient.pl', '234-234-234', 'klient2'),
       ('klient3@klient.pl', '345-345-345', 'klient3'),
       ('klient4@klient.pl', '456-456-456', 'klient4'),
       ('klient5@klient.pl', '567-567-567', 'klient5'),
       ('klient6@klient.pl', '678-678-678', 'klient6'),
       ('klient7@klient.pl', '789-789-789', 'klient7');

UPDATE zamowienia
SET id_klienta = 1
WHERE id_zamowenia = 1;
UPDATE zamowienia
SET id_klienta = 2
WHERE id_zamowenia = 2;
UPDATE zamowienia
SET id_klienta = 3
WHERE id_zamowenia = 3;
UPDATE zamowienia
SET id_klienta = 4
WHERE id_zamowenia = 4;
UPDATE zamowienia
SET id_klienta = 5
WHERE id_zamowenia = 5;
UPDATE zamowienia
SET id_klienta = 6
WHERE id_zamowenia = 6;
UPDATE zamowienia
SET id_klienta = 7
WHERE id_zamowenia = 7;
UPDATE zamowienia
SET id_klienta = 1
WHERE id_zamowenia = 8;
UPDATE zamowienia
SET id_klienta = 2
WHERE id_zamowenia = 9;
UPDATE zamowienia
SET id_klienta = 3
WHERE id_zamowenia = 10;

-- e
SELECT klienci.*, nazwa_produktu, ilosc_zamowien, SUM(ilosc_zamowien * cena) as laczna_wartosc
FROM klienci
         INNER JOIN zamowienia ON klienci.id_klienta = zamowienia.id_klienta
         INNER JOIN produkty ON produkty.id_produktu = zamowienia.id_produktu
GROUP BY klienci.id_klienta, nazwa_produktu, ilosc_zamowien;
-- f

SELECT 'NAJCZESCIEJ ZAMAWIAJACY: ' || nazwa_klienta || ' calkowita kwota zamowien: ' || cena
FROM (SELECT nazwa_klienta, SUM(cena * ilosc_zamowien) AS cena
      FROM zamowienia
               INNER JOIN klienci
                          ON zamowienia.id_klienta = klienci.id_klienta
               INNER JOIN produkty ON produkty.id_produktu = zamowienia.id_produktu
      GROUP BY nazwa_klienta
      ORDER BY COUNT(nazwa_klienta) DESC
      LIMIT 1) as foo1
UNION
SELECT 'NAJRZADZIEJ ZAMAWIAJACY: ' || nazwa_klienta || ' calkowita kwota zamowien: ' || cena
FROM (SELECT nazwa_klienta, SUM(cena * ilosc_zamowien) AS cena
      FROM zamowienia
               INNER JOIN klienci ON zamowienia.id_klienta = klienci.id_klienta
               INNER JOIN produkty ON produkty.id_produktu = zamowienia.id_produktu
      GROUP BY nazwa_klienta
      ORDER BY COUNT(nazwa_klienta)
      LIMIT 1) AS foo2;

-- g
DELETE
FROM produkty
WHERE id_produktu IN
      (SELECT produkty.id_produktu FROM produkty WHERE id_produktu NOT IN (SELECT id_produktu FROM zamowienia));

-- 13
-- a
CREATE TABLE numer
(
    liczba INT CHECK (liczba BETWEEN 0 AND 9999)
);
-- b
CREATE SEQUENCE liczba_seq START WITH 100 INCREMENT BY 5 MINVALUE 0 MAXVALUE 125 CYCLE;
-- c
INSERT INTO numer
VALUES (nextval('liczba_seq'));
-- d
ALTER SEQUENCE liczba_seq INCREMENT BY 6;
-- e
SELECT currval('liczba_seq');
SELECT nextval('liczba_seq');
-- f
DROP sequence liczba_seq;

--  14.
-- a
-- \du
-- b
CREATE USER superuser298254 WITH SUPERUSER;
CREATE USER guest298254;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep, firma TO guest298254;
-- \du

-- c
DROP OWNED BY guest298254;
DROP USER guest298254;

-- 15
-- a
BEGIN;
UPDATE produkty
SET cena = cena + CAST(10 as NUMERIC);
COMMIT;

-- b
BEGIN;

UPDATE produkty
SET cena = 1.1 * cena
WHERE id_produktu = 3;

SAVEPOINT S1;

UPDATE zamowienia
SET ilosc_zamowien = 1.25 * ilosc_zamowien;

SAVEPOINT S2;

DELETE
FROM klienci
WHERE id_klienta IN (SELECT klienci.id_klienta
                     FROM klienci
                              JOIN zamowienia ON zamowienia.id_klienta = klienci.id_klienta
                              JOIN produkty ON zamowienia.id_produktu = produkty.id_produktu
                     GROUP BY klienci.id_klienta
                     ORDER BY SUM(cena * ilosc_zamowien) DESC
                     LIMIT 1);

ROLLBACK TO S1;
ROLLBACK TO S2;
ROLLBACK;
COMMIT;
-- c

CREATE OR REPLACE FUNCTION PobierzUdzialy()
    RETURNS TABLE
            (
                procent text
            )
AS
$func$
BEGIN
    RETURN QUERY
        SELECT CONCAT(nazwa_produktu, ' - ',
                      (COUNT(id_zamowenia) / CAST((SELECT COUNT(*) FROM zamowienia) AS FLOAT)) * 100, '%')
        FROM producenci
                 JOIN produkty ON id_producenta = id_producenta
                 JOIN zamowienia ON id_produktu = id_produktu
        GROUP BY (id_producenta, id_zamowenia, nazwa_producenta);
END
$func$ LANGUAGE plpgsql;