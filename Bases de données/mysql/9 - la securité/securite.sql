create user 'youssef'@'localhost' identified by '1234567';

drop user 'youssef'@'localhost' ;



grant all privileges on ecole.* to 'youssef'@'localhost';


revoke all privileges on ecole.* from 'youssef'@'localhost';


grant all privileges on ecole.transfert to 'youssef'@'localhost';


revoke all privileges on ecole.transfert from 'youssef'@'localhost';
grant select on ecole.transfert to 'youssef'@'localhost';

grant select on ecole.salle to youssef@localhost;
grant insert on ecole.salle to youssef@localhost;
grant select, insert,delete, update on ecole.transfert to 'youssef'@'localhost';


show grants for 'youssef'@'localhost';
revoke select on ecole.salle from youssef@localhost;
revoke insert  on ecole.salle from youssef@localhost;
grant select  (etage) on ecole.salle to 'youssef'@'localhost';

flush privileges;






