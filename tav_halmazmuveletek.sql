-- Listázza az öt legidősebb szerző nevét és születési dátumát.
-- 
select keresztnev
from konyvtar.szerzo
union
select keresztnev
from konyvtar.tag;


-- duplikátumokat is kilistázza
select keresztnev
from konyvtar.szerzo
union all
select keresztnev
from konyvtar.tag
order by keresztnev;


select keresztnev
from konyvtar.szerzo
union all
select vezeteknev
from konyvtar.tag
order by keresztnev;


-- TABLE 1 / TABLE 2
select keresztnev
from konyvtar.szerzo
minus
select keresztnev
from konyvtar.tag
order by keresztnev;

select vezeteknev, 2 from konyvtar.szerzo
union 
select keresztnev, 1 from konyvtar.szerzo;

select 1 from dual union select '2' from dual;/*nem egyforma a típus*/


select vezeteknev, nem from konyvtar.tag intersect select keresztnev from konyvtar.tag;/*nem egyforma az oszlopszám*/

-- Listázza az összes keresztnevet a tag és a szerző táblákból ismétlődésekkel
select keresztnev
from konyvtar.szerzo
union all
select keresztnev
from konyvtar.tag;


-- Listázza azokat a keresztneveket, amelyek a tag és a szerző táblában is szerepelnek:;
select keresztnev
from konyvtar.szerzo
intersect
select keresztnev
from konyvtar.tag;
-- Gyula, Zoltán, Zsolt

select distinct sz.keresztnev
from konyvtar.szerzo sz inner join 
konyvtar.tag t
on sz.keresztnev=t.keresztnev;


-- Listázza azokat a keresztneveket, amelyek a szerző táblában szerepelnek, de a tag táblában nem:;
select keresztnev
from konyvtar.szerzo
minus
select keresztnev
from konyvtar.tag
order by keresztnev;

SELECT distinct keresztnev
FROM konyvtar.szerzo WHERE keresztnev NOT IN(
    SELECT keresztnev FROM konyvtar.tag
) ORDER BY keresztnev;


-- A minus nagyszerűen használható arra, hogy megnézzük, hogy két lekérdezés eredménye valóban ugyanaz-e:
select distinct keresztnev
from konyvtar.szerzo 
where keresztnev not in (select keresztnev 
                             from konyvtar.tag)
minus
select distinct keresztnev
from konyvtar.szerzo sz 
where not exists (select 1  
                  from konyvtar.tag t
                  where sz.keresztnev=t.keresztnev);
                  
select distinct keresztnev
from konyvtar.szerzo sz 
where not exists (select 1  
                  from konyvtar.tag t
                  where sz.keresztnev=t.keresztnev)
minus
select distinct keresztnev
from konyvtar.szerzo 
where keresztnev not in (select keresztnev 
                             from konyvtar.tag);
