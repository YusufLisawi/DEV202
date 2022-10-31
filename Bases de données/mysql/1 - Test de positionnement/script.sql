create database if not exists location collate utf8_general_ci;
use location;


drop table if exists contrat;
drop table if exists client;
drop table if exists bien;
drop table if exists type_bien;
drop table if exists quartier;
drop table if exists ville;


create table quartier(id int AUTO_INCREMENT primary key, 
	libelle varchar(50) not null, 
	id_ville int
)engine=innodb charset=utf8;

create table ville(id int AUTO_INCREMENT ,
	libelle varchar(50) not null,
	constraint pk_ville primary key(id)
)engine=innodb;


create table bien(reference int AUTO_INCREMENT , 
	superficie  float not null,
	nb_pieces int not null,
	loyer  float not null,
	adresse varchar(250),
	id_type_bien int,
	id_quartier int,
	cin varchar(12),
	constraint pk_bien primary key(reference)
)engine=innodb;


create table type_bien(id int AUTO_INCREMENT,
	libelle varchar(50) not null,
	constraint pk_type_bien primary key(id)
)engine=innodb;


create table client(cin varchar(12), 
	nom varchar(50) not null,
	prenom varchar(50), 
	telephone varchar(12),
	adresse varchar(250),
	constraint pk_client primary key(cin)
)engine=innodb;

create table contrat(reference int, 
	cin varchar(12), 
	date_creation date not null,
	date_entree date, 
	date_sortie date, 
	loyer float not null, 
	charges float,
	constraint pk_contart primary key(reference, cin)
)engine=innodb;


alter table quartier add constraint fk_quartier_ville foreign key (id_ville) references ville(id);
alter table bien add constraint fk_bien_quartier foreign key (id_quartier) references quartier(id);
alter table bien add constraint fk_bien_type_bien foreign key (id_type_bien) references type_bien(id);
alter table bien add constraint fk_bien_client foreign key (cin) references client(cin);

alter table contrat add constraint fk_contrat_bien foreign key (reference) references bien(reference);
alter table contrat add constraint fk_contrat_client foreign key (cin) references client(cin);




