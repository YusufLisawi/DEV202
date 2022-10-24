create user 'u1'@'localhost' identified by '1234567';
create user 'u2'@'localhost' identified by '1234567';
create user 'u3'@'localhost' identified by '1234567';


CREATE ROLE lecture@localhost;
CREATE ROLE edition@localhost;


grant select on ecole.* to lecture@localhost;
grant select,update, delete, insert on ecole.* to edition@localhost;


grant lecture@localhost to 'u1'@'localhost';
grant edition@localhost to 'u1'@'localhost';

grant lecture@localhost to 'u2'@'localhost';

grant edition@localhost to 'u3'@'localhost';


SET DEFAULT ROLE  ALL TO u1@localhost;
SET DEFAULT ROLE  ALL TO u2@localhost;
SET DEFAULT ROLE  ALL TO u3@localhost;

show grants 
for u1@localhost
using edition@localhost, lecture@localhost;
