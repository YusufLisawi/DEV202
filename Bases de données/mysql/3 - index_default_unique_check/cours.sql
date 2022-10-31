###################################
#indexes
###################################
drop table if exists test;

#creation d'un table avec un index
create table test (id int auto_increment primary key, nom varchar(50), index (nom));

#creation d'un nouveau champs, et creation de son index
alter table test add pays varchar(50);
alter table test add index (pays);

#autre methode de creation d'index
alter table test add ville varchar(50);
create index idx_ville on test (ville);

#creation d'un index sur plusieurs champs
alter table test add index (pays, ville);


#supprimer un index
drop index idx_ville on test;
alter table test drop index pays;



###################################
#default
###################################
drop table if exists test;

#creation d'un table avec la ville par defaut
create table test (id int auto_increment primary key, nom varchar(50), ville varchar(50) default 'tetouan');

#ajout d'un champs avec valeur par defaut
alter table test add pays varchar(50) default 'Maroc';

#ajout d'un champs
alter table test add langue varchar(50);

#ajout d'une valeur par defaut a un champ existant
alter table test alter column langue set default 'arabe';

#ajout d'un champs 
alter table test add ecole varchar(50);

#modifier le champs pour ajouter une valeur par defaut
alter table test modify ecole varchar(50) default 'ismo';

#test d'insertion
insert into test (nom) values ('a');
select * from test;
insert into test (nom, ecole) values ('b',null);


###################################
#unique
###################################

drop table if exists test;

#creation d'une table avec un champ unique
create table test (id int auto_increment primary key, nom varchar(50), cin varchar(50) unique);

#ajout d'un champs unique
alter table test add email varchar(50) unique;

#ajout d'un champ
alter table test add telephone varchar(50);


#ajout d'une contrainte de type unique sur un champs existant
alter table test add constraint unq_phone unique (telephone);

#ajoute d'une contrainte de type unique sur plusieurs champs
alter table test add constraint unq_phone_mail unique (telephone, email);


###################################
#checks, les contraintes de validation
###################################


drop table if exists produit;
#creation d'une table avec un règle de validation sur le prix
create table produit (id int auto_increment primary key, designation varchar(50), prix double,  check (prix>0));

#insertion
#pass
insert into produit (designation,prix) values ('pc',2500);

#erreur
insert into produit (designation,prix) values ('clavier',0);

#accept les null
insert into produit (designation) values ('clavier');


#pour qu'il n'accept plus les null
update produit set prix=1 where prix is null;

#methode1
alter table produit modify  prix double not null;

#methode 2
alter table produit add constraint chk_prix_null check(prix is not null);

#creation d'un règle de validation descactivée (not enforced)
drop table if exists produit;

#creation d'une table avec un champ unique
create table produit (id int auto_increment primary key, designation varchar(50), prix double,  check (prix>0) not enforced);

#tous les insertion passes 
insert into produit (designation,prix) values ('pc',2500);
insert into produit (designation,prix) values ('clavier',0);
insert into produit (designation) values ('clavier');
insert into produit (designation,prix) values ('clavier',-500);

#activation de la règle
alter table produit drop constraint produit_chk_1;

#erreur parceque les données viollent la règle
alter table produit add constraint produit_chk_1 check (prix >0 ) enforced;

#rectification des données
update produit set prix = 1 where prix <=0;

#activation de la règle
alter table produit add constraint produit_chk_1 check (prix >0) enforced;

