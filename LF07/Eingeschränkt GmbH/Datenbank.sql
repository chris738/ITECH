-- Starte die Transaktion
START TRANSACTION;
 
-- Erstelle die Tabelle "User"
CREATE TABLE IF NOT EXISTS User (
    ID INT AUTO_INCREMENT, -- Benutzer-ID als Primärschlüssel, automatisch inkrementiert
    Karte CHAR(11) NOT NULL, -- Karte mit 11 Zeichen
    Name VARCHAR(64) NOT NULL, -- Name mit maximal 64 Zeichen
    PRIMARY KEY (ID),
    UNIQUE (Karte) -- Karte muss einzigartig sein
);
 
-- Erstelle die Tabelle "Parkplatz"
CREATE TABLE IF NOT EXISTS Parkplatz (
    Parkplatz CHAR(2) NOT NULL, -- Parkplatz nur mit 2 Ziffern
    UserID INT DEFAULT NULL, -- Verweis auf die ID des Benutzers, kann NULL sein
    Status ENUM('frei', 'besetzt', 'reserviert') NOT NULL DEFAULT 'frei', -- Status des Parkplatzes
    FOREIGN KEY (UserID) REFERENCES User(ID), -- Fremdschlüssel zur Tabelle "User"
    PRIMARY KEY (Parkplatz), -- Parkplatz als Primärschlüssel
    UNIQUE (Parkplatz) -- Stelle sicher, dass der Parkplatz eindeutig ist
);
 
-- Füge Benutzer in die Tabelle "User" ein
INSERT INTO User (Karte, Name) VALUES
('35 12 9C 76', 'Christian'),
('13 19 57 B7', 'Bjarne');
 
-- Füge Parkplätze in die Tabelle "Parkplatz" ein
INSERT INTO Parkplatz (Parkplatz) VALUES
('P1'),
('P2'),
('P3'),
('P4');
 
-- Bestätige die Transaktion
COMMIT;