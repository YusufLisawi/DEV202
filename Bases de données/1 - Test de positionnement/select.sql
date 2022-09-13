#A.	La liste des bien de type ‘villa’

#Méthode1
select * from bien b inner join type_bien t on b.type_bien_id = t.id
where t.libelle = 'appartement';

#méthode2
select *
from bien 
where type_bien_id in 
            (select id 
             from type_bien 
             where libelle = 'appartement'
            );
#B.	La liste des appartements qui se trouvent à Tétouan
#methode 1
select  b.* 
from bien b inner join type_bien t on b.type_bien_id=t.id 
inner join quartier q on q.id=b.quartier_id 
inner join ville v on q.ville_id=v.id
where t.libelle ='appartement'and v.libelle='tetouan';
#methode 2
select * from bien
where quartier_id in (select id from quartier where ville_id in (select id from ville where libelle = 'tetouan'))
and type_bien_id in (select id from type_bien where libelle = 'appartement');


#C.	La liste des appartements loués par M. Marchoud Ali
select * from bien
where type_bien_id in (select id from type_bien where libelle = 'appartement')
and reference in (
	select bien_reference from contrat where client_cin in (
		select cin from client where nom like 'Marchoud' and prenom like 'ali')
	)
;

#D.	Le nombre des appartements loués dans le mois en cours

Select count(*) AS nb_appartement FROM contrat c
	JOIN bien b ON b.reference = c.bien_reference
    JOIN type_bien t ON t.id = b.type_bien_id
	where t.libelle = 'appartement' 
    AND month(c.date_CREATION) = month(current_date) and year(c.date_creation) = year(current_date())
    ;



#E.	Les appartements disponibles actuellement 
# à Martil dont
#le loyer est inférieur à 2000 DH 
# triés du mois chère au plus chère

select * from bien 
where reference not in(
				select bien_reference
				from contrat
				where date_entree <= current_date and (date_sortie is null or date_sortie >= current_date)
				)
and  quartier_id in (select id from quartier where ville_id in (select id from ville where libelle = 'martil'))
and type_bien_id in (select id from type_bien where libelle = 'appartement')
and loyer <2000
order by loyer asc;


#F.	La liste des biens qui n’ont jamais été loués
select * from bien where reference not in (
							select bien_reference from contrat
						);
#G.	La somme des loyers du mois en cours

select sum(loyer)
from contrat
where date_entree <= current_date and (date_sortie is null or date_sortie >= current_date)
			
            


