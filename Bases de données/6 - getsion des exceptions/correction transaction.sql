use notes;
drop table if exists Transfert;

drop table if exists salle;

create table Salle (NumSalle int auto_increment primary key, 
Etage int , 
NombreChaises int,
 check (NombreChaises between 20 and 30));
 
create table Transfert (
id int auto_increment primary key,
NumSalleOrigine int,
foreign key ( NumSalleOrigine) references salle(NumSalle),
 NumSalleDestination int , 
 foreign key ( NumSalleDestination) references salle(NumSalle),
 DateTransfert date ,
 NbChaisesTransférées int);
 
 insert into salle values (1,1,24), (2,1,26), (3,1,26), (4,2,28);
 
 
 drop procedure if exists transfert_chaises;
 delimiter $$
 create procedure transfert_chaises(so int ,sd int ,nc int)
 begin
	 declare exit handler for sqlexception  
		 begin
			select("le transfert est impossible");
			rollback;
		 end;
	 start transaction;
		update salle set NombreChaises=NombreChaises-nc where NumSalle = so;
		update salle set NombreChaises=NombreChaises+nc where NumSalle = sd;
		insert into transfert (NumSalleOrigine,NumSalleDestination,DateTransfert,NbChaisesTransférées) values (so,sd,current_date,nc);
	 commit;
end$$
 delimiter ;
 
 
 call transfert_chaises (3,4,3);
 select * from salle;
 select * from transfert ;
 
