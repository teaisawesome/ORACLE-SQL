-- Listázzuk, hogy az egyes szerzők mennyi honoráriumot kaptak a sci-fi témájú könyvek
-- megírásáért.
-- A lista tartalmazza a könyvek címét is.
-- A lista legyen rendezett a honorárium szerint csökkenőbe.

-- outer join nem jo mert pl azokat is belekapnank akik nem is irtak konyvet.
SELECT sz.vezeteknev, ksz.honorarium, k.cim FROM KONYVTAR.szerzo sz INNER JOIN konyvtar.konyvszerzo ksz ON sz.szerzo_azon = ksz.szerzo_azon
INNER JOIN konyvtar.konyv k ON ksz.konyv_azon = k.konyv_azon
WHERE tema = 'sci-fi' ORDER BY honorarium DESC;

-- Témánként hány könyv és hány könyvtári példány van?
-- outer
-- mindig azt nevezem meg, amiben a másik táblából nincs párja
SELECT tema, count(k.konyv_azon), count(kk.leltari_szam) FROM konyvtar.konyv k
LEFT OUTER JOIN konyvtar.konyvtari_konyv kk ON k.konyv_azon = kk.konyv_azon
GROUP BY tema;

-- Melyek azok a sci-fi, krimi, vagy horror téműjú könyvek,
-- amelyekhez 3-nál kevesebb példány tartozik?
-- lehet egy könyvnál 3 nál kevesebb így outer

SELECT  konyv_azon, k.cim, k.tema, count(kk.leltari_szam) FROM konyvtar.konyv k
LEFT OUTER JOIN KONYVTAR.konyvtari_konyv kk ON k.konyv_azon = kk.konyv_azon
WHERE tema IN('sci-fi', 'krimi', 'horror') GROUP BY konyv_azon, cim, tema
HAVING count(kk.leltari_szam)<3;

-- Azokat a példányokat keressük, amelyek témája sci-fi, krimi vagy horror és értéke
-- kevesebb, mint 5.000. A leltári számokat listázzuk ki.
SELECT kk.leltari_szam FROM konyvtar.konyv k
INNER JOIN konyvtar.konyvtari_konyv kk ON k.konyv_azon = kk.konyv_azon
WHERE tema IN('sci-fi', 'krimi', 'horror') AND ertek < 5000;

-- beágyazott select
SELECT leltari_szam from KONYVTAR.konyvtari_konyv WHERE konyv_azon IN (
    SELECT konyv_azon FROM konyvtar.konyv WHERE tema IN('sci-fi', 'krimi', 'horror')
) AND ertek < 5000;

-- beágyazott select az INNER JOINban
SELECT kk.leltari_szam FROM konyvtar.konyvtari_konyv kk INNER JOIN (
SELECT konyv_azon FROM konyvtar.konyv WHERE tema IN('sci-fi', 'krimi', 'horror')
) bs ON kk.konyv_azon = bs.konyv_azon WHERE ertek < 5000;

-- Melyik a legdrágább könyv (ár)? -- ZH ba lesz
SELECT cim FROM konyvtar.konyv WHERE ar = (
    SELECT max(ar) FROM konyvtar.konyv
);

-- legidősebb, legfiatalabb
-- Ki a legidősebb tag?
SELECT * FROM konyvtar.tag WHERE szuletesi_datum = (
    SELECT min(szuletesi_datum) FROM konyvtar.tag
);

-- Kik azok a tagok, akik nem kölcsönöztek? Több megoldás ZH
SELECT vezeteknev||' '||keresztnev FROM konyvtar.tag WHERE olvasojegyszam NOT IN(
    SELECT tag_azon FROM konyvtar.kolcsonzes
);
-- v2
SELECT * FROM konyvtar.tag ta LEFT OUTER JOIN konyvtar.kolcsonzes ko 
on ta.olvasojegyszam  = ko.tag_azon WHERE ko.tag_azon is null;
-- v3
SELECT * FROM konyvtar.tag ta WHERE NOT EXISTS(
    SELECT 1 FROM konyvtar.kolcsonzes WHERE ta.olvasojegyszam = tag_azon
);

-- Melyek azok a könyvek, amelyek ára több, mint a sci-fi témájú könyvek átlagára? ZH

SELECT cim FROM konyvtar.konyv WHERE ar > (
SELECT avg(ar) FROM konyvtar.konyv WHERE tema = 'sci-fi'
);

--  A sci-fi témájú könyvek között melyik a legdrágább?
SELECT * FROM konyvtar.konyv WHERE tema = 'sci-fi' AND ar = (SELECT max(ar) FROM konyvtar.konyv WHERE tema='sci-fi');


-- Témánként a legdrágább könyv címe.
SELECT * FROM konyvtar.konyv WHERE (tema, ar) IN (SELECT tema, max(ar) FROM konyvtar.konyv GROUP BY tema);

-- Ez nem lesz ZH ba, maybe a 2. ba
SELECT cim FROM konyvtar.konyv k INNER JOIN (
SELECT tema, max(ar) mar FROM konyvtar.konyv GROUP BY tema) bs ON k.tema = bs.tema AND k.ar = bs.mar;

-- kolcsonzesi datum maximuma
-- Az utolsó kölcsönzéseben melyik tag (mi a neve) és mit(leltári szám, cim) kölcsözött?
SELECT * FROM KONYVTAR.konyv k
INNER JOIN konyvtar.konyvtari_konyv kk ON k.konyv_azon = kk.konyv_azon
INNER JOIN konyvtar.kolcsonzes ko ON kk.leltari_szam = ko.leltari_szam
INNER JOIN konyvtar.tag t ON t.olvasojegyszam = ko.tag_azon WHERE kolcsonzesi_datum = (
    SELECT MAX(kolcsonzesi_datum) FROM konyvtar.kolcsonzes
);

-- A legutoljára kiadott könyv.
SELECT * FROM konyvtar.konyv WHERE kiadas_datuma = (
    SELECT max(kiadas_datuma) FROM konyvtar.konyv
); 
