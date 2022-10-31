insert into ville (libelle) values 
('tetouan'), 
('martil'),
('m''diq'),
('tanger'),
('fnidaq');

insert into quartier (libelle,ville_id) values 
('touilaa',1), 
('saniat rmel',1),
('Wilaya',1),
('safir',1),
('boujarah',1);


insert into type_bien (libelle) values 
('appartement'), 
('villa'),
('garage'),
('maison'),
('studio');


insert into client(cin, nom,prenom, telephone, adresse) values
('L1','marchoud','ali','06875421','avenue 10 mai numero 3'),
('L2','benhsain','hassan','06215487','avenue ibn sina numero 4'),
('L3','kamil','ahmed','07215487','avenue mokawama numero 5'),
('L4','youssfi','mohamed','08542154','avenue benouna numero 7'),
('L5','ghali','adil','0624587','avenue je sais pas numero 2');


INSERT INTO `bien`(`reference`, `superficie`, `nb_pieces`, `adresse`, `loyer`, `type_bien_id`, `client_cin`, `quartier_id`) VALUES 
('1',80,3,'adr1',2500,1,'L1',1),
('2',70,3,'adr1',2500,1,'L2',2),
('3',80,3,'adr1',1500,1,'L1',1),
('4',85,3,'adr1',2500,1,'L3',3),
('5',90,3,'adr1',2500,1,'L4',1);

INSERT INTO `contrat`(`bien_reference`, `client_cin`, `date_creation`, `date_entree`, `date_sortie`, `loyer`, `charges`) VALUES 
('1','L1','2022/09/01','2022/09/01','2023/09/01',2500,200),
('2','L2','2022/08/01','2022/09/01',null,3500,200),
('3','L3','2022/07/01','2022/09/01','2022/10/01',3000,300),
('4','L4','2022/06/01','2022/06/01','2022/07/01',1500,150),
('5','L5','2022/05/01','2022/05/01',null,2400,100);



