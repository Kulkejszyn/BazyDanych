CREATE SCHEMA firma;
SET search_path TO firma;

-- tables
-- Table: godziny
CREATE TABLE IF NOT EXISTS godziny (
    id_godziny serial  NOT NULL,
    data date  NOT NULL,
    liczba_godzin int  NOT NULL,
    id_pracownika int  NOT NULL,
    CONSTRAINT godziny_pk PRIMARY KEY (id_godziny)
);

-- Table: pensja_stanowisko
CREATE TABLE IF NOT EXISTS pensja_stanowisko (
    id_pensji serial  NOT NULL,
    stanowisko varchar(50)  NOT NULL,
    kwota decimal(10,2)  NOT NULL,
    CONSTRAINT pensja_stanowisko_pk PRIMARY KEY (id_pensji)
);

-- Table: pracownicy
CREATE TABLE IF NOT EXISTS pracownicy (
    id_pracownika serial  NOT NULL,
    imie varchar(50)  NOT NULL,
    nazwisko varchar(50)  NOT NULL,
    adres varchar(50)  NOT NULL,
    telefon varchar(17)  NOT NULL,
    CONSTRAINT pracownicy_pk PRIMARY KEY (id_pracownika)
);

-- Table: premia
CREATE TABLE IF NOT EXISTS premia (
    id_premii serial  NOT NULL,
    rodzaj varchar(50)  NOT NULL,
    kwota decimal(10,2)  NOT NULL,
    CONSTRAINT premia_pk PRIMARY KEY (id_premii)
);

-- Table: wynagrodzenie
CREATE TABLE IF NOT EXISTS wynagrodzenie (
    id_wynagrodzenia serial  NOT NULL,
    data date  NOT NULL,
    id_pracownika int  NOT NULL,
    id_godziny int  NOT NULL,
    id_pensji int  NOT NULL,
    id_premii int  NOT NULL,
    CONSTRAINT wynagrodzenie_pk PRIMARY KEY (id_wynagrodzenia)
);

-- foreign keys
-- Reference: godziny_pracownicy (table: godziny)
ALTER TABLE godziny ADD CONSTRAINT godziny_pracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES pracownicy (id_pracownika)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_godziny (table: wynagrodzenie)
ALTER TABLE wynagrodzenie ADD CONSTRAINT wynagrodzenie_godziny
    FOREIGN KEY (id_godziny)
    REFERENCES godziny (id_godziny)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_pensja_stanowisko (table: wynagrodzenie)
ALTER TABLE wynagrodzenie ADD CONSTRAINT wynagrodzenie_pensja_stanowisko
    FOREIGN KEY (id_pensji)
    REFERENCES pensja_stanowisko (id_pensji)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_pracownicy (table: wynagrodzenie)
ALTER TABLE wynagrodzenie ADD CONSTRAINT wynagrodzenie_pracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES pracownicy (id_pracownika)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_premia (table: wynagrodzenie)
ALTER TABLE wynagrodzenie ADD CONSTRAINT wynagrodzenie_premia
    FOREIGN KEY (id_premii)
    REFERENCES premia (id_premii)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;
