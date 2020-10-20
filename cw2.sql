--3. Dodaj funkcjonalno�ci PostGIS�a do bazy poleceniem CREATE EXTENSION postgis;
create extension postgis;
--4. Na podstawie poni�szej mapy utw�rz trzy tabele: budynki (id, geometria, nazwa), drogi (id, geometria, nazwa), punkty_informacyjne (id, geometria, nazwa). 
create table budynki(
id int unique primary key not null,
geometria GEOMETRY,
nazwa varchar(10));

create table drogi(
id int unique primary key not null,
geometria GEOMETRY,
nazwa varchar(10));

create table punkty_informacyjne(
id int unique primary key not null,
geometria GEOMETRY,
nazwa varchar(10));
--5. Wsp�rz�dne obiekt�w oraz nazwy (np. BuildingA) nale�y odczyta� z mapki umieszczonej poni�ej. Uk�ad wsp�rz�dnych ustaw jako niezdefiniowany.
insert into budynki(id, geometria, nazwa)
values (1, ST_GeomFromText('POLYGON((8 1.5,10.5 1.5,10.5 4,8 4,8 1.5))',0), 'BuildingA'),
(2, ST_GeomFromText('POLYGON((4 7,4 5,6 5,6 7,4 7))',0),'BuildingB'),
(3, ST_GeomFromText('POLYGON((3 8,3 6,5 6,5 8,3 8))',0),'BuildingC'),
(4, ST_GeomFromText('POLYGON((9 9,9 8,10 8, 10 9,9 9))',0),'BuildingD'),
(5, ST_GeomFromText('POLYGON((1 2,1 1,2 1,2 2,1 2))',0), 'BuildingF');


insert into  drogi (id, geometria, nazwa)
values (1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'RoadX'),
(2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)',0), 'RoadY');

insert into punkty_informacyjne (id, geometria, nazwa)
values (1, ST_GeomFromText('POINT(1 3.5)',0), 'G'),
(2, ST_GeomFromText('POINT(5.5 1.5)',0), 'H'),
(3, ST_GeomFromText('POINT(9.5 6)',0), 'I'),
(4, ST_GeomFromText('POINT(6.5 6)',0), 'J'),
(5, ST_GeomFromText('POINT(6 9.5)',0), 'K');
--6. Na bazie przygotowanych tabel wykonaj poni�sze polecenia:

--a. Wyznacz ca�kowit� d�ugo�� dr�g w analizowanym mie�cie.
SELECT SUM(ST_Length(geometria)) FROM drogi;
--b. Wypisz geometri� (WKT), pole powierzchni oraz obw�d poligonu reprezentuj�cego budynek o nazwie BuildingA.
SELECT ST_AsText(geometria), ST_Area(geometria), ST_Perimeter(geometria) FROM budynki WHERE nazwa LIKE 'BulidingA';
--c. Wypisz nazwy i pola powierzchni wszystkich poligon�w w warstwie budynki. Wyniki posortuj alfabetycznie.
SELECT nazwa, ST_Area(geometria) FROM budynki ORDER BY nazwa ASC;
--d. Wypisz nazwy i obwody 2 budynk�w o najwi�kszej powierzchni.
SELECT nazwa, ST_Area(geometria) as PP FROM budynki ORDER BY PP DESC LIMIT 2;
--e. Wyznacz najkr�tsz� odleg�o�� mi�dzy budynkiem BuildingC a punktem G.
SELECT ST_Distance(budynki.geometria,punkty_informacyjne.geometria) FROM budynki,punkty_informacyjne WHERE budynki.nazwa LIKE 'BuildingC' AND
punkty_informacyjne.nazwa LIKE 'G';
--f. Wypisz pole powierzchni tej cz�ci budynku BuildingC, kt�ra znajduje si� w odleg�o�ci wi�kszej ni� 0.5 od budynku BuildingB.
SELECT ST_Area(ST_Difference(budynki.geometria,(SELECT ST_Buffer(geometria,0.5) FROM budynki WHERE nazwa LIKE 'BuildingB')) )
FROM budynki WHERE nazwa LIKE 'BuildingC';
--g. Wybierz te budynki, kt�rych centroid (ST_Centroid) znajduje si� powy�ej drogi o nazwie RoadX. 
SELECT nazwa, ST_AsText(ST_Centroid(geometria)) FROM budynki 
WHERE ST_Y(ST_Centroid(geometria)) > (SELECT ST_Y(ST_Centroid(geometria)) FROM drogi WHERE nazwa LIKE 'RoadX');
--8. Oblicz pole powierzchni tych cz�ci budynku BuildingC i poligonu o wsp�rz�dnych (4 7, 6 7, 6 8, 4 8, 4 7), kt�re nie s� wsp�lne dla tych dw�ch obiekt�w
SELECT ST_AREA(ST_SymDifference(geometria,ST_GeomFromText('POLYGON((4 7,6 7,6 8,4 8,4 7))',0))) AS PP FROM budynki 
WHERE nazwa='BuildingC';



