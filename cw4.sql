--  Utwórz tabelę obiekty. W tabeli umieść nazwy i geometrie obiektów przedstawionych poniżej. Układ odniesienia ustal jako niezdefiniowany.
CREATE TABLE obiekty(nazwa varchar(10), geom geometry);
INSERT INTO obiekty VALUES ('obiekt1',ST_GEOMFROMTEXT('COMPOUNDCURVE(LINESTRING(0 1,1 1),CIRCULARSTRING(1 1,2 0,3 1), CIRCULARSTRING(3 1,4 2,5 1), LINESTRING(5 1,6 1))',0));
INSERT INTO obiekty VALUES ('obiekt2',ST_GEOMFROMTEXT('MULTICURVE(CIRCULARSTRING(11 2,13 2,11 2),COMPOUNDCURVE(LINESTRING(10 6,14 6),CIRCULARSTRING(14 6,16 4,14 2),CIRCULARSTRING(14 2,12 0, 10 2), LINESTRING(10 2,10 6)))',0));
INSERT INTO obiekty VALUES ('obiekt3',ST_GEOMFROMTEXT('POLYGON((7 15,10 17,12 13,7 15))',0));
INSERT INTO obiekty VALUES ('obiekt4',ST_GEOMFROMTEXT('LINESTRING(20 20,25 25,27 24,25 22,26 21,22 19,20.5 19.5)',0));
INSERT INTO obiekty VALUES ('obiekt5',ST_GEOMFROMTEXT('MULTIPOINT((30 30 59,38 32 234)',0));
INSERT INTO obiekty VALUES ('obiekt6',ST_GEOMFROMTEXT('GEOMETRYCOLLECTION(POINT(4 2),LINESTRING(1 1,3 2))',0));

SELECT * FROM obiekty;
--1. Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół najkrótszej linii łączącej obiekt 3 i 4.
SELECT ST_Area(ST_Buffer(ST_ShortestLine((SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'),(SELECT geom FROM obiekty WHERE nazwa = 'obiekt4')),5));
--2. Zamień obiekt4na poligon. Jaki warunek musi być spełniony, abymożna było wykonać to zadanie? Zapewnij te warunki.
UPDATE obiekty SET geom = (SELECT ST_MakePolygon(ST_LineMerge(ST_Union((geom),'LINESTRING(20.5 19.5,20 20)'))) FROM obiekty WHERE nazwa='obiekt4') WHERE nazwa = 'obiekt4';
--3. W tabeli obiekty, jakoobiekt7zapisz obiekt złożony z obiektu 3 i obiektu 4.
INSERT INTO obiekty VALUES ('obiekt7', (SELECT ST_Union(a.geom,b.geom) FROM obiekty a, obiekty b WHERE a.nazwa='obiekt3'AND b.nazwa='obiekt4'));
--4.  Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone wokół obiektów nie zawierających łuków.
SELECT SUM(ST_AREA(ST_BUFFER(obiekty.geom,5))) FROM obiekty WHERE ST_HasArc(obiekty.geom) IS FALSE;