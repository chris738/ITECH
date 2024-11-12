DROP DATABASE IF EXISTS krautundrueben;
CREATE DATABASE IF NOT EXISTS krautundrueben;
USE krautundrueben;

-- Tabellen:
CREATE TABLE KUNDE (
    KUNDENNR        INTEGER NOT NULL PRIMARY KEY,
    NACHNAME        VARCHAR(50),
    VORNAME         VARCHAR(50),
    GEBURTSDATUM	  DATE,
    EMAIL           VARCHAR(50)
);

CREATE TABLE ORTE (
    ORTID        INTEGER NOT NULL PRIMARY KEY,
    ORTNAME      VARCHAR(50)
);

CREATE TABLE ADRESSE (
    ADRESSID        INTEGER NOT NULL PRIMARY KEY,
    KUNDENNR        INTEGER NOT NULL,
    STRASSE         VARCHAR(50),
    HAUSNR			    VARCHAR(6),
    PLZ             VARCHAR(5),
    ORT             INTEGER,
    TELEFON         VARCHAR(25),
    FOREIGN KEY (KUNDENNR)    REFERENCES KUNDE (KUNDENNR),
    FOREIGN KEY (ORT) 				REFERENCES ORTE (ORTID)
);

CREATE TABLE BESTELLUNG (
    BESTELLNR        INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    KUNDENNR         INTEGER,
    BESTELLDATUM     DATE,
    RECHNUNGSBETRAG  DECIMAL(10,2),
    FOREIGN KEY (KUNDENNR) REFERENCES KUNDE (KUNDENNR)
);

CREATE TABLE LIEFERANT (
    LIEFERANTENNR   INTEGER NOT NULL PRIMARY KEY,
    LIEFERANTENNAME VARCHAR(50),
    STRASSE         VARCHAR(50),
    HAUSNR			    VARCHAR(6),
    PLZ             VARCHAR(5),
    ORT             INTEGER,
    TELEFON			    VARCHAR(25),
    EMAIL           VARCHAR(50),
    FOREIGN KEY (ORT) 				REFERENCES ORTE (ORTID)
);

CREATE TABLE Allergene (
    AllergenID      INTEGER NOT NULL PRIMARY KEY,
    Name            VARCHAR(50)
);

CREATE TABLE Ernaehrungskategorie (
    ErnaehrungskategorieID  INTEGER NOT NULL PRIMARY KEY,
    Name                    VARCHAR(50)
);

CREATE TABLE ZUTAT(
    ZUTATENNR		    INTEGER NOT NULL PRIMARY KEY,
    LIEFERANT		    INTEGER,
    BEZEICHNUNG     VARCHAR(50),
    EINHEIT        	VARCHAR (25),
    NETTOPREIS      DECIMAL(10,2),
    BESTAND         INTEGER,
	FOREIGN KEY (LIEFERANT)  REFERENCES LIEFERANT (LIEFERANTENNR)
);

CREATE TABLE Naerwerte(
	ZUTATENNR		      INTEGER NOT NULL PRIMARY KEY,
	KALORIEN		      INTEGER,
	KOHLENHYDRATE	    DECIMAL (10,2),
	PROTEIN			      DECIMAL (10,2),
	FETT			        DECIMAL (10,2),
	FOREIGN KEY (ZUTATENNR)  REFERENCES ZUTAT (ZUTATENNR)
);

CREATE TABLE BESTELLUNGZUTAT (
    BESTELLNR       INTEGER NOT NULL,
    ZUTATENNR       INTEGER,
    MENGE     		  INTEGER,
    PRIMARY KEY (BESTELLNR,ZUTATENNR),
    FOREIGN KEY (BESTELLNR) REFERENCES BESTELLUNG (BESTELLNR),
    FOREIGN KEY (ZUTATENNR) REFERENCES ZUTAT (ZUTATENNR)
);

CREATE TABLE REZEPTE (
    REZEPTID    	INTEGER NOT NULL PRIMARY KEY,
    NAME        	VARCHAR(50),
    ZUBEREITUNG 	TEXT
);

CREATE TABLE REZEPTEZUTAT (
    REZEPTID        INTEGER NOT NULL,
    ZUTATENNR       INTEGER,
    MENGE     		  INTEGER,
    PRIMARY KEY (REZEPTID,ZUTATENNR),
    FOREIGN KEY (REZEPTID) 		REFERENCES REZEPTE (REZEPTID),
    FOREIGN KEY (ZUTATENNR) 	REFERENCES ZUTAT (ZUTATENNR)
);

CREATE TABLE Allergene_ZUTAT (
    ZUTATENNR       INTEGER NOT NULL,
    AllergenID     	INTEGER,
    PRIMARY KEY (ZUTATENNR, AllergenID),
    FOREIGN KEY (AllergenID) 	REFERENCES Allergene (AllergenID),
    FOREIGN KEY (ZUTATENNR) 	REFERENCES ZUTAT (ZUTATENNR)
);

CREATE TABLE Kat_ZUTAT (
    ZUTATENNR       		    INTEGER NOT NULL,
    ErnaehrungskategorieID  INTEGER,
    PRIMARY KEY (ZUTATENNR, ErnaehrungskategorieID),
    FOREIGN KEY (ErnaehrungskategorieID) 	REFERENCES Ernaehrungskategorie (ErnaehrungskategorieID),
    FOREIGN KEY (ZUTATENNR) 				REFERENCES ZUTAT (ZUTATENNR)
);

CREATE TABLE Ernaehrungskategorie_REZEPT (
    REZEPTID    			      INTEGER,
    ErnaehrungskategorieID  INTEGER NOT NULL,
    PRIMARY KEY (ErnaehrungskategorieID, REZEPTID),
    FOREIGN KEY (ErnaehrungskategorieID) 	REFERENCES Ernaehrungskategorie (ErnaehrungskategorieID),
    FOREIGN KEY (REZEPTID) 					REFERENCES REZEPTE (REZEPTID)
);


-- Orte --
INSERT INTO ORTE(ORTID, ORTNAME) VALUES
(1, 'Hamburg'),
(2, 'Barsbüttel'),
(3, 'Weseby'),
(4, 'Jork'),
(5, 'Dechow');

-- Kunden --
INSERT INTO KUNDE (KUNDENNR, NACHNAME, VORNAME, GEBURTSDATUM, EMAIL) VALUES
(2001, 'Wellensteyn','Kira','1990-05-05', 'k.wellensteyn@yahoo.de'),
(2002, 'Foede','Dorothea','2000-03-24','d.foede@web.de'),
(2003, 'Leberer','Sigrid','1989-09-21','sigrid@leberer.de'),
(2004, 'Soerensen','Hanna','1974-04-03','h.soerensen@yahoo.de'),
(2005, 'Schnitter','Marten','1964-04-17','schni_mart@gmail.com'),
(2006, 'Maurer','Belinda','1978-09-09','belinda1978@yahoo.de'),
(2007, 'Gessert','Armin','1978-01-29','armin@gessert.de'),
(2008, 'Haessig','Jean-Marc','1982-08-30','jm@haessig.de'),
(2009, 'Urocki','Eric','1999-12-04','urocki@outlook.de');

-- Adressen --
INSERT INTO ADRESSE (ADRESSID, KUNDENNR, STRASSE, HAUSNR, PLZ, ORT, TELEFON) VALUES
(2001, 2001,'Eppendorfer Landstrasse', '104', '20249','1','040/443322'),
(2002, 2002, 'Ohmstraße', '23', '22765','1','040/543822'),
(2003, 2003, 'Bilser Berg', '6', '20459','1','0175/1234588'),
(2004, 2004,'Alter Teichweg', '95', '22049','1','040/634578'),
(2005, 2005,'Stübels', '10', '22835','2','0176/447587'),
(2006, 2006,'Grotelertwiete', '4a', '21075','1','040/332189'),
(2007, 2007,'Küstersweg', '3', '21079','1','040/67890'),
(2008, 2008,'Neugrabener Bahnhofstraße', '30', '21149','1','0178-67013390'),
(2009, 2009,'Elbchaussee', '228', '22605','1','0152-96701390');

-- Lieferanten --
INSERT INTO LIEFERANT (LIEFERANTENNR, LIEFERANTENNAME, STRASSE, HAUSNR, PLZ, ORT, TELEFON, EMAIL) values
(101, 'Bio-Hof Müller', 'Dorfstraße', '74', '24354', '3', '04354-9080', 'mueller@biohof.de'),
(102, 'Obst-Hof Altes Land', 'Westerjork 74', '76', '21635', '4', '04162-4523', 'info@biohof-altesland.de'),
(103, 'Molkerei Henning', 'Molkereiwegkundekunde', '13','19217', '5', '038873-8976', 'info@molkerei-henning.de');

-- Zutaten --
INSERT INTO ZUTAT (ZUTATENNR, BEZEICHNUNG, EINHEIT, NETTOPREIS, BESTAND, lieferant) VALUES
(1001, 'Zucchini','Stück', 0.89, 100, 101),
(1002, 'Zwiebel', 'Stück', 0.89, 50, 101),
(1003, 'Tomate', 'Stück', 0.45, 50, 101),
(1004, 'Schalotte', 'Stück', 0.20, 500, 101),
(1005, 'Karotte', 'Stück', 0.30, 500, 101),
(1006, 'Kartoffel', 'Stück', 0.15, 1500, 101),
(1007, 'Rucola', 'Bund', 0.90, 10, 101),
(1008, 'Lauch', 'Stück', 1.2, 35, 101),
(1009, 'Knoblauch', 'Stück', 0.25, 250, 101),
(1010, 'Basilikum', 'Bund', 1.3, 10, 101),
(1011, 'Süßkartoffel', 'Stück', 2.0, 200, 101),
(1012, 'Schnittlauch', 'Bund', 0.9, 10, 101),
(2001, 'Apfel', 'Stück', 1.2, 750, 102),
(3001, 'Vollmilch. 3.5%', 'Liter', 1.5, 50, 103),
(3002, 'Mozzarella', 'Packung', 3.5, 20, 103),
(3003, 'Butter', 'Stück', 3.0, 50, 103),
(4001, 'Ei', 'Stück', 0.4, 300, 102),
(5001, 'Wiener Würstchen', 'Paar', 1.8, 40, 101),
(9001, 'Tofu-Würstchen', 'Stück', 1.8, 20, 103),
(6408, 'Couscous', 'Packung', 1.9, 15, 102),
(7043, 'Gemüsebrühe', 'Würfel', 0.2, 4000, 101),
(6300, 'Kichererbsen', 'Dose', 1.0, 400, 103);

-- Nährwerte --
INSERT INTO Naerwerte (ZUTATENNR, KALORIEN, KOHLENHYDRATE, PROTEIN, FETT) VALUES
(1001, 19, 2, 1.6, 0),
(1002, 19, 2, 1.6, 0),
(1003, 18, 2.6, 1, 0),
(1004, 25, 3.3, 1.5, 0),
(1005, 41, 10, 0.9, 0),
(1006, 71, 14.6, 2, 0),
(1007, 27, 2.1, 2.6, 0),
(1008, 29, 3.3, 2.1, 0),
(1009, 141, 28.4, 6.1, 0),
(1010, 41, 5.1, 3.1, 0),
(1011, 86, 20, 1.6, 0),
(1012, 28, 1, 3, 0),
(2001, 54, 14.4, 0.3, 0),
(3001, 65, 4.7, 3.4, 0),
(3002, 241, 1, 18.1, 0),
(3003, 741, 0.6, 0.7, 0),
(4001, 137, 1.5, 11.9, 0),
(5001, 331, 1.2, 9.9, 0),
(9001, 252, 7, 17, 0),
(6408, 351, 67, 12, 0),
(7043, 1, 0.5, 0.5, 0),
(6300, 150, 21.2, 9,0);

-- Bestellungen --
INSERT INTO BESTELLUNG (KUNDENNR, BESTELLDATUM, RECHNUNGSBETRAG) VALUES
(2001,'2020-07-01', 6.21),
(2002,'2020-07-08', 32.96),
(2003,'2020-08-01', 24.08),
(2004,'2020-08-02', 19.90),
(2005,'2020-08-02', 6.47),
(2006,'2020-08-10', 6.96),
(2007,'2020-08-10', 2.41),
(2008,'2020-08-10', 13.80),
(2009,'2020-08-10', 8.67),
(2007,'2020-08-15', 17.98),
(2005,'2020-08-12', 8.67),
(2003,'2020-08-13', 20.87);

-- Bestellungen (Zuten) --
INSERT INTO BESTELLUNGZUTAT(BESTELLNR, ZUTATENNR, MENGE) VALUES
(1, 1001, 5),
(1, 1002, 3),
(1, 1006, 2),
(1, 1004, 3),
(2, 9001, 10),
(2, 1005, 5),
(2, 1003, 4),
(2, 6408, 5),
(3, 6300, 15),
(3, 3001, 5),
(4, 5001, 7),
(4, 3003, 2),
(5, 1002, 4),
(5, 1004, 5),
(5, 1001, 5),
(7, 1009, 9),
(6, 1010, 5),
(8, 1012, 5),
(8, 1008, 7),
(9, 1007, 4),
(9, 1012, 5),
(10, 1011, 7),
(10, 4001, 7),
(11, 5001, 2),
(11, 1012, 5),
(12, 1010, 15);

-- Rezepte --
INSERT INTO REZEPTE (REZEPTID, NAME, ZUBEREITUNG) VALUES

-- Rezept 1
(1, 'Gemüse-Couscous mit Tofu-Würstchen',
'Zubereitung:
1. Zucchini, Zwiebel, Tomate, Schalotte, Karotte, Kartoffel, Rucola, Lauch, Knoblauch, Basilikum, Süßkartoffel, Schnittlauch und Apfel waschen, schälen und klein schneiden.
2. In einem großen Topf die Butter schmelzen und die Zwiebel darin glasig braten.
3. Füge den Knoblauch hinzu und brate ihn kurz an, bis er duftet.
4. Füge die Tomaten, Schalotten, Karotten, Kartoffeln und Süßkartoffeln hinzu. Brate alles für etwa 5 Minuten an, bis das Gemüse leicht gebräunt ist.
5. Gib die Gemüsebrühe hinzu und lasse die Mischung aufkochen. Reduziere die Hitze und lasse das Gemüse köcheln, bis es weich ist.
6. Während das Gemüse köchelt, bereite den Couscous gemäß den Anweisungen auf der Verpackung zu.
7. Wenn das Gemüse weich ist, füge die Kichererbsen, Zucchini, Rucola und Basilikum hinzu. Rühre gut um und lass es weiter köcheln, bis das Gemüse durch ist.
8. Füge den Mozzarella hinzu und lass ihn schmelzen.
9. In einer separaten Pfanne brate die Wiener Würstchen und die Tofu-Würstchen an, bis sie goldbraun sind.
10. Serviere das Gemüse-Couscous auf einem Teller und lege die angebratenen Würstchen oben drauf.
11. Garniere das Gericht mit Schnittlauch und genieße dein Gemüse-Couscous mit Tofu-Würstchen!'),

-- Rezept 2
(2, 'Tomaten-Mozzarella-Salat',
'Zubereitung:
1. Tomaten waschen und in Scheiben schneiden.
2. Mozzarella in gleich große Scheiben schneiden.
3. Tomatenscheiben abwechselnd mit Mozzarellascheiben auf einem Teller anrichten.
4. Basilikumblätter darüber streuen.
5. Mit Salz und Pfeffer würzen.
6. Nach Belieben mit Balsamico-Essig und Olivenöl beträufeln.
7. Sofort servieren und genießen.'),

-- Rezept 3
(3, 'Kartoffel-Lauch-Suppe',
'Zubereitung:
1. Kartoffeln schälen und in Würfel schneiden.
2. Lauch putzen und in Ringe schneiden.
3. Zwiebel und Knoblauch schälen und fein hacken.
4. In einem Topf Butter erhitzen und Zwiebeln sowie Knoblauch darin glasig anschwitzen.
5. Kartoffeln und Lauch hinzufügen, kurz mit anschwitzen.
6. Gemüsebrühe angießen und zum Kochen bringen.
7. Die Suppe köcheln lassen, bis die Kartoffeln weich sind.
8. Mit einem Pürierstab die Suppe pürieren, bis eine cremige KonNärwertesistenz erreicht ist.
9. Nach Bedarf mit Salz und Pfeffer abschmecken.
10. Heiß servieren und genießen.'),

-- Rezept 4
(4, 'Süßkartoffel-Curry',
'Zubereitung:
1. Süßkartoffeln schälen und in Würfel schneiden.
2. Zwiebel und Knoblauch schälen und fein hacken.
3. In einem Topf Zwiebeln und Knoblauch in Öl glasig anschwitzen.
4. Süßkartoffeln hinzufügen und kurz mit anschwitzen.
5. Tomaten in Stücke schneiden und zum Gemüse geben.
6. Kokosmilch hinzufügen und alles zum Kochen bringen.
7. Das Curry köcheln lassen, bis die Süßkartoffeln weich sind.
8. Nach Bedarf mit Salz und Currygewürz abschmecken.
9. Mit frischem Basilikum garnieren.
10. Heiß servieren und genießen.'),

-- Rezept 5
(5, 'Gemüse-Omelett',
'Zubereitung:
1. Zwiebeln, Tomaten, Rucola und Mozzarella vorbereiten und klein schneiden.
2. In einer Pfanne etwas Öl erhitzen.
3. Zwiebeln in der Pfanne anbraten, bis sie glasig sind.
4. Tomaten, Rucola und Mozzarella hinzufügen und kurz mitbraten.
5. Eier in einer Schüssel verquirlen und über die Gemüsemischung gießen.
6. Eimasse stocken lassen und nach Belieben umrühren.
7. Omelett auf einen Teller gleiten lassen und servieren.'),

-- Rezept 6
(7, 'Penne Arrabiata',
'Zubereitung:
1. Penne nach Packungsanweisung in Salzwasser kochen, bis sie al dente sind.
2. Zwiebel und Knoblauch schälen und fein hacken.
3. In einer Pfanne etwas Olivenöl erhitzen und Zwiebeln sowie Knoblauch darin glasig anschwitzen.
4. Tomaten in Würfel schneiden und zu den Zwiebeln und Knoblauch geben.
5. Basilikum hinzufügen und die Sauce köcheln lassen, bis die Tomaten weich sind.
6. Wiener Würstchen in Scheiben schneiden und zur Sauce geben.
7. Mit Salz und Pfeffer würzen.
8. Gekochte Penne zur Sauce geben und gut vermengen.
9. Heiß servieren und genießen.'),

-- Rezept 7
(8, 'Quinoa-Salat mit Avocado',
'Zubereitung:
1. Quinoa nach Packungsanweisung kochen und abkühlen lassen.
2. Ei hart kochen, schälen und in Würfel schneiden.
3. Kichererbsen abtropfen lassen.
4. Zucchini und Karotte waschen und in kleine Würfel schneiden.
5. Apfel waschen, schälen, entkernen und in kleine Stücke schneiden.
6. Alle vorbereiteten Zutaten in einer Schüssel vermengen.
7. Schnittlauch fein schneiden und über den Salat streuen.
8. Avocado halbieren, entkernen, in Würfel schneiden und unter den Salat heben.
9. Nach Belieben mit einem Dressing oder Olivenöl und Zitronensaft abschmecken.
10. Sofort servieren und genießen.');

-- Zutaen für die Rezepte
INSERT INTO REZEPTEZUTAT (REZEPTID, ZUTATENNR, MENGE) VALUES

-- Rezept 1 || -- (1, 1004, 1), -- Schalotte
(1, 1001, 1), -- Zucchini
(1, 1002, 1), -- Zwiebel
(1, 1003, 2), -- Tomate
(1, 1005, 1), -- Karotte
(1, 1006, 1), -- Kartoffel
(1, 1007, 1), -- Rucola
(1, 1008, 1), -- Lauch
(1, 1009, 3), -- Knoblauch
(1, 1010, 1), -- Basilikum
(1, 1011, 1), -- Süßkartoffel
(1, 1012, 1), -- Schnittlauch
(1, 2001, 1), -- Apfel
(1, 3001, 200), -- Vollmilch
(1, 3002, 150), -- Mozzarella
(1, 3003, 2),  -- Butter
(1, 4001, 3),  -- Ei
(1, 5001, 5),  -- Wiener Würstchen
(1, 6300, 1),  -- Kichererbsen
(1, 6408, 1),  -- Couscous
(1, 7043, 500),-- Gemüsebrühe
(1, 9001, 5),  -- Tofu-Würstchen

-- Rezept 2
(2, 1003, 3),  -- Tomaten
(2, 3002, 150), -- Mozzarella
(2, 1010, 1),  -- Basilikum

-- Rezept 3
(3, 1006, 3),  -- Kartoffeln
(3, 1008, 1),  -- Lauch
(3, 1002, 1),  -- Zwiebel
(3, 1009, 2),  -- Knoblauch
(3, 7043, 750),-- Gemüsebrühe
(3, 3003, 2),  -- Butter

-- Rezept 4
(4, 1011, 2),  -- Süßkartoffeln
(4, 1002, 1),  -- Zwiebel
(4, 1009, 2),  -- Knoblauch
(4, 1003, 400),-- Tomaten
(4, 3001, 400),-- Kokosmilch
(4, 1010, 1),  -- Basilikum

-- Rezept 5
(5, 4001, 4),  -- Ei
(5, 1002, 1),  -- Zwiebel
(5, 1007, 1),  -- Rucola
(5, 1003, 2),  -- Tomaten
(5, 3002, 100),-- Mozzarella

-- Rezept 6
(7, 6408, 300), -- Penne
(7, 1003, 4),   -- Tomaten
(7, 1009, 2),   -- Knoblauch
(7, 1002, 1),   -- Zwiebel
(7, 1010, 1),   -- Basilikum
(7, 5001, 2),   -- Wiener Würstchen

-- Rezept 7
(8, 4001, 3),  -- Ei
(8, 6300, 1),  -- Kichererbsen
(8, 1001, 1),  -- Zucchini
(8, 1005, 1),  -- Karotte
(8, 1012, 1),  -- Schnittlauch
(8, 2001, 1);  -- Apfel

-- Allergene
INSERT INTO Allergene (AllergenID, Name) VALUES
(0, 'Keine'),
(1, 'Gluten'),
(2, 'Laktose'),
(3, 'Ei'),
(4, 'Soja'),
(5, 'Nuss'),
(6, 'Fisch'),
(7, 'Erdnüsse'),
(8, 'Schalenfrüchte');

-- Zutaten-Allergene Zuordnung
INSERT INTO Allergene_ZUTAT (ZUTATENNR, AllergenID) VALUES
(1001, 0), -- Zucchini
(1002, 0), -- Zwiebel
(1003, 0), -- Tomate
(1004, 0), -- Schalotte
(1005, 0), -- Karotte
(1006, 0), -- Kartoffel
(1007, 0), -- Rucola
(1008, 0), -- Lauch
(1009, 0), -- Knoblauch
(1010, 0), -- Basilikum
(1011, 0), -- Süßkartoffel
(1012, 0), -- Schnittlauch
(2001, 0), -- Apfel
(3001, 2), -- Vollmilch 3.5%
(3002, 2), -- Mozzarella
(3003, 2), -- Butter
(4001, 3), -- Ei
(5001, 5), -- Wiener Würstchen
(6300, 0), -- Kichererbsen
(6408, 0), -- Couscous
(7043, 0); -- Gemüsebrühe

-- Ernaehrungskategorie
INSERT INTO Ernaehrungskategorie (ErnaehrungskategorieID, Name) VALUES
(0, 'Keine spezifische Ernährungskategorie'),
(1, 'Laktosefrei'),
(2, 'Glutenfrei'),
(3, 'Vegan'),
(4, 'Vegetarisch'),
(5, 'Low Carb'),
(6, 'High Protein');

-- Ernaehrungskategorien Zuordnung
INSERT INTO Kat_ZUTAT (ZUTATENNR, ErnaehrungskategorieID) VALUES
(1001, 3), -- Zucchini,     Vegan
(1002, 3), -- Zwiebel,      Vegan
(1003, 3), -- Tomate,       Vegan
(1004, 3), -- Schalotte,    Vegan
(1005, 3), -- Karotte,      Vegan
(1006, 3), -- Kartoffel,    Vegan
(1007, 3), -- Rucola,       Vegan
(1008, 3), -- Lauch,        Vegan
(1009, 3), -- Knoblauch,    Vegan
(1010, 3), -- Basilikum,    Vegan
(1011, 3), -- Süßkartoffel, Vegan
(1012, 3), -- Schnittlauch, Vegan
(2001, 3), -- Apfel, Vegan, Vegetarisch
(3001, 4), -- Vollmilch 3.5%, Vegetarisch
(3002, 4), -- Mozzarella,   Vegetarisch,High Protein
(3003, 4), -- Butter,       Vegetarisch
(4001, 4), -- Ei,           Vegetarisch
(5001, 0), -- Wiener Würstchen
(6300, 3), -- Kichererbsen, 	Vegan
(6408, 0), -- Couscous		Vegan
(7043, 0); -- Gemüsebrühe	Vegan

INSERT INTO 
Ernaehrungskategorie_REZEPT (REZEPTID, ErnaehrungskategorieID) VALUES
(1,3), (1,5),
(2,1), (2,2), (2,3), (2,4), (2,5), (2,6),
(3,2), (3,4), (3,5),
(4,1), (4,2), (4,3), (4,4), (4,5),
(5,2), (5,4), (5,5), (5,6),
(7,0), (7,1),
(8,1), (8,2), (8,3), (8,4), (8,5);


DELIMITER //

CREATE PROCEDURE loesche_personenbezogene_daten(IN vorname VARCHAR(50), IN nachname VARCHAR(50))
BEGIN
  -- Anonymisiert die personenbezogenen Daten in der KUNDE Tabelle
  UPDATE KUNDE
  SET NACHNAME = NULL, VORNAME = NULL, GEBURTSDATUM = NULL, EMAIL = NULL
  WHERE VORNAME = vorname AND NACHNAME = nachname;
   
  -- Löscht alle Einträge in der ADRESSE Tabelle, die dem Kunden zugeordnet sind
  DELETE FROM ADRESSE
  WHERE KUNDENNR IN (
    SELECT KUNDENNR FROM KUNDE WHERE VORNAME = vorname AND NACHNAME = nachname
  );
END //

CREATE PROCEDURE FuelleErnaehrungskategorie_REZEPT(IN gegebeneRezeptID INTEGER)
BEGIN
  DECLARE fertig INT DEFAULT FALSE;
  DECLARE aktuelleKategorieID INTEGER;
  DECLARE gesamtKohlenhydrate DECIMAL(10,2);
  DECLARE gesamtProtein DECIMAL(10,2);
  DECLARE rezeptPortionen INTEGER DEFAULT 1;
  DECLARE istVegan INT;
  DECLARE istLaktosefrei INT;
  DECLARE kategorieZuordnungen INT DEFAULT 0; -- Zählt, wie oft eine Zuordnung erfolgt
  DECLARE kategorieCursor CURSOR FOR SELECT ErnaehrungskategorieID FROM Ernaehrungskategorie;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fertig = TRUE;

  -- Berechne Gesamtkohlenhydrate und Gesamtprotein für das Rezept
  SELECT SUM(Naerwerte.KOHLENHYDRATE), SUM(Naerwerte.PROTEIN) INTO gesamtKohlenhydrate, gesamtProtein
  FROM REZEPTEZUTAT
  JOIN Naerwerte ON REZEPTEZUTAT.ZUTATENNR = Naerwerte.ZUTATENNR
  WHERE REZEPTEZUTAT.REZEPTID = gegebeneRezeptID;

  -- Low Carb und High Protein Kategorien
  IF gesamtKohlenhydrate / rezeptPortionen < 20 THEN
    INSERT IGNORE INTO Ernaehrungskategorie_REZEPT (REZEPTID, ErnaehrungskategorieID)
    VALUES (gegebeneRezeptID, 5); -- 5 steht für Low Carb
    SET kategorieZuordnungen = kategorieZuordnungen + 1;
  END IF;

  IF gesamtProtein / rezeptPortionen > 20 THEN
    INSERT IGNORE INTO Ernaehrungskategorie_REZEPT (REZEPTID, ErnaehrungskategorieID)
    VALUES (gegebeneRezeptID, 6); -- 6 steht für High Protein
    SET kategorieZuordnungen = kategorieZuordnungen + 1;
  END IF;

  -- Durchlaufen aller Ernährungskategorien
  OPEN kategorieCursor;
  kategorieLoop: LOOP
    FETCH kategorieCursor INTO aktuelleKategorieID;
    IF fertig THEN
      LEAVE kategorieLoop;
    END IF;

  -- Logik für Vegan
  IF aktuelleKategorieID = 3 THEN
    SELECT NOT EXISTS (
      SELECT *
      FROM REZEPTEZUTAT
      JOIN Kat_ZUTAT ON REZEPTEZUTAT.ZUTATENNR = Kat_ZUTAT.ZUTATENNR
      WHERE REZEPTEZUTAT.REZEPTID = gegebeneRezeptID
      AND Kat_ZUTAT.ErnaehrungskategorieID != 3 -- Angenommen, Kategorie 3 ist für vegane Zutaten
    ) INTO istVegan FROM DUAL;

    IF istVegan = 1 THEN
      INSERT IGNORE INTO Ernaehrungskategorie_REZEPT (REZEPTID, ErnaehrungskategorieID)
      VALUES (gegebeneRezeptID, 3); -- Füge das Rezept zur Vegan-Kategorie hinzu
      SET kategorieZuordnungen = kategorieZuordnungen + 1;
    END IF;
  END IF;

  -- Logik für Laktosefrei
  IF aktuelleKategorieID = 1 THEN
    SELECT NOT EXISTS (
      SELECT *
      FROM REZEPTEZUTAT
      JOIN ZUTAT ON REZEPTEZUTAT.ZUTATENNR = ZUTAT.ZUTATENNR
      WHERE REZEPTEZUTAT.REZEPTID = gegebeneRezeptID
      AND ZUTAT.BEZEICHNUNG IN ('Vollmilch. 3.5%', 'Mozzarella', 'Butter') -- Beispiel für laktosehaltige Zutaten
    ) INTO istLaktosefrei FROM DUAL;

    IF istLaktosefrei = 1 THEN
      INSERT IGNORE INTO Ernaehrungskategorie_REZEPT (REZEPTID, ErnaehrungskategorieID)
      VALUES (gegebeneRezeptID, 1); -- Füge das Rezept zur Laktosefrei-Kategorie hinzu
      SET kategorieZuordnungen = kategorieZuordnungen + 1;
    END IF;
  END IF;


  END LOOP;
  CLOSE kategorieCursor;

  -- Wenn keine Kategorie zugeordnet wurde, weise Kategorie 0 zu
  IF kategorieZuordnungen = 0 THEN
    INSERT IGNORE INTO Ernaehrungskategorie_REZEPT (REZEPTID, ErnaehrungskategorieID)
    VALUES (gegebeneRezeptID, 0); -- 0 steht für "Keine spezifische Ernährungskategorie"
  END IF;
END//

CREATE TRIGGER NachRezeptInsert
AFTER INSERT ON REZEPTE
FOR EACH ROW
BEGIN
  -- Aufrufen der Prozedur mit der ID des neu eingefügten Rezepts
  CALL FuelleErnaehrungskategorie_REZEPT(NEW.REZEPTID);
END//

DELIMITER ;

COMMIT WORK;

-- Call
CALL loesche_personenbezogene_daten('Kira','Wellensteyn')

-- Auswahl aller Zutaten eines Rezeptes nach Rezeptname
SELECT
	r.NAME,
	z.BEZEICHNUNG
FROM REZEPTE r
JOIN REZEPTEZUTAT rz ON r.REZEPTID = rz.REZEPTID
JOIN ZUTAT z ON rz.ZUTATENNR = z.ZUTATENNR
WHERE r.Name = 'Gemüse-Omelett';

-- Auswahl aller Rezepte einer bestimmten Ernährungskategorie
SELECT r.NAME, e.Name
FROM REZEPTE r
JOIN Ernaehrungskategorie_REZEPT er ON er.REZEPTID = r.REZEPTID
JOIN Ernaehrungskategorie e ON e.ErnaehrungskategorieID = er.ErnaehrungskategorieID
WHERE e.Name = 'Vegan';

-- Auswahl aller Rezepte, die eine gewisse Zutat enthalten
SELECT
	r.NAME,
	z.BEZEICHNUNG
FROM REZEPTE r
JOIN REZEPTEZUTAT rz ON r.REZEPTID = rz.REZEPTID
JOIN ZUTAT z ON rz.ZUTATENNR = z.ZUTATENNR
WHERE z.BEZEICHNUNG  = 'Ei';

--Berechnung der durchschnittlichen Nährwerte aller Bestellungen eines Kunden
SELECT
	k.NACHNAME,
	round(avg(n.KALORIEN), 0) KALORIEN,
	round(avg(n.KOHLENHYDRATE), 2) KOHLENHYDRATE,
	round(avg(n.PROTEIN), 2) PROTEIN
FROM KUNDE k
JOIN BESTELLUNG b ON k.KUNDENNR = b.KUNDENNR
JOIN BESTELLUNGZUTAT bz ON bz.BESTELLNR = b.BESTELLNR
JOIN Naerwerte n ON n.ZUTATENNR = bz.ZUTATENNR
GROUP BY k.KUNDENNR;

--Auswahl aller Zutaten, die bisher keinem Rezept zugeordnet sind
SELECT Z.BEZEICHNUNG
FROM ZUTAT Z
LEFT JOIN REZEPTEZUTAT RZ ON Z.ZUTATENNR = RZ.ZUTATENNR
WHERE RZ.ZUTATENNR IS NULL;

--Auswahl aller Rezepte, die eine bestimmte Kalorienmenge nicht überschreiten
SELECT r.NAME, sum((n.KALORIEN * rz.MENGE)) KALORIEN
FROM ZUTAT z
JOIN Naerwerte n ON z.ZUTATENNR = n.ZUTATENNR
JOIN REZEPTEZUTAT rz ON rz.ZUTATENNR = n.ZUTATENNR
JOIN REZEPTE r ON r.REZEPTID = rz.REZEPTID
GROUP BY r.NAME
HAVING KALORIEN < 50000;

--Auswahl aller Rezepte, die weniger als fünf Zutaten enthalten
SELECT
	r.NAME,
	COUNT(rz.ZUTATENNR)
FROM
	REZEPTE r
JOIN REZEPTEZUTAT rz ON rz.REZEPTID = r.REZEPTID
GROUP BY r.NAME
HAVING COUNT(rz.ZUTATENNR) < 5;


-- Auswahl aller Rezepte, die weniger als fünf Zutaten enthalten und eine bestimmte Ernährungskategorie erfüllen
select
	r.NAME, e.Name,
	count(z.BEZEICHNUNG) anzahl
FROM REZEPTE r
JOIN REZEPTEZUTAT rz ON r.REZEPTID = rz.REZEPTID
JOIN ZUTAT z ON rz.ZUTATENNR = z.ZUTATENNR
join ernaehrungskategorie_rezept er on r.REZEPTID = er.REZEPTID 
join ernaehrungskategorie e on er.ErnaehrungskategorieID = e.ErnaehrungskategorieID 
group by r.NAME
having  e.Name = 'Glutenfrei' 
and anzahl>5
;

--Erstellen Sie mindestens drei weitere Abfragen (1) (Zeit die Zutaten an, und löst den Lieferantennamen direkt mit einem Subselects auf)
SELECT
    z.BEZEICHNUNG,
    (SELECT LIEFERANTENNAME FROM LIEFERANT WHERE LIEFERANTENNR = z.LIEFERANT) LIEFERANTENNAME,
    z.EINHEIT,
    z.NETTOPREIS,
    z.BESTAND
FROM ZUTAT z;

--Erstellen Sie mindestens drei weitere Abfragen (2) (Zeigt den Lagerwert je Lieferant an)
SELECT z.BEZEICHNUNG, z.LIEFERANT, (z.NETTOPREIS * z.BESTAND) Lagerwert
FROM ZUTAT z
INNER JOIN LIEFERANT l ON l.LIEFERANTENNR = z.LIEFERANT
GROUP BY LIEFERANT

--Erstellen Sie mindestens drei weitere Abfragen (3)
select *
from kunde k
join adresse a on k.KUNDENNR = a.KUNDENNR
where k.NACHNAME = 'Urocki'and  k.VORNAME = 'Eric';

--Stellen Sie sicher, dass Sie insgesamt mindestens je eine Abfrage mit inner join,
select *
from kunde k
INNER join adresse a on k.KUNDENNR = a.KUNDENNR
INNER JOIN orte o on a.ort = o.ortid
where k.NACHNAME = 'Urocki'and  k.VORNAME = 'Eric';

--Stellen Sie sicher, dass Sie insgesamt mindestens je eine Abfrage mit left join
SELECT z.BEZEICHNUNG
FROM ZUTAT z
LEFT JOIN REZEPTEZUTAT rz ON z.ZUTATENNR = rz.ZUTATENNR
WHERE rz.ZUTATENNR IS NULL;

--Stellen Sie sicher, dass Sie insgesamt mindestens je eine Abfrage mit right join
SELECT z.BEZEICHNUNG
FROM REZEPTEZUTAT rz
RIGHT JOIN ZUTAT z ON z.ZUTATENNR = rz.ZUTATENNR
WHERE rz.ZUTATENNR IS NULL;

--Stellen Sie sicher, dass Sie insgesamt mindestens je eine Abfrage mit Subselects
SELECT
    z.BEZEICHNUNG,
    (SELECT LIEFERANTENNAME FROM LIEFERANT WHERE LIEFERANTENNR = z.LIEFERANT) LIEFERANTENNAME,
    z.EINHEIT,
    z.NETTOPREIS,
    z.BESTAND
FROM ZUTAT z;

--Stellen Sie sicher, dass Sie insgesamt mindestens je eine Abfrage mit Aggregatfunktionen
SELECT
	k.NACHNAME,
	round(avg(n.KALORIEN), 0) KALORIEN,
	round(avg(n.KOHLENHYDRATE), 2) KOHLENHYDRATE,
	round(avg(n.PROTEIN), 2) PROTEIN
FROM KUNDE k
JOIN BESTELLUNG b ON k.KUNDENNR = b.KUNDENNR
JOIN BESTELLUNGZUTAT bz ON bz.BESTELLNR = b.BESTELLNR
JOIN Naerwerte n ON n.ZUTATENNR = bz.ZUTATENNR
GROUP BY k.KUNDENNR;

--Setzen Sie mindestens drei Stored Procedures in Ihrer Datenbank um (1) -- Löschen eines Kundens inkl aller Addresen
-- Kunden Informationen Löschen
CREATE OR REPLACE PROCEDURE del_Kunde(
  IN NACHNAME VARCHAR(50),
  IN VORNAME VARCHAR(50),
)
BEGIN
  SELECT k.KUNDENNR
  FROM KUNDEN k
  where NACHNAME = NACHNAME 
  and VORNAME = VORNAME);

  delete
  from adresse, kunden
  where KUNDENNR = k.KUNDENNR
END

--Setzen Sie mindestens drei Stored Procedures in Ihrer Datenbank um (2) -- Erstellung der HIGH CAP Kategorien in einem REZEPT mit hilfe der Proteinmenge in Zutaten


--Setzen Sie mindestens drei Stored Procedures in Ihrer Datenbank um (3) --


--Löschen von personenbezogener Daten nach DSGVO
delete
from adresse
where KUNDENNR <> (select KUNDENNR
from  kunde k where NACHNAME = 'Urocki' and VORNAME = 'Eric');

-- Personenbezogene Daten zur DSGVO
select *
from kunde k
join adresse a on k.KUNDENNR = a.KUNDENNR
where k.NACHNAME = 'Urocki'and  k.VORNAME = 'Eric';


-- Speicherung von Rezepten bestehend aus mehreren Zutaten
-- Done



-- Speicherung von Ernährungskategorien
-- Done



-- Speicherung von Beschränkungen/ Allergenen
-- Done



-- Auswahl bzw. Ausschluss von Rezepten auf Basis von Beschränkungen
SELECT DISTINCT r.NAME, a.Name
FROM REZEPTE r
JOIN REZEPTEZUTAT rz ON rz.REZEPTID = r.REZEPTID
JOIN ZUTAT z ON z.ZUTATENNR = rz.ZUTATENNR
JOIN Allergene_ZUTAT az ON z.ZUTATENNR = az.ZUTATENNR
JOIN Allergene a ON a.AllergenID = az.AllergenID
WHERE a.Name <> 'Ei'


