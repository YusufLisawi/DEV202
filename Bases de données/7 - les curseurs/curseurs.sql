use vols2018;
select * from vol;
delete from vol;

select * from pilote;
set sql_safe_updates = 0;

declare
open


fetch

close


drop procedure if exists insert_vols;
delimiter $$
create procedure insert_vols(v_ville varchar(50), v_avion int)
begin
	declare v_numpil int;
    declare v_villepil varchar(50);
    declare flag boolean default true;
	declare c1 cursor for
		select numpilote, villepilote from pilote;
    declare continue handler for not found set flag = false;    
	open c1;
    b1: loop
		fetch c1 into v_numpil, v_villepil;
		if flag = false then
			leave b1;
        end if;
        
        insert into vol (villed, villea, dated, datea, numpil,numav) 
			values(v_villepil,v_ville,current_date,current_date,v_numpil, v_avion);
            
            
    end loop b1;
    close c1;
end$$
delimiter ;

call insert_vols('casablanca',1);







drop procedure if exists get_pilotes_names;
delimiter $$
create procedure get_pilotes_names(inout v_names varchar(255))
begin
	declare v_name varchar(50);
    declare flag boolean default true;
  
	declare c1 cursor for 
		select nom from pilote;
	declare continue handler for not found set flag = false;
	#set v_names = "";
	open c1;
    b1: loop
		fetch c1 into v_name;
        if not flag then
			leave b1;
        end if;
		set v_names = concat(v_name, ";",v_names);
    end loop b1;
    close c1;
end$$
delimiter ;
set @a="";
call get_pilotes_names(@a);
select @a;










