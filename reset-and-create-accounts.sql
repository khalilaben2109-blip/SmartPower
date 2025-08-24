-- =====================================================
-- SCRIPT DE RÉINITIALISATION COMPLÈTE DES COMPTES
-- =====================================================
-- ATTENTION: Ce script supprime TOUS les comptes existants
-- et crée de nouveaux comptes de test

-- 1. SUPPRESSION DE TOUS LES COMPTES EXISTANTS
-- =============================================

-- Supprimer les données des tables de rôles (dans l'ordre pour éviter les contraintes)
DELETE FROM public.taches;
DELETE FROM public.incidents;
DELETE FROM public.reclamations;
DELETE FROM public.factures;
DELETE FROM public.releves;
DELETE FROM public.compteurs;
DELETE FROM public.alertes;

-- Supprimer les utilisateurs des tables de rôles
DELETE FROM public.techniciens;
DELETE FROM public.rhs;
DELETE FROM public.clients;
DELETE FROM public.admins;

-- Supprimer tous les utilisateurs
DELETE FROM public.utilisateurs;

-- Réinitialiser les séquences d'ID
ALTER SEQUENCE public.utilisateurs_id_seq RESTART WITH 1;

-- 2. CRÉATION DES NOUVEAUX COMPTES
-- =================================

-- Hash BCrypt pour le mot de passe "password"
-- Hash BCrypt pour le mot de passe "admin"

-- Compte Admin Principal
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Admin', 'Principal', 'admin@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33123456789', CURRENT_DATE, 'ACTIF');

INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'admin@gmail.com';

-- Compte Admin avec mot de passe "admin"
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Super', 'Admin', 'superadmin@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '+33123456788', CURRENT_DATE, 'ACTIF');

INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'superadmin@gmail.com';

-- Compte Client 1
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Dupont', 'Jean', 'client1@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33987654321', CURRENT_DATE, 'ACTIF');

INSERT INTO public.clients (id)
SELECT id FROM public.utilisateurs WHERE email = 'client1@gmail.com';

-- Compte Client 2
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Martin', 'Sophie', 'client2@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33987654322', CURRENT_DATE, 'ACTIF');

INSERT INTO public.clients (id)
SELECT id FROM public.utilisateurs WHERE email = 'client2@gmail.com';

-- Compte Technicien 1
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Durand', 'Pierre', 'technicien1@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33555555551', CURRENT_DATE, 'ACTIF');

INSERT INTO public.techniciens (id)
SELECT id FROM public.utilisateurs WHERE email = 'technicien1@gmail.com';

-- Compte Technicien 2
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Leroy', 'Michel', 'technicien2@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33555555552', CURRENT_DATE, 'ACTIF');

INSERT INTO public.techniciens (id)
SELECT id FROM public.utilisateurs WHERE email = 'technicien2@gmail.com';

-- Compte RH 1
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Bernard', 'Marie', 'rh1@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33444444441', CURRENT_DATE, 'ACTIF');

INSERT INTO public.rhs (id)
SELECT id FROM public.utilisateurs WHERE email = 'rh1@gmail.com';

-- Compte RH 2
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Petit', 'Claire', 'rh2@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33444444442', CURRENT_DATE, 'ACTIF');

INSERT INTO public.rhs (id)
SELECT id FROM public.utilisateurs WHERE email = 'rh2@gmail.com';

-- Compte Superviseur
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Moreau', 'Paul', 'superviseur@gmail.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33666666666', CURRENT_DATE, 'ACTIF');

INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'superviseur@gmail.com';

-- 3. VÉRIFICATION DES COMPTES CRÉÉS
-- =================================

SELECT 
    u.id,
    u.email,
    u.nom,
    u.prenom,
    u.telephone,
    u.statut_compte,
    CASE 
        WHEN a.id IS NOT NULL THEN 'ADMIN'
        WHEN c.id IS NOT NULL THEN 'CLIENT'
        WHEN r.id IS NOT NULL THEN 'RH'
        WHEN t.id IS NOT NULL THEN 'TECHNICIEN'
        ELSE 'UTILISATEUR'
    END as role,
    CASE 
        WHEN u.email = 'superadmin@gmail.com' THEN 'admin'
        ELSE 'password'
    END as mot_de_passe
FROM public.utilisateurs u
LEFT JOIN public.admins a ON u.id = a.id
LEFT JOIN public.clients c ON u.id = c.id
LEFT JOIN public.rhs r ON u.id = r.id
LEFT JOIN public.techniciens t ON u.id = t.id
ORDER BY u.email;

-- 4. RÉSUMÉ DES COMPTES CRÉÉS
-- ============================

SELECT 
    'ADMIN' as role,
    COUNT(*) as nombre
FROM public.admins
UNION ALL
SELECT 
    'CLIENT' as role,
    COUNT(*) as nombre
FROM public.clients
UNION ALL
SELECT 
    'TECHNICIEN' as role,
    COUNT(*) as nombre
FROM public.techniciens
UNION ALL
SELECT 
    'RH' as role,
    COUNT(*) as nombre
FROM public.rhs
ORDER BY role;
