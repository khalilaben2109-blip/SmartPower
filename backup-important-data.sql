-- Sauvegarde des données importantes avant recréation des tables

-- Sauvegarder les utilisateurs existants
INSERT INTO utilisateurs_backup (id, nom, prenom, email, mot_de_passe, date_creation, statut_compte)
SELECT id, nom, prenom, email, mot_de_passe, date_creation, statut_compte 
FROM utilisateurs;

-- Sauvegarder les clients
INSERT INTO clients_backup (id, nom, prenom, email, telephone, adresse, ville, code_postal, mot_de_passe, date_creation, statut_compte)
SELECT id, nom, prenom, email, telephone, adresse, ville, code_postal, mot_de_passe, date_creation, statut_compte 
FROM clients;

-- Sauvegarder les techniciens
INSERT INTO techniciens_backup (id, nom, prenom, email, telephone, specialite, mot_de_passe, date_creation, statut_compte)
SELECT id, nom, prenom, email, telephone, specialite, mot_de_passe, date_creation, statut_compte 
FROM techniciens;

-- Sauvegarder les RH
INSERT INTO rhs_backup (id, nom, prenom, email, telephone, departement, mot_de_passe, date_creation, statut_compte)
SELECT id, nom, prenom, email, telephone, departement, mot_de_passe, date_creation, statut_compte 
FROM rhs;

-- Sauvegarder les admins
INSERT INTO admins_backup (id, nom, prenom, email, telephone, mot_de_passe, date_creation, statut_compte)
SELECT id, nom, prenom, email, telephone, mot_de_passe, date_creation, statut_compte 
FROM admins;
