#La Gestion des Exceptions

#ouverture d'une base de données
use notes;

#creation de la table test avec un id et nom non null et unique
drop table if exists test;
create table test (id int auto_increment primary key, nom varchar(50) not null unique);

#insertion d'un enregistrement avec succes
	insert into test (nom) values ('iam');
    
#insertion d'un enregistrement avec erreur de doublon
#on note le numero d'erreur
	insert into test (nom) values ('iam');
    
#insertion d'un enregistrement avec erreur de valeur null
#on note le numero d'erreur
	insert into test (nom) values (null);


#creation d'un solution pour gérer ces exceptions
drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	-- gestionnaire d'erreur en cas de doublons
    declare exit handler for 1062
    begin
		select "ce nom existe déjà";
    end;
	
    -- gestinnaire d'erreur en cas de valeur null
    declare exit handler for 1048
    begin
		select "le nom ne peut pas être null";
    end;
    
	insert into test (nom) values (v_name);
end$$
delimiter ;

#regroupement de la gestion des erreur avec un condition sur une variable qui change lors de l'interception de l'erreur

drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare msg varchar(50) default "";
    begin
		-- gestionnaire d'erreur en cas de doublons
		declare exit handler for 1062 set msg = "erreur de doublons";
       	declare exit handler for 1048 set msg = "erreur de null";
		insert into test (nom) values (v_name);
    end;
    if msg!="" then
		select(msg);
    end if;
end$$
delimiter ;


#utilisation de l'interception de toutes les erreurs avec sqlexception
#capture des message et des numero de l'erreur

drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare flag boolean default true;
    declare v_sqlstate varchar(5);
    declare v_errno int;
    declare v_text varchar(200);
    begin
		declare exit handler for sqlexception 
        begin
          GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, 
            v_errno = MYSQL_ERRNO, v_text = MESSAGE_TEXT;
			set flag = false;
        end;
		insert into test (nom) values (v_name);
    end;
    if flag=false then
		select concat(v_text,' ', v_errno, ' ' , v_sqlstate);
    end if;
end$$
delimiter ;


#erreur de type not found

drop procedure if exists get_id_by_name;
delimiter $$
create procedure get_id_by_name(in v_name varchar(50), out v_id int)
begin
	declare flag boolean default true;
    set v_id = -1;
    begin
		declare exit handler for not found set flag = false;
		select id into v_id from test where nom = v_name;
    end;
    if flag=false then
		select("introuvable");
    end if;
end$$
delimiter ;


#gestion des erreur du meme état sql sqlstate

drop procedure if exists insert_test;
delimiter $$
create procedure insert_test( v_name varchar(50))
begin
	declare flag boolean default true;
    begin
		declare exit handler for sqlstate '23000' set flag = false;
		insert into test (nom) values (v_name);
    end;
    if flag=false then
		select("erreur d'insertion");
    end if;
end$$
delimiter ;

