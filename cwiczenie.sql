-- http://home.agh.edu.pl/~wsarlej/dyd/bdp/materialy/cw1/Cwiczenia1-powtorkaSQLcz.1.pdf
-- 1,2,3,4
-- CREATE DATABASE s298254;
-- CREATE SCHEMA firma;
--
-- CREATE ROLE ksiegowosc;
-- GRANT USAGE ON SCHEMA firma TO ksiegowosc;
-- GRANT SELECT ON ALL TABLES IN SCHEMA firma TO ksiegowosc;

-- 4a
CREATE TABLE IF NOT EXISTS pracownicy
(
    id_pracownika SERIAL,
    imie          VARCHAR NOT NULL,
    nazwisko      VARCHAR NOT NULL,
    adres         VARCHAR NOT NULL,
    telefon       VARCHAR
);

CREATE TABLE IF NOT EXISTS godziny
(
    id_godziny    SERIAL,
    data          DATE    NOT NULL,
    liczba_godzin INTEGER NOT NULL,
    id_pracownika INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS pensja_stanowisko
(
    id_pensji  SERIAL,
    stanowisko VARCHAR NOT NULL,
    kwota      NUMERIC(6, 2)
);

CREATE TABLE IF NOT EXISTS premia
(
    id_premii SERIAL,
    rodzaj    VARCHAR NOT NULL,
    kwota     NUMERIC(6, 2)
);

CREATE TABLE IF NOT EXISTS wynagrodzenie
(
    id_wynagrodzenia SERIAL,
    data             DATE    NOT NULL,
    id_pracownika    INTEGER NOT NULL,
    id_godziny       INTEGER NOT NULL,
    id_pensji        INTEGER NOT NULL,
    id_premii        INTEGER NOT NULL
);

-- 4b
ALTER TABLE pracownicy
    ADD PRIMARY KEY (id_pracownika);
ALTER TABLE godziny
    ADD PRIMARY KEY (id_godziny);
ALTER TABLE pensja_stanowisko
    ADD PRIMARY KEY (id_pensji);
ALTER TABLE premia
    ADD PRIMARY KEY (id_premii);
ALTER TABLE wynagrodzenie
    ADD PRIMARY KEY (id_wynagrodzenia);
-- 4c
ALTER TABLE godziny
    ADD CONSTRAINT godziny_pracownik
        FOREIGN KEY (id_pracownika)
            REFERENCES pracownicy (id_pracownika);

ALTER TABLE wynagrodzenie
    ADD CONSTRAINT wynagrodzenie_pracownik
        FOREIGN KEY (id_pracownika)
            REFERENCES pracownicy (id_pracownika);

ALTER TABLE wynagrodzenie
    ADD CONSTRAINT wynagrodzenie_pensja
        FOREIGN KEY (id_pensji)
            REFERENCES pensja_stanowisko (id_pensji);

ALTER TABLE wynagrodzenie
    ADD CONSTRAINT wynagrodzenie_premia
        FOREIGN KEY (id_premii)
            REFERENCES premia (id_premii);

ALTER TABLE wynagrodzenie
    ADD CONSTRAINT wynagrodzenie_godzina
        FOREIGN KEY (id_godziny)
            REFERENCES godziny (id_godziny);

-- 4d
CREATE INDEX index_pracownicy ON pracownicy USING BTREE (id_pracownika);
CREATE INDEX index_godziny ON godziny USING BTREE (id_godziny);
CREATE INDEX index_pensja_stanowisko ON pensja_stanowisko USING BTREE (id_pensji);
CREATE INDEX index_premia ON premia USING BTREE (id_premii);
CREATE INDEX index_wynagrodzenie ON wynagrodzenie USING BTREE (id_wynagrodzenia);
-- 4e
COMMENT ON COLUMN pracownicy.id_pracownika IS 'pracownik PK';
COMMENT ON COLUMN godziny.id_godziny IS 'godziny PK';
COMMENT ON COLUMN pensja_stanowisko.id_pensji IS 'pensja PK';
COMMENT ON COLUMN premia.id_premii IS 'premia PK';
COMMENT ON COLUMN wynagrodzenie.id_premii IS 'wynagrodznie PK';
--4f?

-- 5
INSERT INTO pracownicy VALUES
    ('Jan', 'Kowalski', 'Reymonta', '123456789'),
    ('Pawel', 'Kowalski', 'Reymonta', '222222222'),
    ('Ola', 'Kowalski', 'Reymonta', '666666666'),
    ('Kasd', 'Kowalski', 'Reymonta', '777777777'),
    ('asda', 'Kowalski', 'Gdanska', '888888888'),
    ('DF', 'Kowalski', 'Sieplpia', '999999999'),
    ('Hehe', 'Kowalski', 'Reymonta', '199456789'),
    ('Imie', 'Kowalski', 'Reymonta', '123556789'),
    ('Imiedlugie', 'Kowalski', 'Reymonta', '111456789'),
    ('Jan', 'Kowalski', 'Reymonta', '123456351'),
    ('Jan', 'Kowalski', 'Reymonta', '123459999');

ALTER TABLE godziny
    ADD week DATE;

ALTER TABLE godziny
    ADD month DATE;

ALTER TABLE wynagrodzenie
    ALTER COLUMN data TYPE VARCHAR;

-- 6
SELECT id_pracownika, nazwisko
FROM pracownicy;

SELECT *
FROM pracownicy
WHERE imie LIKE 'J%';

SELECT *
FROM pracownicy
WHERE nazwisko LIKE '%n%'
  AND imie LIKE '%a';

SELECT pracownicy.imie, pracownicy.nazwisko, godziny.liczba_godzin - 160 AS nadgodziny
FROM pracownicy
         INNER JOIN godziny ON pracownicy.id_pracownika = godziny.id_pracownika;

SELECT wynagrodzenie.id_pracownika, pensja_stanowisko.kwota
FROM wynagrodzenie
         INNER JOIN pensja_stanowisko ON wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji
WHERE pensja_stanowisko.kwota > 1500
  and pensja_stanowisko.kwota < 3000;

-- 7
SELECT wynagrodzenie.id_pracownika
FROM wynagrodzenie
         INNER JOIN pensja_stanowisko ON wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji
ORDER BY pensja_stanowisko.kwota DESC;

SELECT wynagrodzenie.id_pracownika
FROM wynagrodzenie
         INNER JOIN pensja_stanowisko ON wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji
         INNER JOIN premia ON wynagrodzenie.id_premii = premia.id_premii
ORDER BY pensja_stanowisko.kwota, premia.kwota DESC;

-- 8



-- 9