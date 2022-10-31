


# 1.	Liste des noms des éditeurs situés à Paris triés par ordre alphabétique. 
select * from editeur
where VILLEED='paris'
order by editeur.NOMED asc;

#2.	Liste des écrivains de (tous les champs)  langue française,
# triés par ordre alphabétique sur le nom et le prénom.

select * 
from ecrivain  
where LANGUECR='francais' 
order by  NOMECR asc,PRENOMECR asc; 

#3.	Liste des titres des ouvrages (NOMOUVR) ayant été  édités
# entre (ANNEEPARU) 1986 et 1987.
select nomouvr 
from ouvrage
where ANNEEPARU between 1986 and 1987; 

#4.	Liste des éditeurs dont le n° de téléphone est inconnu

Select Nomed 
from EDITEUR 
where TELED is Null;


#5.	Liste des auteurs (nom + prénom) dont le nom contient un ‘C’.
select NOMECR,PRENOMECR
from ecrivain
 where NOMECR like '%c%';

#6.	Liste des titres d’ouvrages contenant  le mot "banque" 
#(éditer une liste triée par n° d'ouvrage croissant). 
SELECT NOMOUVR,NUMOUVR
FROM OUVRAGE
WHERE NOMOUVR LIKE '%BANQUE%'
ORDER BY NUMOUVR; 

#7.	Liste des dépôts (nom) situés à Grenoble ou à Lyon. 

select NOMDEP,VILLEDEP
from depot
where VILLEDEP  in ('Grenoble','Lyon'); 


#8.	Liste des écrivains (nom + prénom) américains 
#ou de langue française.

select nomecr , prenomecr
from ecrivain
where PAYSECR = 'usa' or  LANGUECR = 'français';
#9.	Liste des auteurs (nom + prénom) de langue française dont 
#le nom ou le prénom commence par un ‘H’. 

#methode1
select nomecr , prenomecr
from ecrivain
where LANGUECR = 'français' 
and (nomecr regexp '^H' or prenomecr regexp '^H');

#methode2
select nomecr , prenomecr,languecr
from ecrivain
where LANGUECR = 'français' 
and (nomecr like 'H%' or prenomecr like 'H%');



#10.	Titres des ouvrages en stock au dépôt n°2. 

#methode1
select NOMOUVR 
from ouvrage 
where NUMOUVR in (select NUMOUVR 
					from stocker 
                    where NUMDEP = 2);
#methode2
select NOMOUVR 
from ouvrage o 
inner join stocker s on o.NUMOUVR=s.NUMOUVR 
where NUMDEP=2;
#11.	Liste des auteurs (nom + prénom) ayant écrit des livres
# coûtant au moins 30 € au 1/10/2002. 
#methode1
select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join tarifer tr on tr.NUMOUVR=ecr.NUMOUVR
where DATEDEB = '2002/10/01' and PRIXVENTE>=30;
#methode2
select nomecr,prenomecr 
from ecrivain 
where numecr in (select numecr 
				from ecrire 
				where numouvr in (select numouvr 
									from tarifer 
                                    where datedeb = '2002/10/01' 
                                    and prixvente >=30)
				)



#12.	Ecrivains (nom + prénom) ayant écrit des livres 
#sur le thème (LIBRUB) des « finances publiques ». 

select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join ouvrage ou on ou.NUMOUVR=ecr.NUMOUVR
inner join classification cla on ou.numrub=cla.numrub
where librub='finances publiques'


#13.	Idem R12 mais on veut seulement les auteurs dont le nom contient un ‘A’. 



select distinct nomecr,prenomecr 
from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join ouvrage ou on ou.NUMOUVR=ecr.NUMOUVR
inner join classification cla on ou.numrub=cla.numrub
where librub='finances publiques' and nomecr like '%a%';


#14.	En supposant l’attribut PRIXVENTE dans TARIFER 
#comme un prix TTC et un taux de TVA égal à 15,5% sur les ouvrages,
#donner le prix HT de chaque ouvrage. 

select nomouvr, prixvente,round(prixvente/1.155,3) as HT
from tarifer t inner join ouvrage o on t.NUMOUVR=o.NUMOUVR;


#15.	Nombre d'écrivains dont la langue est l’anglais ou l’allemand. 
#methode1
select count(*) 
from ecrivain 
where LANGUECR='anglais' or LANGUECR='allemand';

#methode2
select count(*) 
from ecrivain 
where LANGUECR in ('anglais','allemand');


#16.	Nombre total d'exemplaires d’ouvrages sur la 
#« gestion de portefeuilles » (LIBRUB) stockés dans les dépôts Grenoblois. 


#methode1
select sum(QTESTOCK) 
from stocker 
where NUMOUVR in (select NUMOUVR 
					from ouvrage 
                    where NUMRUB in (select NUMRUB 
										from classification 
                                        where librub = 'gestion de portefeuilles')
					)
and numdep in (select numdep from depot where villedep ='grenoble');

#methode2
select sum(qtestock)
from classification c
inner join ouvrage o on c.numrub = o.numrub
inner join stocker s on o.numouvr = s.numouvr
inner join depot d on s.numdep = d.numdep
where  villedep ='grenoble'
and librub = 'gestion de portefeuilles';

#17.	Titre de l’ouvrage ayant le prix le plus élevé
# - faire deux requêtes. (réponse: Le Contr ôle de gestion dans la banque.)


select nomouvr, prixvente from ouvrage o 
inner join tarifer t on o.numouvr=t.numouvr
where PRIXVENTE in (select max(PRIXVENTE) from tarifer);


#methode 2
with r1 as (select max(prixvente) maximum from tarifer)
select nomouvr, prixvente from ouvrage o 
inner join tarifer t on o.numouvr=t.numouvr
inner join r1 on prixvente = r1.maximum;

#methode3
create or replace view v1 as (select max(prixvente) maximum from tarifer);

select nomouvr, prixvente from ouvrage o 
inner join tarifer t on o.numouvr=t.numouvr
inner join v1 on prixvente = v1.maximum;

#methode4
create temporary table t1 select max(prixvente) maximum from tarifer;

select nomouvr, prixvente from ouvrage o 
inner join tarifer t on o.numouvr=t.numouvr
inner join t1 on prixvente = t1.maximum;

#18.	Liste des écrivains avec pour chacun le nombre 
#d’ouvrages qu’il a écrits. 

update ecrivain set prenomecr = null where numecr = 1;

select concat( ifnull(nomecr,''), ' ' , ifnull(prenomecr,'') )as nomComplet,count(*)
from ecrivain e
inner join ecrire ec on e.numecr= ec.numecr
group by nomecr ,prenomecr ;

#19.	Liste des rubriques de classification avec, pour chacune, 
#le nombre d'exemplaires en stock dans les dépôts grenoblois. 
select librub, sum(s.qtestock) as 'nb_ex' 
from classification c 
join ouvrage o on c.NUMRUB=o.NUMRUB 
join stocker s on s.NUMOUVR=o.NUMOUVR
join depot d on d.NUMDEP=s.NUMDEP
where VILLEDEP like 'grenoble'
group by c.LIBRUB ;

#20.	Liste des rubriques de classification avec leur état de stock 
#dans les dépôts grenoblois: ‘élevé’ s’il y a plus de 1000 exemplaires
# dans cette rubrique, ‘faible’ sinon. (réutiliser la requête 19). 
select librub, sum(s.qtestock), if(sum(qtestock)>1000, ' eleve','faible') as etat
from classification c 
join ouvrage o on c.NUMRUB=o.NUMRUB 
join stocker s on s.NUMOUVR=o.NUMOUVR
join depot d on d.NUMDEP=s.NUMDEP
where VILLEDEP like 'grenoble'
group by c.LIBRUB ;

/* ajoute des conditions
  > 5000 => tres eleve
  > 1000 =>  eleve
  > 500 => faible
  < 500 => tres faible
  */
#methode 1 avec if imbriqués
select librub, sum(s.qtestock), if(sum(qtestock)>5000, 'tres eleve',if(sum(qtestock)>1000,'eleve',if(sum(qtestock)>500,'faible','tres faible' ))) as etat
from classification c 
join ouvrage o on c.NUMRUB=o.NUMRUB 
join stocker s on s.NUMOUVR=o.NUMOUVR
join depot d on d.NUMDEP=s.NUMDEP
where VILLEDEP like 'grenoble'
group by c.LIBRUB ;

#methode 2 avec case when
select librub, sum(s.qtestock) ,
CASE
    WHEN sum(s.qtestock) > 5000 THEN "tres elevee"
    WHEN sum(s.qtestock) > 1000 THEN "elvee"
	WHEN sum(s.qtestock) > 500 THEN "faible"
    ELSE "tres faible"
END as etat
from classification c 
join ouvrage o on c.NUMRUB=o.NUMRUB 
join stocker s on s.NUMOUVR=o.NUMOUVR
join depot d on d.NUMDEP=s.NUMDEP
where VILLEDEP like 'grenoble'
group by c.LIBRUB ;

#une autre façon d'ecrire case when
select distinct paysecr ,
case paysecr
when 'France' then 'فرنسا'
when 'Grande Bretagne' then 'بريطانيا'
when 'USA' then 'الولايات المتحدة'
when 'Pays bas' then 'هولاندا'
when 'Allemagne' then 'ألمانيا'
when 'Italie' then 'إيطاليا'
end as arabic
from ecrivain;



#21.	Liste des auteurs (nom + prénom) ayant écrit des livres sur 
#le thème (LIBRUB) des « finances publiques » ou bien ayant écrit des 
#livres coûtant au moins 30 € au 1/10/2002 - réutiliser les 
#requêtes 11 et 12. 
select distinct * from (
select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join tarifer tr on tr.NUMOUVR=ecr.NUMOUVR
where DATEDEB = '2002/10/01' and PRIXVENTE>=30
union all
select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join ouvrage ou on ou.NUMOUVR=ecr.NUMOUVR
inner join classification cla on ou.numrub=cla.numrub
where librub='finances publiques') t1;


with t1 as (select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join tarifer tr on tr.NUMOUVR=ecr.NUMOUVR
where DATEDEB = '2002/10/01' and PRIXVENTE>=30),
t2 as (select distinct nomecr,prenomecr from ecrivain e
inner join ecrire ecr on e.NUMECR=ecr.NUMECR
inner join ouvrage ou on ou.NUMOUVR=ecr.NUMOUVR
inner join classification cla on ou.numrub=cla.numrub
where librub='finances publiques')


select * from t1
union 
select * from t2;




#22.	Liste des écrivains (nom et prénom) n’ayant écrit aucun des
# ouvrages présents dans la base. 

select nomecr,prenomecr,numecr
from ecrivain
where NUMECR not in ( select NUMECR from ecrire);

#23.	Mettre à 0 le stock de l’ouvrage n°6 dans le dépôt Lyon2. 
#methode 1
update stocker set qtestock=0
where numouvr=6
and numdep in (select numdep 
				from depot 
                where nomdep='Lyon2');
 #methode 2               
update stocker s inner join depot d on s.numdep = d.numdep
set qtestock=0                
where numouvr = 6 and nomdep = 'lyon2';

                

#24.	Supprimer tous les ouvrages de chez Vuibert de la table OUVRAGE.
delete from ecrire where numouvr in (select numouvr from ouvrage where nomed like 'Vuibert');
delete from stocker where numouvr in (select numouvr from ouvrage where nomed like 'Vuibert');
delete from tarifer where numouvr in (select numouvr from ouvrage where nomed like 'Vuibert');
delete from ouvrage where nomed like 'Vuibert';

#25.	créer une table contenant les éditeurs situés à Paris et leur 
#n° de tel.  
create table editeure
select nomed,teled from editeur
where VILLEED = 'Paris';