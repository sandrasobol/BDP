--4. Wyznacz liczbę budynków (tabela: popp, atrybut: f_codedesc, reprezentowane, jako punkty) położonych w odległości mniejszej niż 100000 m od głównych rzek. Budynki spełniające to kryterium zapisz do osobnej tabeli tableB.
SELECT COUNT(*) FROM (SELECT popp.* FROM popp, majrivers
WHERE ST_DWithin (majrivers.geom, popp.geom, 100000) = true AND popp.f_codedesc = 'Building' GROUP BY popp.gid) AS l_bud
CREATE TABLE tableB AS SELECT popp.* FROM popp, majrivers 
WHERE ST_DWithin (majrivers.geom, popp.geom, 100000) = true AND popp.f_codedesc = 'Building' GROUP BY popp.gid
--5. Utwórz tabelę o nazwie airportsNew. Z tabeli airports do zaimportuj nazwy lotnisk, ich geometrię, a także atrybut elev, reprezentujący wysokość n.p.m.
CREATE TABLE aiportsNew as SELECT elev,name,geom FROM airports;
--a) Znajdź lotnisko, które położone jest najbardziej na zachód i najbardziej na wschód.
SELECT st_x(geom),name FROM airports ORDER BY st_x(geom) DESC LIMIT 1;
SELECT st_x(geom),name FROM airports ORDER BY st_x(geom) ASC LIMIT 1;
--b) Do tabeli airportsNew dodaj nowy obiekt - lotnisko, które położone jest w punkcie środkowym drogi pomiędzy lotniskami znalezionymi w punkcie a. Lotnisko nazwij airportB. Wysokość n.p.m. przyjmij dowolną.
--Uwaga: geodezyjny układ współrzędnych prostokątnych płaskich (x – oś pionowa, y – oś pozioma)
INSERT INTO airportsNew (name, elev, geom) VALUES ('airportB', 111, (SELECT st_centroid(ST_MakeLine(m.geom,n.geom)) 
FROM airportsnew m, airportsnew n where m.geom = (select geom FROM airports ORDER BY st_x(geom) DESC LIMIT 1)
AND n.geom = (SELECT geom FROM airports ORDER BY st_x(geom) LIMIT 1))) 
--6. Wyznacz pole powierzchni obszaru, który oddalony jest mniej niż 1000 jednostek od najkrótszej linii łączącej jezioro o nazwie ‘Iliamna Lake’ i lotnisko o nazwie „AMBLER”
SELECT ST_Area(ST_Buffer(ST_ShortestLine(l.geom,a.geom),1000)) FROM lakes l, airports a 
WHERE l.names = 'Iliamna Lake' AND a.name = 'AMBLER'
--7. Napisz zapytanie, które zwróci sumaryczne pole powierzchni poligonów reprezentujących poszczególne typy drzew znajdujących się na obszarze tundry i bagien.
SELECT vegdesc, SUM(ST_Area(ST_Intersection(ST_Buffer(t.geom,0),ST_Intersection(ST_Buffer(tr.geom,0),ST_Buffer(s.geom,0))))) 
FROM tundra t, trees tr, swamp s GROUP BY vegdesc;