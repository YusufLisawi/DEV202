use cuisine;

select * from ingrédients;

update ingrédients set PUIng = 2;


drop procedure if exists ps9;
delimiter $$
create procedure ps9()
begin
	declare v_numrec int;
    declare v_nomrec varchar(50);
    declare v_methode varchar(50);
    declare v_temps int;
    declare v_prix float;
    declare flag boolean default true;
	declare c1 cursor for
		select numrec, nomrec, methodepreparation, tempspreparation from recettes;
    declare continue handler for not found set flag = false;    
	open c1;
    b1: loop
		fetch c1 into v_numrec ,v_nomrec , v_methode ,v_temps;
		if flag = false then
			leave b1;
        end if;
     select concat("Recette : (",v_nomrec,"), temps de préparation : ",v_temps);
     select NomIng,QteUtilisee 
		from  Ingrédients i inner join  Composition_Recette rc on i.numing = rc.numing
		where rc.numrec = v_numrec;
     select concat("Sa méthode de préparation est : (",v_methode,")");
	 
       select sum(PUIng * QteUtilisee ) into v_prix
		from  Ingrédients i inner join  Composition_Recette rc on i.numing = rc.numing
		where rc.numrec = v_numrec;
        if v_prix < 50 then
                select ("prix interessant");
        end if;
            
    end loop b1;
    close c1;
end$$
delimiter ;

call ps9();
