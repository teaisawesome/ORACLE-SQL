-- Listázzuk ki azokat a szerzőket, akiknek a nevében legalább két darab e betű szerepel, vagy az életkoruk 100 és 200 között van. A szerzőknek a neve, életkor, születésnév, név szerint rendezve

SELECT vezeteknev||' '||keresztnev nev, to_char(szuletesi_datum, 'yyyy.mm.dd'), months_between(sysdate, to_date(szuletesi_datum, 'yyyy.mm.dd hh24:mi:ss'))/12 as eves FROM KONYVTAR.szerzo, dual
WHERE lower(vezeteknev||' '||keresztnev) LIKE '%e%e%' OR
months_between(sysdate, to_date(szuletesi_datum, 'yyyy.mm.dd hh24:mi:ss'))/12 BETWEEN 100 AND 200
ORDER BY eletkor DESC, nev;

-- akinek a születési dátuma nincs megadva vagy 1 vagy 3 szóbol áll a nevük, nev és születési dátum
SELECT vezeteknev||' '||keresztnev nev, szuletesi_datum FROM konyvtar.szerzo
WHERE vezeteknev||' '||keresztnev NOT LIKE '% %'
OR vezeteknev||' '||keresztnev LIKE '% % %' AND
vezeteknev||' '||keresztnev NOT LIKE '% % % %'
OR szuletesi_datum IS NOT NULL ORDER BY szuletesi_datum NULLS FIRST;


-- Steven King milyen részlegen dolgozik
--hr séma
SELECT department_name FROM HR.employees emp, HR.departments dept
WHERE emp.department_id = dept.department_id AND first_name='Steven' AND last_name = 'King';

SELECT department_name FROM HR.employees emp INNER JOIN HR.departments dept
ON emp.department_id = dept.department_id WHERE first_name='Steven' AND last_name = 'King';


-- nem fogjuk használni de ez is van
SELECT department_name FROM HR.employees emp INNER JOIN HR.departments dept
using (department_id) WHERE first_name='Steven' AND last_name = 'King';

-- nem fogjuk használni
SELECT department_name FROM HR.employees emp NATURAL JOIN HR.departments dept WHERE first_name='Steven' AND last_name = 'King';

-- A Napóleon című könyvhöz tartozó példányok azonosítóját szeretnénk látni.
-- konyv és könyvtari kony
SELECT leltari_szam FROM konyvtar.konyv konnyv INNER JOIN konyvtar.konyvtari_konyv konyvtarkonyv
ON konnyv.konyv_azon = konyvtarkonyv.konyv_azon WHERE cim LIKE '%Napóleon%';

-- Kik azok a tagok, akiknek van olyan kölcsönzése, amely esetén még nem hozták vissza a könyvet?

SELECT DISTINCT(t.vezeteknev||' '||t.keresztnev) nev FROM konyvtar.kolcsonzes k INNER JOIN konyvtar.tag t ON k.tag_azon = t.olvasojegyszam
WHERE k.visszahozasi_datum IS NULL ;

-- Agatha Christie az egyes könyvek megírásáért mennyi honoráriumot kapott? Listázzuk ki a könyv azonosítóját és
-- a honoráriumot.
SELECT ksz.konyv_azon azonosito, ksz.honorarium honor FROM konyvtar.szerzo sz INNER JOIN konyvtar.konyvszerzo ksz ON sz.szerzo_azon = ksz.szerzo_azon
WHERE sz.vezeteknev = 'Christie' AND sz.keresztnev = 'Agatha';

-- Agatha Christie az egyes könyvek megírásáért mennyi honoráriumot kapott? Listázzuk ki a könyv azonosítóját, címét
-- a honoráriumot.
SELECT ksz.konyv_azon azonosito, ksz.honorarium honor, k.cim FROM konyvtar.szerzo sz
INNER JOIN konyvtar.konyvszerzo ksz ON sz.szerzo_azon = ksz.szerzo_azon
INNER JOIN konyvtar.konyv k ON ksz.konyv_azon = k.konyv_azon
WHERE sz.vezeteknev = 'Christie' AND sz.keresztnev = 'Agatha';
