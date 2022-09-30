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

#exemple equation premier degrès
#ax+b=0

#a=0 et b=0   x=R
#a=0 et b!=0   x=impossible
#a!=0  x=-b/a

drop function if exists eq1d;
delimiter $
create function eq1d(a int,b int)
returns varchar(50)
no sql  #deterministic
begin
    declare solution varchar(50);
    if (a=0 and b=0) then
		set solution = concat("la solution est toute valeur de l'ensemble R" );
	else
		if (a=0 and b!=0) then
			set solution = concat("la solution est impossible" );
       else
			set solution = concat("la solution est x=" , round(-b/a,2));
        end if;
	end if;
    return(solution);
end $
delimiter ;




drop function if exists eq1d;
delimiter $
create function eq1d(a int,b int)
returns varchar(50)
no sql  #deterministic
begin
    declare solution varchar(50);
   
	if a=0 then
		if b=0 then
			set solution = concat("la solution est toute valeur de l'ensemble R" );
	    else
			set solution = concat("la solution est impossible" );
		end if;
	else
		set solution = concat("la solution est x=" , round(-b/a,2));
	end if;
    return(solution);
end $
delimiter ;

select eq1d(1,0) addition;

#equation 2ème degrès
# ax²+bx+c=0
# a=0 b=0 c=0   => R
# a=0 b=0 c!=0  => impossible
# a=0 b!=0 => x=-c/b
# a!=0
#	delta = b²-4ac
#    delta<0 => impossible
#    delta=0 => x1=x2=-b/2a
#    delta>0  x1=-b-racine(delta)/2a  x2=-b+racine(delta)/2a


drop function if exists eq2d;
delimiter $
create function eq2d(a int, b int, c int )
returns varchar(50)
deterministic
begin
	declare result varchar(50);
    declare delta float ;
    
    if a=0 then
		if b=0 then
			if c=0 then
               set result="R";
            else
                set result="impossible";
            end if;
        else
           set result = concat("x=",round(-c/b,2));
        end if;
    else
      #delta
		set delta =  (b*b)-(4*a*c);
		 case 
         when delta<0 then  
				set result = "impossible dans R";
         when delta=0 then 
				set result = concat("x1=x2=",round(-b/(2*a),2));
         else 
				set result = concat("x1=",round(-b+sqrt(delta)/(2*a),2),"    x2=",round(-b-sqrt(delta)/(2*a),2));
         end case;
    end if;
    
	return result;
end $
delimiter ;

select eq2d(2,6,2);








		#case
    
    
drop function if exists get_mention;
delimiter $
create function get_mention(note float)
returns varchar(20)
no sql
deterministic
begin
	declare mention varchar(20);
	case
		when note>18 then set mention="excellent";
		when note>14 then set mention="très bien";
		when note>12 then set mention="bien";
		when note>10 then set mention="passable";
        
		when note>8 then set mention="faible";
     	when note>5 then set mention="insuffisant";       
		else	set mention="très insuffisant";
   end case;
    return mention;
 end $
select get_mention(3.5);

#case variable when


drop function if exists get_day_of_week;
delimiter $
create function get_day_of_week(day int)
returns varchar(10)
no sql
deterministic
begin
	declare name_of_day varchar(20);
	case day
		when 1 then set name_of_day="Dimanche";
		when 2 then set name_of_day="Lundi";
		when 3 then set name_of_day="Mardi";
		when 4 then set name_of_day="Mercredi";
		when 5 then set name_of_day="Jeudi";
     	when 6 then set name_of_day="Vendredi";       
     	when 7 then set name_of_day="Samedi";   
		else	set name_of_day="Erreur";
   end case;
    return name_of_day;
 end $
delimiter ;
select get_day_of_week(2);

        
	#les boucles
		#while
use notes;

drop function if exists somme;
delimiter $$
create function somme (n int)
returns bigint
deterministic
#no sql
#reads sql data
begin
	declare s int default 0;
    declare i int default 1;
    while i<=n do
		set s = s+i;
        set i=i+1; 
    end while;
	return s;
end$$
delimiter ;

  select somme(4) as somme;      
        
		#repeat ... until

drop function if exists somme;
delimiter $$
create function somme (n int)
returns bigint
deterministic
#no sql
#reads sql data
begin
	declare s int default 0;
    declare i int default 1;
    repeat
		set s = s+i;
        set i=i+1; 
    until i>n end repeat ;
	return s;
end$$
delimiter ;

  select somme(4) as somme;      

	
        
        #loop


drop function if exists somme;
delimiter $$
create function somme (n int)
returns bigint
deterministic
#no sql
#reads sql data
begin
	declare s int default 0;
    declare i int default 1;
    label1: loop
		set s = s+i;
        set i=i+1; 
        if i<=n then
			iterate label1   ;
        end if;
        leave label1;
    end loop label1;
	return s;
end$$
delimiter ;

select somme(5) as somme;      










#les fonctions

#les procedures
