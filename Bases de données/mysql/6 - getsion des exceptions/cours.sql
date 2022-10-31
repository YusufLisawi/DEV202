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


#appel d'une procedure en cas d'erreur
drop procedure if exists ps_err;
DELIMITER $$
CREATE PROCEDURE ps_err ()
BEGIN
	SELECT 'Une autre erreur est survenue' ;
END$$
DELIMITER ;

drop procedure if exists select_test;
delimiter $$
create procedure select_test(v_name varchar(50))
begin 
	declare var1 varchar(50);
    declare exit handler for  sqlexception call ps_err();
    INSERT INTO table_inexistante VALUES (1);
end$$
delimiter ;

call select_test("ismo");



drop procedure if exists select_test;
delimiter $$
create procedure select_test(v_name varchar(50))
begin 
	declare var1 varchar(50);
    declare sortie boolean default  true; 
    declare exit handler for  sqlexception call ps_err();
    begin
		declare exit handler for  not found set sortie=false;
        INSERT INTO table_inexistante VALUES (1);
		select nom into var1 from test where nom like v_name;
			select var1;
	end;
    if sortie=false then
		select "nom introuvable" as err;
    end if;	
 
end$$
delimiter ;

call select_test("ismo");




#execution de plusieurs lignes en cas d'erreur en cas d'erreur

drop procedure if exists select_test;
delimiter $$
create procedure select_test(v_name varchar(50))
begin 
	declare var1 varchar(50);
    declare sortie boolean default  true; 
    declare exit handler for  sqlexception 
						BEGIN
							SELECT 'Une autre erreur est survenue' ;
							SELECT 'blabla' ;
						END;
    begin
		declare exit handler for  not found set sortie=false;
        INSERT INTO table_inexistante VALUES (1);
		select nom into var1 from test where nom like v_name;
			select var1;
	end;
    if sortie=false then
		select "nom introuvable" as err;
    end if;	
 
end$$
delimiter ;

call select_test("wana");

#gestion des erreurs sql state out of memry HY000


drop procedure if exists conversion_test;
delimiter $$
create procedure conversion_test()
begin 
	declare nb int;
    declare sortie boolean default  true; 
     begin
		declare exit handler for sqlstate 'HY000' set sortie=false;
		set nb ="test";
        select nb;
	end;
    if sortie=false then
		select "erreur de conversion" as err;
    end if;	
 
end$$
delimiter ;

call conversion_test();



#gestion des erreurs sql state duplicate key


drop procedure if exists insert_duplicate_test;
delimiter $$
create procedure insert_duplicate_test()
begin 
    declare sortie boolean default  true; 
     begin
		declare exit handler for sqlstate '23000' set sortie=false;
		insert into test (id, nom) values (1,'test');
	end;
    if sortie=false then
		select "erreur d'insertion de duplication" as err;
    end if;	
 
end$$
delimiter ;

call insert_duplicate_test();



#gestion des erreurs sql state duplicate key utilisation de continue
select * from test

drop procedure if exists insert_duplicate_test;
delimiter $$
create procedure insert_duplicate_test()
begin 
    declare sortie boolean default  true; 
     begin
		declare continue handler for sqlstate'23000' set sortie=false;
		insert into test (id, nom) values (4,'test1');
        insert into test (id, nom) values (16,'test4');
        insert into test (id, nom) values (14,'test3');
	end;
    if sortie=false then
		select "erreur d'insertion de duplication" as err;
    end if;	
 
end$$
delimiter ;

call insert_duplicate_test();



#donner le nom a une exception


drop procedure if exists insert_duplicate_test;
delimiter $$
create procedure insert_duplicate_test()
begin 
    declare sortie boolean default  true; 
     begin
        DECLARE nom_exception CONDITION FOR SQLSTATE VALUE '23000';
    	declare continue handler for nom_exception set sortie=false;
		insert into test (id, nom) values (1,'test1');
        insert into test (id, nom) values (2,'test2');
        insert into test (id, nom) values (3,'test3');
        insert into test (id, nom) values (4,'test4');
	end;
    if sortie=false then
		select "erreur d'insertion de duplication" as err;
    end if;	
 
end$$
delimiter ;

call insert_duplicate_test();

#utilisation de SIGNAL

drop procedure if exists division;
delimiter $$
create procedure division(a int, b int)
begin 
  if b=0 then
		signal SQLSTATE '23000' SET MESSAGE_TEXT = 'impossible de divisé par zero';
   end if;
   select a/b;
end$$
delimiter ;
call division (2,0)

drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_id int, v_name varchar(50))
begin 
   if v_id=0 then
		signal SQLSTATE '23000' SET MESSAGE_TEXT = 'id non autorisé';
   end if;
	
end$$
delimiter ;

call insert_test(0,'a');

select 5/0;

#utilisation de resignal
drop procedure if exists divide;
DELIMITER $$
CREATE PROCEDURE Divide(IN numerator INT,	IN denominator INT,	OUT result double)
BEGIN
	DECLARE division_by_zero CONDITION FOR SQLSTATE '22012' ;
	DECLARE CONTINUE HANDLER FOR division_by_zero
	RESIGNAL SET MESSAGE_TEXT = 'Division by zero / Denominator cannot bezero';
	IF denominator = 0 THEN
		SIGNAL division_by_zero;
	ELSE
		SET result = numerator / denominator;
	END IF ;
END$$
delimiter ;

call Divide(5,0,@r);
select @r;

#La gestion des transactions

drop table  if exists bankaccounts;


CREATE TABLE bankaccounts(accountno varchar(20) PRIMARY KEY NOT NULL, funds decimal(8,2), check (funds>=0));

INSERT INTO bankaccounts VALUES("ACC1", 1000);
INSERT INTO bankaccounts VALUES("ACC2", 1000);

UPDATE bankaccounts SET funds=funds+200 WHERE accountno="acc1"; 
UPDATE bankaccounts SET funds=funds-200 WHERE accountno="acc2"; 


select * from bankaccounts


DROP PROCEDURE IF EXISTS virement;
delimiter $$
CREATE PROCEDURE virement(acc1 varchar(10), acc2 varchar(10), amount float)
BEGIN
   DECLARE exit handler for SQLEXCEPTION
   BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
            @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
      --  set autocommit=1;
        SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
        SELECT @full_error;
   END;
-- set autocommit=0;
start transaction ;     
UPDATE bankaccounts SET funds=funds+amount WHERE accountno=acc2; 
UPDATE bankaccounts SET funds=funds-amount WHERE accountno=acc1; 
commit; 
-- set autocommit=1;
end$$
delimiter ;

call virement('acc1','acc2',300);

SHOW VARIABLES LIKE 'AUTOCOMMIT';
