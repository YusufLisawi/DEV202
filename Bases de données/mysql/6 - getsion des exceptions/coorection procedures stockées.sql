use notes;
drop table if exists produit;
create table produit (id int auto_increment primary key,
libelle varchar(50),
pu float,
stock int);

insert into produit values (1,'thé',25,20);

select * from produit;
drop procedure if exists vendre;
delimiter $$
create procedure vendre(num int,qte int)
begin
declare s int;
select stock into s from produit where id = num;
if s<qte then
	select concat("opération impossible vous n'avez que " , s , " unités en stock");
else
	update produit set stock = stock-qte where id = num;
	if s-qte<10 then
		select concat(" besoin de réaprovionnement, votre nouveau stock est ", s-qte);
    else
		select concat(" opération effectuée avec succés, votre nouveau stock est ", s-qte);
    end if;

end if;
end$$

delimiter ;
use notes;
call vendre(1,12);
select * from produit;



drop procedure if exists prix_moyen;
delimiter $$
create procedure prix_moyen(out avg_price int)
begin
	select avg(pu) into avg_price from produit;
end$$
delimiter ;


call prix_moyen(@v);
select @v;




drop procedure if exists calculatrice;
delimiter $$
create procedure calculatrice(a int, b int, c varchar(1), out r varchar(50))
begin
case c
	when "+" then set r = a+b;
	when "-" then set r = a-b;
	when "*" then set r = a*b;
	when "/" then 
    begin
		if b=0 then
         signal  SQLSTATE '23000' SET MESSAGE_TEXT = 'impossible de diviser par zero';
        end if;
		set r = a/b;
    end;
else
	set r="operateur incorrect";

end case;
end$$
delimiter ;

call calculatrice (3,0,"/",@r);
select @r;

create database cuisine;
use cuisine;
create table Recettes (
NumRec int auto_increment primary key, 
NomRec varchar(50), 
MethodePreparation varchar(60), 
TempsPreparation int
);
create table Fournisseur (
NumFou int auto_increment primary key, 
RSFou varchar(50), 
AdrFou varchar(100)
);
create table Ingrédients (
NumIng int auto_increment primary key,
NomIng varchar(50), 
PUIng float, 
UniteMesureIng varchar(20), 
NumFou int,
   constraint  fkIngrédientsFournisseur foreign key (NumFou) references Fournisseur(NumFou)
);
create table Composition_Recette (
NumRec int not null,
constraint  fkCompo_RecetteRecette foreign key (NumRec) references Recettes(NumRec), 
NumIng int not null ,
  constraint  fkCompo_RecetteIngrédients foreign key (NumIng) references Ingrédients(NumIng),
QteUtilisee int,
constraint  pkRecetteIngrédients primary key (NumIng,NumRec)
);

insert into Recettes  values(1,'gateau','melageprotides' ,30),
							(2,'pizza ','melageglucides' ,15),
							(3,'couscous','melagelipides' ,45);
insert into Fournisseur  values (1,'meditel','fes'),
								(2,'maroc telecom','casa'),
								(3,'inwi','taza');
insert into Ingrédients values(1,'Tomate', 100,'cl',1),
								(2,'ail', 200,'gr',2),
								(3,'oignon', 300,'verre',3);
							
insert into Composition_Recette values (1,3,5);
insert into Composition_Recette values (1,1,2);
insert into Composition_Recette values (2,1,10);

-- PS2 : Qui affiche pour chaque recette le nombre d'ingrédients et le montant cette recette
drop procedure if exists ps2;
delimiter $$
create procedure ps2()
begin
select   r.NomRec,count(c.NumIng) as nb, sum(QteUtilisee*PUIng) as cout
from Recettes r left join Composition_Recette c  on r.numrec = c.numrec
 inner join Ingrédients i on i.NumIng = c.NumIng
group by nomrec;
end$$
delimiter ;

call ps2();

PS3 : Qui affiche la liste des recettes qui se composent de plus de 10 ingrédients avec pour chaque recette le numéro et le nom
PS4 : Qui reçoit un numéro de recette et qui retourne son nom
PS5 : Qui reçoit un numéro de recette. Si cette recette a au moins un ingrédient, la procédure retourne son meilleur ingrédient (celui qui a le montant le plus bas) sinon elle ne retourne "Aucun ingrédient associé"
PS6 : Qui reçoit un numéro de recette et qui affiche la liste des ingrédients correspondant à cette recette avec pour chaque ingrédient le nom, la quantité utilisée et le montant
PS7 : Qui reçoit un numéro de recette et qui affiche :
Son nom (Procédure PS_4)
La liste des ingrédients (procédure PS_6)
Son meilleur ingrédient (PS_5)
PS8 : Qui reçoit un numéro de fournisseur vérifie si ce fournisseur existe. Si ce n'est pas le cas afficher le message 'Aucun fournisseur ne porte ce numéro' Sinon vérifier, s'il existe des ingrédients fournis par ce fournisseur si c'est le cas afficher la liste des ingrédients associés (numéro et nom) Sinon afficher un message 'Ce fournisseur n'a aucun ingrédient associé. Il sera supprimé' et supprimer ce fournisseur
PS9 : Qui affiche pour chaque recette :
Un message sous la forme : "Recette : (Nom de la recette), temps de préparation : (Temps)
La liste des ingrédients avec pour chaque ingrédient le nom et la quantité
Un message sous la forme : Sa méthode de préparation est : (Méthode)
Si le prix de reviens pour la recette est inférieur à 50 DH afficher le message
'Prix intéressant'




