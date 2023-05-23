DROP SCHEMA IF EXISTS S3_APP2 CASCADE;
CREATE SCHEMA S3_APP2;
SET search_path = S3_APP2, pg_catalog;

CREATE TABLE CAMPUS
(
    Camp_id VARCHAR(16) NOT NULL,
    Camp_nom VARCHAR(128) NOT NULL,
    PRIMARY KEY (Camp_id)
);

CREATE TABLE PAVILLON
(
    Pav_id VARCHAR(16) NOT NULL,
    Pav_nom VARCHAR(128) NOT NULL,
    Camp_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Pav_id),
    FOREIGN KEY (Camp_id) REFERENCES CAMPUS(Camp_id)
);

CREATE TABLE CARACTERISTIQUE
(
    Carac_id VARCHAR(16) NOT NULL,
    Carac_nom VARCHAR(128) NOT NULL,
    PRIMARY KEY (Carac_id)
);

CREATE TABLE FONCTION
(
    Fonc_id VARCHAR(16) NOT NULL,
    Fonc_nom VARCHAR(128) NOT NULL,
    PRIMARY KEY (Fonc_id)
);

CREATE TABLE DEPARTEMENT
(
    Dep_nom VARCHAR(128) NOT NULL,
    Dep_id VARCHAR(16) NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Dep_id),
    FOREIGN KEY (Pav_id) REFERENCES PAVILLON(Pav_id)
);

CREATE TABLE LOCAL
(
    Local_num INT NOT NULL,
    Capacite INT NOT NULL,
    Notes VARCHAR(1024),
    Pav_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Local_num, Pav_id),
    FOREIGN KEY (Pav_id) REFERENCES PAVILLON(Pav_id)
);

CREATE TABLE MEMBRE
(
    Cip VARCHAR(8) NOT NULL,
    Prenom VARCHAR(32) NOT NULL,
    Nom VARCHAR(32) NOT NULL,
    Dep_id VARCHAR(16) NOT NULL,
    --Log_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Cip),
    FOREIGN KEY (Dep_id) REFERENCES DEPARTEMENT(Dep_id)
    --FOREIGN KEY (Log_id) REFERENCES LOGBOOK(Log_id)
);

CREATE TABLE LOGBOOK
(
    Date DATE NOT NULL,
    Log_id VARCHAR(16) NOT NULL,
    Heure TIME NOT NULL,
    Local_num INT NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Log_id),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id) ON DELETE CASCADE
);

CREATE TABLE RESERVATION
(
    Heure_debut TIME NOT NULL,
    Heure_fin TIME NOT NULL,
    _Nb_places INT NOT NULL,
    Reserve_id VARCHAR(16) NOT NULL,
    Date DATE NOT NULL,
    Description VARCHAR(1024),
    Cip VARCHAR(8) NOT NULL,
    Local_num INT NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    --Log_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Reserve_id),
    FOREIGN KEY (Cip) REFERENCES MEMBRE(Cip),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id)
    --FOREIGN KEY (Log_id) REFERENCES LOGBOOK(Log_id)
);

CREATE TABLE STATUT
(
    Statut_id INT NOT NULL,
    Statut_nom VARCHAR(128) NOT NULL,
    --Cip VARCHAR(8) NOT NULL,
    PRIMARY KEY (Statut_id)
    --FOREIGN KEY (Cip) REFERENCES MEMBRE(Cip)
);

CREATE TABLE STATUTMEMBRE
(
    Statut_id INT NOT NULL,
    Cip VARCHAR(8) NOT NULL,
    PRIMARY KEY (Statut_id, Cip),
    FOREIGN KEY (Statut_id) REFERENCES Statut(Statut_id),
    FOREIGN KEY (Cip) REFERENCES Membre(Cip)
);

CREATE TABLE CUBICULE
(
    Num_cubicule INT NOT NULL,
    Local_num INT NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Num_cubicule, Local_num, Pav_id),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id)
);

CREATE TABLE LOCALFONCTION
(
    Local_num INT NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    Fonc_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Local_num, Pav_id, Fonc_id),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id),
    FOREIGN KEY (Fonc_id) REFERENCES FONCTION(Fonc_id)
);

CREATE TABLE LOCALCARACTERISTIQUE
(
    Local_num INT NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    Carac_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Local_num, Pav_id, Carac_id),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id),
    FOREIGN KEY (Carac_id) REFERENCES CARACTERISTIQUE(Carac_id)
);

CREATE TABLE STATUT_Privileges
(
    Privileges VARCHAR(1024) NOT NULL,
    Statut_id INT NOT NULL,
    PRIMARY KEY (Privileges, Statut_id),
    FOREIGN KEY (Statut_id) REFERENCES STATUT(Statut_id)
);

ALTER TABLE LOGBOOK
    ADD CONSTRAINT log_id_reservation_fkey
        FOREIGN KEY (Local_num, Pav_id)
            REFERENCES LOCAL (Local_num, Pav_id)
            ON DELETE CASCADE;

INSERT INTO CAMPUS VALUES (1, 'Campus Principal');
INSERT INTO CAMPUS VALUES (2, 'Campus Medecine');
INSERT INTO CAMPUS VALUES (3, 'Campus Longueur');

INSERT INTO PAVILLON VALUES('C1', 'J Armand Bombardier',1);
INSERT INTO PAVILLON VALUES('C2', 'J.-Armand-Bombardier',1);
INSERT INTO PAVILLON VALUES('D7', 'Centre universitaire de formation en environnement et developpement durable',1);

INSERT INTO CARACTERISTIQUE VALUES (0, 'Connexion à Internet');
INSERT INTO CARACTERISTIQUE VALUES (1, 'Tables fixes en U et chaises mobiles');
INSERT INTO CARACTERISTIQUE VALUES (2, 'Monoplaces');
INSERT INTO CARACTERISTIQUE VALUES (3, 'Tables fixes et chaises fixes');
INSERT INTO CARACTERISTIQUE VALUES (6, 'Tables pour 2 ou + et chaises mobiles');
INSERT INTO CARACTERISTIQUE VALUES (7, 'Tables mobiles et chaises mobiles');
INSERT INTO CARACTERISTIQUE VALUES (8, 'Tables hautes et chaises hautes');
INSERT INTO CARACTERISTIQUE VALUES (9, ' Tables fixes et chaises mobiles');
INSERT INTO CARACTERISTIQUE VALUES (11, ' Écran');
INSERT INTO CARACTERISTIQUE VALUES (14, 'Rétroprojecteur');
INSERT INTO CARACTERISTIQUE VALUES (15, 'Gradins');
INSERT INTO CARACTERISTIQUE VALUES (16, ' Fenêtres');
INSERT INTO CARACTERISTIQUE VALUES (17, ' 1 piano');
INSERT INTO CARACTERISTIQUE VALUES (18, ' 2 pianos');
INSERT INTO CARACTERISTIQUE VALUES (19, ' Autres instruments');

INSERT INTO FONCTION VALUES ('0110', 'Salle de classe generale');
INSERT INTO FONCTION VALUES ('0111', 'Salle de classe specialise');
INSERT INTO FONCTION VALUES ('0120', 'Salle de seminaire');
INSERT INTO FONCTION VALUES ('0121', 'Cubicules');
INSERT INTO FONCTION VALUES ('0210', 'Laboratoire informatique');
INSERT INTO FONCTION VALUES ('0211', 'Laboratoire d''enseignment specialise');
INSERT INTO FONCTION VALUES ('0212', 'Atelier');
INSERT INTO FONCTION VALUES ('0213', 'Salle a dessin');
INSERT INTO FONCTION VALUES ('0214', 'Atelier (civil)');
INSERT INTO FONCTION VALUES ('0215', 'Salle de musique');
INSERT INTO FONCTION VALUES ('0216', 'Atelier sur 2 etages, conjoint avec autre local');

INSERT INTO LOCAL VALUES (3014, 60, null,'C1');
INSERT INTO LOCAL VALUES (3016, 40, 'multimetre disponible','C1');
INSERT INTO LOCAL VALUES (3018, 40, 'multimetre disponible','C1');
INSERT INTO LOCAL VALUES (4020, 60, 'ordinateur disponible','C1');
INSERT INTO LOCAL VALUES (4014, 60, 'ordinateur disponible','C1');
INSERT INTO LOCAL VALUES (4018, 60, 'ordinateur disponible','C1');
INSERT INTO LOCAL VALUES (5001, 120, 'local immense','C1');
INSERT INTO LOCAL VALUES (2001, 30, 'labo genie batiment','C2');
INSERT INTO LOCAL VALUES (2003, 20, 'labo genie batiment','C2');
INSERT INTO LOCAL VALUES (2014, 20, 'labo genie batiment','C2');
INSERT INTO LOCAL VALUES (4001, 30, null,'D7');
INSERT INTO LOCAL VALUES (4020, 20, null,'D7');
INSERT INTO LOCAL VALUES (3020, 20, null,'D7');

INSERT INTO LOCALCARACTERISTIQUE VALUES (3016, 'C1', 0);
INSERT INTO LOCALCARACTERISTIQUE VALUES (3014, 'C1', 3);
INSERT INTO LOCALCARACTERISTIQUE VALUES (4001, 'D7', 7);

INSERT INTO LOCALFONCTION VALUES (3016, 'C1', '0111');
INSERT INTO LOCALFONCTION VALUES (3014, 'C1', '0212');
INSERT INTO LOCALFONCTION VALUES (4001, 'D7', '0216');

INSERT INTO DEPARTEMENT VALUES ('Genie electrique et Genie informatique', 'GEGI', 'C1');
INSERT INTO DEPARTEMENT VALUES ('Genie mecanique', 'GM', 'C1');
INSERT INTO DEPARTEMENT VALUES ('Genie chimique et biotechnologie', 'GChim', 'D7');
INSERT INTO DEPARTEMENT VALUES ('Genie civil et du batiment', 'GCiv', 'C2');

INSERT INTO MEMBRE VALUES ('ronk2602', 'Kevin', 'Rondeau', 'GEGI');
INSERT INTO MEMBRE VALUES ('ronm0401', 'Mark', 'Ronald', 'GCiv');
INSERT INTO MEMBRE VALUES ('smij0703', 'John', 'Smith', 'GChim');
INSERT INTO MEMBRE VALUES ('robw0110', 'William', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('wilc0817', 'Charles', 'Williams', 'GEGI');
INSERT INTO MEMBRE VALUES ('jamd0219', 'David', 'Jameson', 'GM');
INSERT INTO MEMBRE VALUES ('robj1208', 'John', 'Roberts', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakd0311', 'Daniel', 'Baker', 'GCiv');
INSERT INTO MEMBRE VALUES ('grem0215', 'Michael', 'Green', 'GEGI');
INSERT INTO MEMBRE VALUES ('ricj0412', 'James', 'Richardson', 'GChim');
INSERT INTO MEMBRE VALUES ('parl0109', 'Lisa', 'Parker', 'GEGI');
INSERT INTO MEMBRE VALUES ('wilk0121', 'Karen', 'Wilson', 'GM');
INSERT INTO MEMBRE VALUES ('morj0905', 'Jennifer', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('thom0114', 'Jessica', 'Thompson', 'GChim');
INSERT INTO MEMBRE VALUES ('hill0623', 'Robert', 'Hill', 'GEGI');
INSERT INTO MEMBRE VALUES ('broa0223', 'Andrew', 'Brooks', 'GEGI');
INSERT INTO MEMBRE VALUES ('powm0308', 'Matthew', 'Powell', 'GCiv');
INSERT INTO MEMBRE VALUES ('robg0125', 'George', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('patl0315', 'Elizabeth', 'Paterson', 'GEGI');
INSERT INTO MEMBRE VALUES ('johw0320', 'William', 'Johnson', 'GM');
INSERT INTO MEMBRE VALUES ('rinm0510', 'Michael', 'Riley', 'GEGI');
INSERT INTO MEMBRE VALUES ('whij0325', 'John', 'White', 'GChim');
INSERT INTO MEMBRE VALUES ('jamj1009', 'Jessica', 'James', 'GEGI');
INSERT INTO MEMBRE VALUES ('hill0901', 'Daniel', 'Hill', 'GCiv');
INSERT INTO MEMBRE VALUES ('robj1122', 'James', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakj0420', 'Jennifer', 'Baker', 'GEGI');
INSERT INTO MEMBRE VALUES ('walr0626', 'Richard', 'Walker', 'GM');
INSERT INTO MEMBRE VALUES ('morj0323', 'Jonathan', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('taym0404', 'Michael', 'Taylor', 'GChim');
INSERT INTO MEMBRE VALUES ('whij0823', 'Jessica', 'White', 'GEGI');
INSERT INTO MEMBRE VALUES ('harm0228', 'Melissa', 'Harper', 'GEGI');
INSERT INTO MEMBRE VALUES ('carm0716', 'Steven', 'Carson', 'GCiv');
INSERT INTO MEMBRE VALUES ('robk0521', 'Kenneth', 'Roberts', 'GEGI');
INSERT INTO MEMBRE VALUES ('wilj1125', 'Jennifer', 'Williams', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakd0507', 'David', 'Baker', 'GM');
INSERT INTO MEMBRE VALUES ('morj0929', 'Joseph', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('parl0103', 'Thomas', 'Parker', 'GChim');
INSERT INTO MEMBRE VALUES ('thom0815', 'Emily', 'Thomas', 'GEGI');
INSERT INTO MEMBRE VALUES ('harr0629', 'Ryan', 'Harris', 'GCiv');
INSERT INTO MEMBRE VALUES ('robg0712', 'Gregory', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('colc0802', 'Christopher', 'Coleman', 'GEGI');
INSERT INTO MEMBRE VALUES ('morr0227', 'Rebecca', 'Morris', 'GM');
INSERT INTO MEMBRE VALUES ('johs0522', 'Sarah', 'Johnson', 'GEGI');
INSERT INTO MEMBRE VALUES ('robk0409', 'Kimberly', 'Roberts', 'GChim');
INSERT INTO MEMBRE VALUES ('stoj0120', 'John', 'Stone', 'GEGI');
INSERT INTO MEMBRE VALUES ('harm0605', 'Elizabeth', 'Harper', 'GEGI');
INSERT INTO MEMBRE VALUES ('davl0819', 'Victoria', 'Davis', 'GCiv');
INSERT INTO MEMBRE VALUES ('robj0728', 'Jeffrey', 'Roberts', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakm0516', 'Michelle', 'Baker', 'GEGI');
INSERT INTO MEMBRE VALUES ('wals0622', 'Stephanie', 'Walker', 'GM');
INSERT INTO MEMBRE VALUES ('morj0107', 'David', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('tayj0519', 'Jessica', 'Taylor', 'GChim');
INSERT INTO MEMBRE VALUES ('parr0922', 'Andrew', 'Parker', 'GEGI');
INSERT INTO MEMBRE VALUES ('johw0115', 'Emily', 'Johnson', 'GEGI');
INSERT INTO MEMBRE VALUES ('ricj1010', 'Joshua', 'Richardson', 'GCiv');
INSERT INTO MEMBRE VALUES ('robg0327', 'Steven', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakj0720', 'Julia', 'Baker', 'GEGI');
INSERT INTO MEMBRE VALUES ('walr0326', 'Rebecca', 'Walker', 'GM');
INSERT INTO MEMBRE VALUES ('morj0914', 'Jack', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('taym0125', 'Megan', 'Taylor', 'GChim');
INSERT INTO MEMBRE VALUES ('parr0517', 'Nicholas', 'Parker', 'GEGI');
INSERT INTO MEMBRE VALUES ('johw0202', 'Olivia', 'Johnson', 'GEGI');
INSERT INTO MEMBRE VALUES ('ricj1115', 'Sophia', 'Richardson', 'GCiv');
INSERT INTO MEMBRE VALUES ('robg0323', 'Tyler', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakj0225', 'Jacob', 'Baker', 'GEGI');
INSERT INTO MEMBRE VALUES ('morj0318', 'Emily', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('tayj0221', 'Andrew', 'Taylor', 'GChim');
INSERT INTO MEMBRE VALUES ('parr0105', 'Abigail', 'Parker', 'GEGI');
INSERT INTO MEMBRE VALUES ('johw0225', 'Nathan', 'Johnson', 'GEGI');
INSERT INTO MEMBRE VALUES ('ricj0710', 'Liam', 'Richardson', 'GCiv');
INSERT INTO MEMBRE VALUES ('robg0423', 'Ava', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('walr0726', 'Elijah', 'Walker', 'GM');
INSERT INTO MEMBRE VALUES ('morj0421', 'Grace', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('taym0325', 'Ryan', 'Taylor', 'GChim');
INSERT INTO MEMBRE VALUES ('parr0217', 'Hannah', 'Parker', 'GEGI');
INSERT INTO MEMBRE VALUES ('johw0110', 'Lucas', 'Johnson', 'GEGI');
INSERT INTO MEMBRE VALUES ('ricj0308', 'Jackson', 'Richardson', 'GCiv');
INSERT INTO MEMBRE VALUES ('robg0512', 'Madison', 'Robinson', 'GEGI');
INSERT INTO MEMBRE VALUES ('bakj0320', 'Avery', 'Baker', 'GEGI');
INSERT INTO MEMBRE VALUES ('walr0806', 'Scarlett', 'Walker', 'GM');
INSERT INTO MEMBRE VALUES ('morj0312', 'Chloe', 'Morris', 'GEGI');
INSERT INTO MEMBRE VALUES ('tayj0924', 'Ethan', 'Taylor', 'GChim');
INSERT INTO MEMBRE VALUES ('parr0419', 'Evelyn', 'Parker', 'GEGI');
INSERT INTO MEMBRE VALUES ('johw0828', 'Logan', 'Johnson', 'GEGI');

INSERT INTO STATUT VALUES (0,'Administrateur');
INSERT INTO STATUT VALUES (1,'Etudiant');
INSERT INTO STATUT VALUES (2,'Professeur');
INSERT INTO STATUT VALUES (3,'Personel de soutien');

INSERT INTO STATUTMEMBRE VALUES (0, 'ronk2602');
INSERT INTO STATUTMEMBRE VALUES (1, 'ronm0401');
INSERT INTO STATUTMEMBRE VALUES (2, 'smij0703');
INSERT INTO STATUTMEMBRE VALUES (0, 'robw0110');
INSERT INTO STATUTMEMBRE VALUES (0, 'wilc0817');
INSERT INTO STATUTMEMBRE VALUES (1, 'jamd0219');
INSERT INTO STATUTMEMBRE VALUES (0, 'robj1208');
INSERT INTO STATUTMEMBRE VALUES (2, 'bakd0311');
INSERT INTO STATUTMEMBRE VALUES (0, 'grem0215');
INSERT INTO STATUTMEMBRE VALUES (2, 'ricj0412');
INSERT INTO STATUTMEMBRE VALUES (0, 'parl0109');
INSERT INTO STATUTMEMBRE VALUES (1, 'wilk0121');
INSERT INTO STATUTMEMBRE VALUES (0, 'morj0905');
INSERT INTO STATUTMEMBRE VALUES (3, 'thom0114');
INSERT INTO STATUTMEMBRE VALUES (3, 'hill0623');
INSERT INTO STATUTMEMBRE VALUES (3, 'broa0223');
INSERT INTO STATUTMEMBRE VALUES (3, 'powm0308');
INSERT INTO STATUTMEMBRE VALUES (3, 'robg0125');

INSERT INTO STATUT_Privileges VALUES ('Peut acceder au bureaux de l''administration', 0);
INSERT INTO STATUT_Privileges VALUES ('Acces limite', 1);
INSERT INTO STATUT_Privileges VALUES ('Peut reserver les salons d''enseignants', 2);
INSERT INTO STATUT_Privileges VALUES ('Peut acceder a toutes les salles', 3);

INSERT INTO CUBICULE VALUES (0, 3014, 'C1');
INSERT INTO CUBICULE VALUES (1, 3014, 'C1');
INSERT INTO CUBICULE VALUES (2, 3014, 'C1');
INSERT INTO CUBICULE VALUES (3, 3014, 'C1');
INSERT INTO CUBICULE VALUES (4, 3014, 'C1');

INSERT INTO RESERVATION VALUES ('12:30:00', '13:30:00', 5, '001', '2023-09-12', 'on doit vrm faire l''app, ayaye', 'ronk2602', 3014, 'C1');