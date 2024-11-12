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

-- Berechnung der durchschnittlichen Nährwerte aller Bestellungen eines Kunden
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

-- Auswahl aller Zutaten, die bisher keinem Rezept zugeordnet sind
SELECT Z.BEZEICHNUNG
FROM ZUTAT Z
LEFT JOIN REZEPTEZUTAT RZ ON Z.ZUTATENNR = RZ.ZUTATENNR
WHERE RZ.ZUTATENNR IS NULL;

-- Auswahl aller Rezepte, die eine bestimmte Kalorienmenge nicht überschreiten
SELECT r.NAME, sum((n.KALORIEN * rz.MENGE)) KALORIEN
FROM ZUTAT z
JOIN Naerwerte n ON z.ZUTATENNR = n.ZUTATENNR
JOIN REZEPTEZUTAT rz ON rz.ZUTATENNR = n.ZUTATENNR
JOIN REZEPTE r ON r.REZEPTID = rz.REZEPTID
GROUP BY r.NAME
HAVING KALORIEN < 50000;

-- Auswahl aller Rezepte, die weniger als fünf Zutaten enthalten
SELECT
	r.NAME,
	COUNT(rz.ZUTATENNR)
FROM
	REZEPTE r
JOIN REZEPTEZUTAT rz ON rz.REZEPTID = r.REZEPTID
GROUP BY r.NAME
HAVING COUNT(rz.ZUTATENNR) < 5;

-- Auswahl aller Rezepte, die weniger als fünf Zutaten enthalten und eine bestimmte Ernährungskategorie erfüllen
SELECT
	r.NAME,
	COUNT(rz.ZUTATENNR),
	e.Name
FROM
	REZEPTE r
JOIN REZEPTEZUTAT rz ON rz.REZEPTID = r.REZEPTID
JOIN Ernaehrungskategorie_REZEPT er ON er.REZEPTID = rz.REZEPTID
JOIN Ernaehrungskategorie e ON er.ErnaehrungskategorieID = e.ErnaehrungskategorieID
GROUP BY r.NAME
HAVING COUNT(rz.ZUTATENNR) < 5 AND e.Name = 'Vegan';

-- Es sind drei weitere Statements vorhanden. Es wurde mindestens je eine Abfrage mit 
-- inner join, 
select *
from kunde k
INNER join adresse a on k.KUNDENNR = a.KUNDENNR
INNER JOIN orte o on a.ort = o.ortid
where k.NACHNAME = 'Urocki'and  k.VORNAME = 'Eric';

-- left join
SELECT z.BEZEICHNUNG
FROM ZUTAT z
LEFT JOIN REZEPTEZUTAT rz ON z.ZUTATENNR = rz.ZUTATENNR
WHERE rz.ZUTATENNR IS NULL;

--right join 
SELECT z.BEZEICHNUNG
FROM REZEPTEZUTAT rz
RIGHT JOIN ZUTAT z ON z.ZUTATENNR = rz.ZUTATENNR
WHERE rz.ZUTATENNR IS NULL;

--sowie Subselects und 
SELECT
    z.BEZEICHNUNG,
    (SELECT LIEFERANTENNAME FROM LIEFERANT WHERE LIEFERANTENNR = z.LIEFERANT) LIEFERANTENNAME,
    z.EINHEIT,
    z.NETTOPREIS,
    z.BESTAND
FROM ZUTAT z;

--Aggregatfunktionen erstellt.
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



