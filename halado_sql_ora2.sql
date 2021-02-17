-- Melyik autotot szereltek a legkevesebbszer?

select au.rendszam, count(sz.szereles_kezdete) 
from szerelo.sz_auto au
left outer join szerelo.sz_szereles sz
on au.azon = sz.auto_azon
group by au.rendszam, au.azon
having count(sz.szereles_kezdete) = (

select min(count(sz.szereles_kezdete))
from szerelo.sz_auto au left outer join
szerelo.sz_szereles sz
on au.azon = sz.auto_azon
group by au.rendszam, au.azon

);


-- Melyik autonak van a legkisebb elso_vasarlasi_ara?
select * from szerelo.sz_auto
where elso_vasarlasi_ar = (select min(elso_vasarlasi_ar) from szerelo.sz_auto);

-- Melyik tulajdonosnak van a legkevesebb autoja?
select tu.nev, count(atu.auto_azon) from szerelo.sz_tulajdonos tu left outer join
szerelo.sz_auto_tulajdonosa atu
on tu.azon = atu.tulaj_azon
group by tu.nev, tu.azon
having count(atu.auto_azon)=(select min(count(atu.auto_azon))
        from szerelo.sz_tulajdonos tu left outer join
        szerelo.sz_auto_tulajdonosa atu
        on tu.azon = atu.tulaj_azon
        group by tu.nev, tu.azon);
        
-- Az egyes  tulajdonosoknak melyik az utoljára vásárolt autójuk? (rendszam, tulaj nev)

-- itt a multkori kód kell!!!!!!


-- Töröljük azon autofelerekeleseket, amelyek esetén az érték több, mint az autó első vásárlási ára.
drop table sz_autofelertekeles;
create table sz_autofelertekeles as 
select * from SZERELO.sz_autofelertekeles;

            
delete from sz_autofelertekeles af -- ide nem lehet mást irni
where ertek > (select elso_vasarlasi_ar*0.8
from szerelo.sz_auto au
where af.auto_azon = au.azon);

-- Töröljük azon tulajdonosokat, akiknek nincs autójuk.
create table sz_tulajdonos as 
select * from SZERELO.sz_tulajdonos;

--select *
delete
from sz_tulajdonos
where azon not in ( select tulaj_azon from szerelo.sz_auto_tulajdonosa);

-- Módositsuk azon szerelések árát, amelyeket a leghosszabb nevu szerelomuhelyben végeztek. 
-- Az új ár legyen az autó elso_vasarlasi_aranak a 10-ed része.
create table sz_szereles as select * from szerelo.sz_szereles;

update sz_szereles sz
set munkavegzes_ara = (select elso_vasarlasi_ar/10
                       from szerelo.sz_auto au
                       where sz.auto_azon = au.azon)
where muhely_azon in (select azon
                      from szerelo.sz_szerelomuhely
                      where length(nev) = (select max(length(nev))
                                            from szerelo.sz_szerelomuhely));
                                        
-- Módositsuk azon auto_tulajdonlások vásárlási idejét, amelyek esetén a megvásárolt autót 3-nál többször szereltek.
-- Az új vásárlási idő legyen az utolsó befejezett munkavégézés vége;
create table sz_auto_tulajdonosa as
select * from SZERELO.sz_auto_tulajdonosa;

update sz_auto_tulajdonosa atu
set vasarlas_ideje = (select max(szereles_vege)
                       from szerelo.sz_szereles sz
                       where atu.auto_azon = sz.auto_azon)
where auto_azon in (select auto_azon
                    from szerelo.sz_szereles
                    group by auto_azon
                    having count(szereles_kezdete)>3);
                    
-- Töröljük azokat a szereléseket, amelyekhez tartozó autót utoljára Kiss Zoltán vásárolta meg.
drop table sz_szereles;
create table sz_szereles as select * from szerelo.sz_szereles;
--select *
delete
from sz_szereles sz
where auto_azon in (select auto_azon
                    from szerelo.sz_auto_tulajdonosa atu
                    where (auto_azon, vasarlas_ideje) in (select auto_azon, max(vasarlas_ideje)
                                                          from szerelo.sz_auto_tulajdonosa atu
                                                          group by auto_azon)
                   and tulaj_azon in (select azon from szerelo.sz_tulajdonos where nev = 'Kiss Zoltán'));
-------- ezek segedek:            
select *
from szerelo.sz_auto_tulajdonosa atu
where atu.tulaj_azon in (select azon
                         from szerelo.sz_tulajdonos where nev ='Kiss Zoltán');
                         
select *
from szerelo.sz_auto_tulajdonosa atu
where (auto_azon, vasarlas_ideje) in (select auto_azon, max(vasarlasi_ideje)
                                      from szerelo.sz_auto_tulajdonosa atu
                                      group by auto_azon)
and tulaj_azon in (select azon from szerelo.sz_tulajdonos
--------- 

-- Módositsuk azon szereléseket, esetén a szerelés kezdete 5 évvel
-- később kezdődött, mint az autó első vásárlás dátuma.
-- A szerelés munkavégézésének az ára legyen az eredeti munkavégzés ára minusz az autó első vásárlási árának az 1 százaléka.

-- add_months(sysdate, 5*12)
-- months_between(date1, date2)/12>5;

update sz_szereles sz
set munkavegzes_ara = munkavegzes_ara - (select 0.1*elso_vasarlasi_ar



