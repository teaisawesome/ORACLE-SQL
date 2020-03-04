-- Listázzuk azokat a női tagokat, akik kölcsönöztek olyan könyvet, amit még nem hoztak vissza.
SELECT DISTINCT tag.olvasojegyszam, vezeteknev||' '||keresztnev as nev FROM konyvtar.tag
INNER JOIN konyvtar.kolcsonzes ON tag.olvasojegyszam = kolcsonzes.tag_azon
WHERE visszahozasi_datum IS NULL AND nem = 'f';


-- Keressük azokat a szerzőket, akik 1900.01.01 előtt születtek és sci-fi,
--krimi vagy  horror témájú
-- könyvért 1000-nél több honoráriumot kaptak.

-- months_between(sysdate, to_date(szuletesi_datum, 'yyyy.mm.dd hh24:mi:ss'))/12
SELECT * FROM konyvtar.szerzo sz
INNER JOIN konyvtar.konyvszerzo ksz ON sz.szerzo_azon = ksz.szerzo_azon
INNER JOIN konyvtar.konyv k ON ksz.konyv_azon = k.konyv_azon
WHERE sz.szuletesi_datum > to_date('1900.01.01','yyyy.mm.dd') AND k.tema IN('sci-fi','krimi','horror') AND ksz.honorarium > 1000; 

SELECT * FROM hr.departments;

-- bal oldat és jobb oldalt megnézve
-- - bal oldalt nézem meg és az összeset kiakarom iratni független, hogy van e párja vagy nincs
SELECT * FROM hr.employees emp FULL OUTER JOIN hr.departments dept on emp.department_id = dept.department_id;


-- Listázzuk az összes szerzőt és ha kaptak honoráriumot
-- akkor tegyük a nevük mellé, melyik könyvért (könyvazon)
--könyvszerzőből várok mindenkit

SELECT sz.szerzo_azon, ksz.szerzo_azon, vezeteknev, keresztnev, honorarium, konyv_azon FROM konyvtar.szerzo sz LEFT OUTER JOIN konyvtar.konyvszerzo ksz ON sz.szerzo_azon = ksz.szerzo_azon ;


-- Listázzuk a sci-fi témájú könyvek azonosítóját, címét, és ha rendelkeznek példánnyal akkor a
-- leltári számukat és az értéküket.
SELECT k.konyv_azon, leltari_szam, ertek, cim FROM konyvtar.konyv k LEFT OUTER JOIN konyvtar.konyvtari_konyv kk ON k.konyv_azon = kk.konyv_azon WHERE tema = 'sci-fi';

-- count(*) sorokat számolja
-- Csoportosító függvények - MIN, MAX, COUNT, SUM, AVG   <- nem foglalkoznak a nullal
SELECT min(ar), max(tema), count(*), sum(ar), avg(ar), sum(ar)/count(*),
sum(ar)/count(ar), count(ar)
FROM konyvtar.konyv;

SELECT count(distinct tema) FROM konyvtar.konyv;
SELECT tema, konyv_azon, cim FROM konyvtar.konyv ORDER BY tema;
SELECT tema, konyv_azon, cim FROM konyvtar.konyv GROUP BY tema; -- nem groupby  kifejezés - a selectbe nem lehet akármit írni

-- SELECT -> ami benne van a groupby ba vagy csoportosító függvényt kell rá tenni
SELECT tema, count(*), min(ar), max(ar), sum(ar), avg(ar) FROM konyvtar.konyv GROUP BY tema;

-- 
SELECT tema, count(*), min(ar), max(ar), sum(ar), avg(ar) FROM konyvtar.konyv GROUP BY tema
HAVING count(*) > 5;

-- A 2000.01.01 előtt kiadott könyveből témánként hány darab van.
SELECT count(konyv_azon), tema FROM konyvtar.konyv WHERE kiadas_datuma < to_date('2000.01.01', 'yyyy.mm.dd') GROUP BY tema;

-- Melyek azok a témák amelyeből 2000.01.01 előtt pontosan 1 könyvet adtk ki.
-- A lista legyen rendezett.

SELECT tema, count(konyv_azon) FROM konyvtar.konyv WHERE kiadas_datuma < to_date('2000.01.01', 'yyyy.mm.dd') GROUP BY tema HAVING count(konyv_azon)=1 ORDER BY TEMA;

-- Besorolásonként mennyi az átlagos tagdíj?
SELECT besorolas, avg(tagdij) FROM konyvtar.tag GROUP BY besorolas; 

-- Születési évenként hány db női tag van?
SELECT EXTRACT(YEAR FROM szuletesi_datum), count(olvasojegyszam) FROM konyvtar.tag WHERE nem = 'n' GROUP BY EXTRACT(YEAR FROM szuletesi_datum);
SELECT to_char(szuletesi_datum, 'yyyy'), count(olvasojegyszam) FROM konyvtar.tag WHERE nem = 'n' GROUP BY to_char(szuletesi_datum, 'yyyy');

-- Melyek azok a témák, amelyeből 5-nél kevesebb  2000-nél olcsóbb könyvet adtak ki.
-- A lista legyen rendezett.
SELECT tema, count(konyv_azon) FROM konyvtar.konyv WHERE ar < 2000 GROUP BY tema HAVING count(konyv_azon) < 5 ORDER BY tema;

-- Hany sci-fi téműjú példány  ( könyvtári könyv) szerepel az adatbázisban.
SELECT count(leltari_szam) FROM konyvtar.konyv k INNER JOIN konyvtar.konyvtari_konyv kk ON kk.konyv_azon = k.konyv_azon
WHERE tema = 'sci-fi';
