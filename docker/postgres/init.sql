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
    Fonc_id int NOT NULL,
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
    Pav_id VARCHAR(16) NOT NULL,
    Local_num VARCHAR(16) NOT NULL,
    Capacite INT NOT NULL,
    fonc_id INT NOT NULL,
    Notes VARCHAR(1024),
    PRIMARY KEY (Local_num, Pav_id),
    FOREIGN KEY (Pav_id) REFERENCES PAVILLON(Pav_id),
    FOREIGN KEY (fonc_id) REFERENCES Fonction(fonc_id)
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

CREATE TABLE RESERVATION
(
    Heure_debut timestamp NOT NULL,
    Heure_fin timestamp NOT NULL,
    _Nb_places INT NOT NULL,
    Reserve_id VARCHAR(16) NOT NULL,
    Description VARCHAR(1024),
    Cip VARCHAR(8) NOT NULL,
    Local_num VARCHAR(16) NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    num_cubicule INT,
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
    Local_num VARCHAR(16) NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Num_cubicule, Local_num, Pav_id),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id)
);

CREATE TABLE LOCALCARACTERISTIQUE
(
    Local_num VARCHAR(16) NOT NULL,
    Pav_id VARCHAR(16) NOT NULL,
    Carac_id VARCHAR(16) NOT NULL,
    PRIMARY KEY (Local_num, Pav_id, Carac_id),
    FOREIGN KEY (Local_num, Pav_id) REFERENCES LOCAL(Local_num, Pav_id),
    FOREIGN KEY (Carac_id) REFERENCES CARACTERISTIQUE(Carac_id)
);

CREATE TABLE LOGBOOK
(
    Log_id SERIAL NOT NULL,
    Description VARCHAR(1024) NOT NULL,
    Date TIMESTAMP NOT NULL,
    Local_num VARCHAR(32) NOT NULL,
    pav_id VARCHAR(32) NOT NULL,
    Cip VARCHAR(16) NOT NULL,
    num_Cubicule INT,
    PRIMARY KEY (Log_id),
    FOREIGN KEY (Cip) REFERENCES MEMBRE(Cip),
    FOREIGN KEY (num_Cubicule, Local_num, pav_id) REFERENCES CUBICULE(num_Cubicule, local_num, pav_id),
    FOREIGN KEY (Local_num, pav_id) REFERENCES local(local_num, pav_id)
);

CREATE TABLE STATUT_Privileges
(
    Privileges VARCHAR(1024) NOT NULL,
    Statut_id INT NOT NULL,
    PRIMARY KEY (Privileges, Statut_id),
    FOREIGN KEY (Statut_id) REFERENCES STATUT(Statut_id)
);
