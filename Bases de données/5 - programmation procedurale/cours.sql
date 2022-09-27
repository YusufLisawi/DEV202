use notes;
#Programmation procedurale sous mysql

#la notion des blocks
/*
block nom (paramétres)
...
begin
		#instructions;
		block
        begin
			#instructions;
        
        end;

end;
*/

#exemple d'un bloc
#fonction hello
drop function if exists hello;
delimiter $
create function hello()
returns varchar(50)
no sql
deterministic
begin
	return('hello world');
end $
delimiter ;

select hello() salutation;

#exemple somme

drop function if exists somme;
delimiter $
create function somme(a int,b int)
returns int
no sql  #deterministic
begin
	return(a+b);
end $
delimiter ;

select somme(3,5) addition;

#un block de procedure stockée
#hello
drop procedure if exists ps_hello;
delimiter $
create procedure ps_hello()
begin
	select 'hello world' as salutation;
end $
delimiter ;

call ps_hello;

#procedure sommme
drop procedure if exists ps_somme;
delimiter $
create procedure ps_somme(in a int, in b int)
begin
	select a+b as addition;
end $
delimiter ;

call ps_somme(3,4);

#les instructions de controle
	#la declaration
    
drop function if exists somme;
delimiter $
create function somme(a int,b int)
returns int
no sql  #deterministic
begin
	declare c int default a+b;
	return(c);
end $
delimiter ;

select somme(3,5) addition;
    
    
    
	#l'affectation
    
   #affectation avec set     
drop function if exists somme;
delimiter $
create function somme(a int,b int)
returns int
no sql  #deterministic
begin
	declare c int;
    set c := a+b; # ou c = a+b;
	return(c);
end $
delimiter ;

select somme(3,5) addition;
  
        #affectation avec select ... into
drop function if exists somme;
delimiter $
create function somme(a int,b int)
returns int
no sql  #deterministic
begin
	declare c int;
    select a+b into c;
	return(c);
end $
delimiter ;

select somme(3,5) addition;
  
	#les conditions
		#if
#get  phone type

drop function if exists get_phone_type;
delimiter $
create function get_phone_type(phone varchar(20))
returns varchar(20)
no sql
begin
	declare t varchar(20) default "fixe";
    if left(phone,2) in ("06","07") then
		set t= "gsm" ;
    end if;
    return t;
end $
delimiter ;

select get_phone_type("0621548754");


drop function if exists get_phone_type;
delimiter $
create function get_phone_type(phone varchar(20))
returns varchar(20)
no sql
begin
	declare t varchar(20);
    if phone like "06%" or phone like "07%" then
		set t= "gsm" ;
    else
        set t="fixe";
    end if;
    return t;
end $
delimiter ;

select get_phone_type("0521548754");



drop function if exists get_phone_type;
delimiter $
create function get_phone_type(phone varchar(20))
returns varchar(20)
no sql
begin
	declare t varchar(20);
    if left(phone,2) in ("06","07") then
		set t= "gsm" ;
	elseif left(phone,2) ="05" then
		set t="fixe";
    else
        set t="erreur";
    end if;
    return t;
end $
delimiter ;

select get_phone_type("0321548754");


		#case
	#les boucles
		#while
		#repeat ... until
		#loop

#les fonctions

#les procedures
