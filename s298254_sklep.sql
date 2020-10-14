CREATE SCHEMA sklep;
SET search_path TO sklep;

-- tables
-- Table: producenci

CREATE TABLE IF NOT EXISTS producenci (
    id_producenta serial  NOT NULL,
    nazwa_producenta varchar(50)  NOT NULL,
    mail varchar(50)  NOT NULL,
    telefon varchar(17)  NOT NULL,
    CONSTRAINT producenci_pk PRIMARY KEY (id_producenta)
);

CREATE INDEX producenci_idx_1 on producenci (id_producenta ASC);

-- Table: produkty
CREATE TABLE IF NOT EXISTS produkty (
    id_produktu serial  NOT NULL,
    nazwa_produktu varchar(50)  NOT NULL,
    cena decimal(10,2)  NOT NULL,
    id_producenta int  NOT NULL,
    CONSTRAINT produkty_pk PRIMARY KEY (id_produktu)
);

CREATE INDEX produkty_idx_1 on produkty (id_produktu ASC);

-- Table: zamowienia
CREATE TABLE IF NOT EXISTS zamowienia (
    id_zamowenia serial  NOT NULL,
    data date  NOT NULL,
    ilosc_zamowien int  NOT NULL,
    id_producenta int  NOT NULL,
    id_produktu int  NOT NULL,
    CONSTRAINT zamowienia_pk PRIMARY KEY (id_zamowenia)
);

CREATE INDEX zamowienia_idx_1 on zamowienia (id_zamowenia ASC);

-- foreign keys
-- Reference: produkty_producenci (table: produkty)
ALTER TABLE produkty ADD CONSTRAINT produkty_producenci
    FOREIGN KEY (id_producenta)
    REFERENCES producenci (id_producenta)
    ON DELETE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: zamowienia_producenci (table: zamowienia)
ALTER TABLE zamowienia ADD CONSTRAINT zamowienia_producenci
    FOREIGN KEY (id_producenta)
    REFERENCES producenci (id_producenta)
    ON DELETE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: zamowienia_produkty (table: zamowienia)
ALTER TABLE zamowienia ADD CONSTRAINT zamowienia_produkty
    FOREIGN KEY (id_produktu)
    REFERENCES produkty (id_produktu)
    ON DELETE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;