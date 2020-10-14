--1.Utw�rz now� baz� danych nazywaj�c j� sNumerIndeksu(na przyk�ad s222195).
CREATE DATABASE s304198;
--2.Dodaj schemat o nazwie firma.
CREATE SCHEMA firma;
--3.Stw�rz rol� o nazwie ksiegowosci nadaj jej uprawnienia tylko do odczytu.
CREATE ROLE ksiegowosc;
GRANT SELECT ON ALL TABLES IN SCHEMA firma To ksiegowosc;
--4.Dodaj cztery tabele:
--pracownicy(id_pracownika, imie, nazwisko, adres, telefon)
--godziny(id_godziny, data, liczba_godzin,id_pracownika)
--pensja_stanowisko(id_pensji, stanowisko, kwota)
--premia(id_premii, rodzaj, kwota)
-- wynagrodzenie(id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii)
CREATE TABLE ksiegowosc.pracownicy(
    id_pracownika INT  UNIQUE PRIMARY KEY NOT NULL,
    imie VARCHAR(50) NOT NULL,
    nazwisko  VARCHAR(50) NOT NULL,
    adres VARCHAR (100) NOT NULL, 
    telefon VARCHAR(12) NOT NULL
);

CREATE TABLE ksiegowosc.godziny(
    id_godziny INT UNIQUE PRIMARY KEY NOT NULL,
    data VARCHAR (25) NOT NULL,
    liczba_godzin INT,
    id_pracownika REFERENCES INT
);

CREATE TABLE ksiegowosc.pensje(
    id_pensji INT UNIQUE PRIMARY KEY NOT NULL,
    stanowisko VARCHAR (50) NOT NULL,
    kwota INT,
    id_premii REFERENCES INT
);

CREATE TABLE ksiegowosc.premie(
    id_premii INT UNIQUE PRIMARY KEY,
    rodzaj VARCHAR (50) NOT NULL,
    kwota INT
);
CREATE TABLE ksiegowosc.wynagrodzenie (
	id_wynagrodzenia INT UNIQUE PRIMARY KEY  NOT NULL,
	data VARCHAR(25) NOT NULL,
	id_pracownika INT REFERENCES ksiegowosc.pracownicy(id_pracownika),
	id_godziny INT REFERENCES ksiegowosc.godziny(id_godziny),
	id_pensji INT REFERENCES ksiegowosc.pensje(id_pensji),
	id_premii INT REFERENCES ksiegowosc.premie(id_premii)
);
--a)Ustal typy danych tak, aby przetwarzanie i sk�adowanie danych by�o najbardziej optymalne. Zastan�w si�, kt�re pola musz� przyjmowa� warto�� NOT NULL.

--b)Ustaw klucz g��wny dla ka�dej tabeli �u�yj polecenia ALTER TABLE -- wczytanie danych do tabeli pracownicy
ALTER TABLE firma.pracownicy ADD CONSTRAINT id_pracownika PRIMARY KEY(id_pracownika);
ALTER TABLE firma.godziny ADD CONSTRAINT id_godziny PRIMARY KEY(id_godziny);
ALTER TABLE firma.pensje ADD CONSTRAINT id_pensja PRIMARY KEY(id_pensja);
ALTER TABLE firma.premie ADD CONSTRAINT id_premii PRIMARY KEY(id_premii);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT id_wynagrodzenia PRIMARY KEY(id_wynagrodzenia);
--c)Zastan�w si� jakie relacje zachodz� pomi�dzy tabelami, a nast�pnie dodaj kluczeobce tam, gdzie wyst�puj�
ALTER TABLE firma.godziny ADD CONSTRAINT id_pracownika FOREIGN KEY(id_pracownika) REFERENCES firma.pracownicy(id_pracownika);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT id_pracownika FOREIGN KEY(id_pracownika) REFERENCES firma.pracownicy(id_pracownika);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT id_premii FOREIGN KEY(id_premii) REFERENCES firma.premie(id_premii);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT id_pensji FOREIGN KEY(id_pensji) REFERENCES firma.pensje(id_pensja);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT id_godziny FOREIGN KEY(id_godziny) REFERENCES firma.godziny(id_godziny);
--d)Za�� indeks tam, gdzie uznasz, i� jest on potrzebny. Indeksowanie metod� B-drzewa. Wybierz odpowiedni� kolumn�!

--e)Ustaw opisy/komentarze ka�dej tabeli �u�yj polecenia COMMENT
COMMENT ON TABLE ksiegowosc.pracownicy IS 'Pracownicy naszej firmy';
COMMENT ON TABLE ksiegowosc.godziny IS 'Godziny przepracowane z ostatnich dni';
COMMENT ON TABLE ksiegowosc.pensje IS 'Wyp�ata dla ka�dego stanowiska';
COMMENT ON TABLE ksiegowosc.premie IS 'Dodatkowe pieniadze dla pracownikow';
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Podsumowanie';
--f)Ustal wi�zy integralno�ci tak, aby po usuni�ciu, czy modyfikacji nie wyzwalano �adnej akcji

--5.Wype�nij tabele tre�ci� wg poni�szego wzoru(ka�da tabela ma zawiera� min.10 rekord�w). 
INSERT INTO ksiegowosc.pracownicy 
VALUES(1,'Wiktor', 'Kot', 'ul.Sadowa 12, 30-204 Krakow', 789465783);
INSERT INTO ksiegowosc.pracownicy  
VALUES(2,'Piotr', 'Wrona', 'ul. Okolna 2, 30-188 Krakow', 786795678);
INSERT INTO ksiegowosc.pracownicy  
VALUES(3,'Oliwia', 'Mazur', 'ul. Pi�kna 17, 30-456 Krakow', 673456867);
INSERT INTO ksiegowosc.pracownicy 
VALUES(4,'Nadia', 'Rak', 'ul. Widokowa 34, 30-234 Krakow', 789123423);
INSERT INTO ksiegowosc.pracownicy 
VALUES(5,'Janina', 'Salomon', 'ul.Szkolna 1, 30-959 Krakow', 874508970);
INSERT INTO ksiegowosc.pracownicy 
VALUES(6,'Patrycja', 'Wilczek', 'ul. Radosna 34, 30-846 Krakow', 756468467);
INSERT INTO ksiegowosc.pracownicy 
VALUES(7,'Andrzej', 'Telec', 'ul. Polna 74, 30-272 Krakow', 567234576);
INSERT INTO ksiegowosc.pracownicy 
VALUES(8,'Konrad', 'Feliks', 'ul. Modra 45 Krakow', 754356789);
INSERT INTO ksiegowosc.pracownicy  
VALUES(9,'Patryk', 'Sowa', 'ul. Kolna 212, 30-929 Krakow', 583635278 );
INSERT INTO ksiegowosc.pracownicy 
VALUES(10,'Julia', 'Palec', 'ul. Bysra 3, 30-239 Krakow', 673468967);

INSERT INTO ksiegowosc.godziny 
VALUES(1,'2019-04-05', 6, 1);
INSERT INTO ksiegowosc.godziny
VALUES(2,'2019-04-05', 8, 10);
INSERT INTO ksiegowosc.godziny
VALUES(3,'2019-04-05', 6, 3);
INSERT INTO ksiegowosc.godziny 
VALUES(4,'2019-04-05', 7, 4);
INSERT into ksiegowosc.godziny
VALUES(5,'2019-04-06', 8, 5);
INSERT INTO ksiegowosc.godziny
VALUES(6,'2019-04-06', 7, 9);
INSERT INTO ksiegowosc.godziny 
VALUES(7,'2019-04-06', 9, 8);
INSERT INTO ksiegowosc.godziny 
VALUES(8,'2019-04-06', 10, 4);
INSERT INTO ksiegowosc.godziny
VALUES(9,'2019-04-07', 8 , 3);
INSERT INTO ksiegowosc.godziny
VALUES(10,'2019-04-07', 7, 1);

INSERT INTO ksiegowosc.premie
VALUES(1,'premia �wi�teczna', 300);
INSERT INTO ksiegowosc.premie
VALUES(2,'premia za nadgodziny', 150);
INSERT into ksiegowosc.premie 
VALUES(3,'premia za punktualno��', 180);
INSERT INTO ksiegowosc.premie 
VALUES(4,'premia za sprzeda�', 330);
INSERT INTO ksiegowosc.premie 
VALUES(5,'premia dla pracownika miesi�ca', 400);
INSERT INTO ksiegowosc.premie
VALUES(6,'premia frekwencyjna', 260);
INSERT INTO ksiegowosc.premie
VALUES(7,'premia za prace weekendow�', 180);
INSERT INTO ksiegowosc.premie
VALUES(8,'brak premii', 8);
INSERT INTO ksiegowosc.premie
VALUES(9,'premia za terminowo��', 170);
INSERT INTO ksiegowosc.premie
VALUES(10,'premia za pomoc', 100);

INSERT INTO ksiegowosc.pensje 
VALUES(1,'m�odszy analityk', 3500,1);
INSERT INTO ksiegowosc.pensje 
VALUES(2,'starszy analityk', 4000,1);
INSERT INTO ksiegowosc.pensje 
VALUES(3,'ksi�gowy', 4000,7);
INSERT into ksiegowosc.pensje 
VALUES(4,'m�odszy ksi�gowy', 3500,7);
INSERT into ksiegowosc.pensje 
VALUES(5,'g��wny analityk', 5500,9);
INSERT INTO ksiegowosc.pensje 
VALUES(6,'g��wny ksi�gowy', 5500,3);
INSERT INTO ksiegowosc.pensje 
VALUES(7,'specjalista ds. rozwoju', 3600,3);
INSERT INTO ksiegowosc.pensje 
VALUES(8,'specjalista ds. promocji', 3600,9);
INSERT INTO ksiegowosc.pensje  
VALUES(9,'v-ce prezes', 10000,9);
INSERT INTO ksiegowosc.pensje  
VALUES(10,'prezes', 15000,1);

INSERT INTO ksiegowosc.wynagrodzenie
VALUES(1,'2019-04-08',1,1,9,8);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(2,'2019-04-08',2,2,10,1);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(3,'2019-04-08',3,3,4,1);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(4,'2019-04-08',4,4,8,3);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(5,'2019-04-08',5,5,3,6);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(6,'2019-04-08',6,6,3,1);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(7,'2019-04-08',7,7,4,1);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(8,'2019-04-09',8,8,5,2);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(9,'2019-04-09',9,9,2,1);
INSERT INTO ksiegowosc.wynagrodzenie
VALUES(10,'2019-04-09',10,10,3,10);

--a)W tabeli godziny, dodaj pola przechowuj�ce informacje o miesi�cu oraz numerze tygodnia danego roku (rok ma 53 tygodnie). Oba maj� by� typu DATE.
ALTER TABLE firma.godziny ADD COLUMN miesiac INT;
UPDATE firma.godziny SET miesiac=DATE_PART('month',data)
SELECT DATE_PART('month',data) FROM firma.godziny;
--b)W tabeli wynagrodzenie zamie� pole data na typ tekstowy. 
ALTER TABLE firma.wynagrodzenie ALTER COLUMN data TYPE VARCHAR(20);
--c)Pole �rodzaj� w tabeli premia ma przyjmowa� tak�e warto�� �brak�. Wtedy kwota premii r�wna si� zero.
INSERT INTO firma.premie(id_premii,rodzaj,kwota) VALUES (11,'brak',0)

--6.Wykonaj nast�puj�ce zapytania:
--a)Wy�wietl tylko id pracownika oraz jego nazwisko
SELECT id_pracownika,nazwisko FROM ksiegowosc.pracownicy;
--b)Wy�wietl id pracownik�w, kt�rych p�aca jest wi�ksza ni� 1000
SELECT id_pracownika FROM ksiegowosc.wynagrodzenie, ksiegowosc.pensje  
WHERE ksiegowosc.wynagrodzenie.id_pensji=ksiegowosc.pensje.id_pensji
AND kwota > '1000';
--c)Wy�wietl id pracownik�w nie posiadaj�cych premii, kt�rych p�aca jest wi�ksza ni� 2000 
SELECT id_pracownika FROM ksiegowosc.wynagrodzenie, ksiegowosc.pensje
WHERE ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensje.id_pensji
AND ksiegowosc.wynagrodzenie.id_premii = '8'
--d)Wy�wietl  pracownik�w, kt�rych pierwsza litera imienia zaczyna si� na liter� �J�e)Wy�wietl pracownik�w, kt�rych nazwisko zawiera liter� �n� oraz imi� ko�czy si� na liter� �a�
SELECT * FROM ksiegowosc.pracownicy 
WHERE imie LIKE 'J%'; 
--f)Wy�wietl imi� i nazwisko pracownik�w oraz liczb� ich nadgodzin, przyjmuj�c, i� standardowy czas pracy to 160 h miesi�cznie.
SELECT imie, nazwisko, liczba_godzin - 160 AS nadgodziny
FROM ksiegowosc.pracownicy JOIN ksiegowosc.godziny ON pracownicy.id_pracownika = godziny.id_pracownika;
--g)Wy�wietl imi� i nazwisko pracownik�w, kt�rych pensja zawiera si� w przedziale 1500 �3000 
SELECT imie, nazwisko FROM ksiegowosc.pracownicy 
JOIN ksiegowosc.wynagrodzenie ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika 
JOIN ksiegowosc.pensje ON ksiegowosc.pensje.id_pensji = ksiegowosc.wynagrodzenie.id_pensji 
WHERE kwota BETWEEN 1500 AND 3000;
--h)Wy�wietl imi� i nazwisko pracownik�w, kt�rzy pracowali w nadgodzinach i nie otrzymali premii
SELECT imie, nazwisko, liczba_godzin -160 AS nadgodziny, id_premii
FROM ksiegowosc.pracownicy, ksiegowosc.godziny, ksiegowosc.wynagrodzenie
WHERE ksiegowosc.pracownicy.id_pracownika = ksiegowosc.godziny.id_pracownika
AND ksiegowosc.wynagrodzenie.id_godziny = ksiegowosc.godziny.id_godziny
AND id_premii = '8' AND liczba_godzin > 160;
--7.Wykonaj poni�sze polecenia:
--a)Uszereguj pracownik�w wed�ug pensji
SELECT pracownicy.*, kwota FROM ksiegowosc.pracownicy 
JOIN ksiegowosc.wynagrodzenie ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika 
JOIN ksiegowosc.pensje ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensje.id_pensji
ORDER BY kwota;
--b)Uszereguj pracownik�w wed�ug pensji i premii malej�co
SELECT pracownicy.*, pensje.kwota, premie.kwota FROM ksiegowosc.pracownicy 
JOIN ksiegowosc.wynagrodzenie ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika 
JOIN ksiegowosc.pensje ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensje.id_pensji 
JOIN ksiegowosc.premie ON ksiegowosc.wynagrodzenie.id_premii = ksiegowosc.premie.id_premii
ORDER BY pensje.kwota, premie.kwota DESC;
--c)Zlicz i pogrupujpracownik�w wed�ug pola �stanowisko�
SELECT stanowisko, COUNT(stanowisko) AS "ilosc" FROM ksiegowosc.pracownicy 
JOIN ksiegowosc.wynagrodzenie ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika 
JOIN ksiegowosc.pensje ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensje.id_pensji
GROUP BY stanowisko;
--d)Policz �redni�, minimaln� i maksymaln�p�ac� dla stanowiska �kierownik�(je�eli takiego nie masz, to przyjmij dowolne inne)
SELECT CAST(AVG(kwota::numeric) AS DECIMAL(10,2)) AS �rednia, MIN(kwota::numeric) AS minimum,MAX(kwota::numeric) AS maksimum
FROM ksiegowosc.pensje WHERE ksiegowosc.pensje.stanowisko = 'prezes';
--e)Policz sum� wszystkich wynagrodze�
SELECT SUM(kwota) FROM ksiegowosc.pensje;
--f)Policz sum� wynagrodze� w ramach danego stanowiskag)Wyznacz liczb� premii przyznanych dla pracownik�w danego stanowiskah)Usu� wszystkich pracownik�w maj�cych pensj� mniejsz� ni� 1200 z�
SELECT stanowisko,SUM(kwota) AS kwota_wg_stanowiska FROM ksiegowosc.pensje GROUP BY stanowisko;
--8.Wykonaj poni�sze polecenia
--a)Zmodyfikuj numer telefonu w tabeli pracownicy,dodaj�c do niego kierunkowy dla Polski w nawiasie (+48)
UPDATE ksiegowosc.pracownicy 
SET telefon='(+48)' || pracownicy.telefon;
--b)Zmodyfikuj kolumn� telefon w tabeli pracownicy tak, aby numer oddzielony by� my�lnikamiwg wzoru:�555-222-333�
UPDATE ksiegowosc.pracownicy 
SET telefon = SUBSTRING(telefon,1,8) || '-' || SUBSTRING(telefon,9,3) || '-' || SUBSTRING(telefon,12,3);
--c)Wy�wietl dane pracownika, kt�rego nazwisko jest najd�u�sze,u�ywaj�c wielkich liter
SELECT ksiegowosc.pracownicy.*, MD5(CAST(pensje.kwota AS VARCHAR)) AS md5_kwota FROM ksiegowosc.pracownicy 
JOIN ksiegowosc.wynagrodzenie ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika 
JOIN ksiegowosc.pensje ON wynagrodzenie.id_pensji = pensje.id_pensji;
--d)Wy�wietl dane pracownik�w i ich pensje zakodowane przy pomocy algorytmu md5
SELECT pracownicy.imie, pracownicy.nazwisko, pensje.kwota, premie.kwota 
FROM ksiegowosc.wynagrodzenie  
LEFT JOIN ksiegowosc.pracownicy ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
LEFT JOIN ksiegowosc.pensje ON wynagrodzenie.id_pensji = pensje.id_pensji
LEFT JOIN ksiegowosc.premie ON wynagrodzenie.id_premii = premie.id_premii;

--9.Raport ko�cowyUtw�rz zapytanie zwracaj�ce w wyniku tre�� wg poni�szego szablonu:
--Pracownik Jan Nowak, w dniu 7.08.2017 otrzyma� pensj� ca�kowit� na kwot� 7540 z�, gdzie wynagrodzeniezasadnicze wynosi�o:
--5000 z�, premia: 2000 z�, nadgodziny: 540 z�.
SELECT CONCAT('Pracownik ', ksiegowosc.pracownicy.imie, ' ',ksiegowosc.pracownicy.nazwisko,' ,w dniu ',
ksiegowosc.godziny.data,' otrzyma� pensj� ca�kowit� na kwot� ',COALESCE(ksiegowosc.premie.kwota,0)+COALESCE(ksiegowosc.pensje.kwota,0),
' ,gdzie wynagrodzenie zasadnicze wynosi�o: ',ksiegwosc.pensje.kwota,
' ,nadgodziny: ', ksiegowosc.premie.kwota) AS Informacja
FROM ksiegowosc.wynagrodzenie
LEFT JOIN ksiegowosc.pensje ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensje.id_pensji
LEFT JOIN ksiegowosc.premie ON ksiegowosc.wynagrodzenie.id_premii = ksiegowosc.premie.id_premii 
LEFT JOIN ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
LEFT JOIN ksiegowosc.godziny ON ksiegowosc.godziny.id_pracownika = ksiegowosc.pracownicy.id_pracownika;

