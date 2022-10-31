drop database if exists notes;
create database if not exists notes collate utf8_general_ci;
use notes;

select * from etudiants;

drop table if exists ville;
create table ville (id int auto_increment primary key)
select distinct ville as libelle from etudiants;
-- select * from ville;

drop table if exists classe;
create table classe (id int auto_increment primary key)
select distinct classe as libelle from etudiants;
-- select * from classe;

drop table if exists matiere;
create table matiere (id int auto_increment primary key)
select distinct matière as libelle from etudiants;
-- select * from matiere;

drop table if exists appreciation;
create table appreciation (id int auto_increment primary key)
select distinct appréciation as libelle from etudiants;
-- select * from appreciation;


drop table if exists stagiaire;
create table stagiaire (id int auto_increment primary key)
select distinct `Nom stagiaire` as nom ,
  `prénom Stagiaire` as prenom,
  date(concat(right(`Date Naissance`,4),'/', substring(`Date Naissance`,4,2),'/', left(`Date Naissance`,2))) daten ,
v.id as ville_id, 
c.id as classe_id
  from etudiants e inner join ville v on e.ville=v.libelle
                   inner join classe c on e.classe=c.libelle
  ;
 -- select * from stagiaire;
 
 
drop table if exists evaluation;
create table evaluation
select 
s.id as stagiaire_id,
m.id as matiere_id,
a.id as appreciation_id,
convert(replace(e.note,",","."),float) as note
from etudiants e inner join stagiaire s on  e.`Nom stagiaire` = s.nom 
										and e.`Prénom stagiaire` = s.prenom
inner join matiere m on e.matière = m.libelle
inner join appreciation a on e.appréciation =a.libelle;
select * from evaluation;

alter table evaluation add constraint pk_evaluation primary key (stagiaire_id, matiere_id, appreciation_id);


ALTER TABLE stagiaire add constraint fk_stagiaire_ville foreign key(ville_id) references ville(id);
ALTER TABLE stagiaire add constraint fk_stagiaire_classe foreign key(classe_id) references classe(id);

ALTER TABLE evaluation add constraint fk_evaluation_stagiaire foreign key(stagiaire_id) references stagiaire(id);
ALTER TABLE evaluation add constraint fk_evaluation_matiere foreign key(matiere_id) references matiere(id);
ALTER TABLE evaluation add constraint fk_evaluation_appreciation foreign key(appreciation_id) references appreciation(id);

drop table if exists etudiants;
