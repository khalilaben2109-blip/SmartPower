-- =====================================================
-- CORRECTION DU PROBLEME DE CRYPTAGE DES MOTS DE PASSE
-- =====================================================
-- Ce script corrige le problème de cryptage BCrypt

-- 1. SUPPRESSION DES COMPTES EXISTANTS PROBLÉMATIQUES
-- ===================================================

-- Supprimer les données liées aux utilisateurs
DELETE FROM public.taches WHERE technicien_id IN (SELECT id FROM public.techniciens);
DELETE FROM public.incidents WHERE technicien_id IN (SELECT id FROM public.techniciens);
DELETE FROM public.reclamations WHERE client_id IN (SELECT id FROM public.clients);
DELETE FROM public.factures WHERE client_id IN (SELECT id FROM public.clients);
DELETE FROM public.releves WHERE compteur_id IN (SELECT id FROM public.compteurs);
DELETE FROM public.compteurs WHERE client_id IN (SELECT id FROM public.clients);
DELETE FROM public.alertes WHERE utilisateur_id IN (SELECT id FROM public.utilisateurs);

-- Supprimer les utilisateurs des tables de rôles
DELETE FROM public.techniciens;
DELETE FROM public.rhs;
DELETE FROM public.clients;
DELETE FROM public.admins;

-- Supprimer tous les utilisateurs
DELETE FROM public.utilisateurs;

-- Réinitialiser les séquences
ALTER SEQUENCE public.utilisateurs_id_seq RESTART WITH 1;

-- 2. CRÉATION DE NOUVEAUX COMPTES AVEC CRYPTAGE CORRECT
-- =====================================================

-- Hash BCrypt correct pour "password" (généré avec BCrypt)
-- Hash BCrypt correct pour "admin" (généré avec BCrypt)

-- Compte Admin Principal
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Admin', 'Principal', 'admin@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33123456789', CURRENT_DATE, 'ACTIF');

INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'admin@gmail.com';

-- Compte Super Admin
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Super', 'Admin', 'superadmin@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '+33123456788', CURRENT_DATE, 'ACTIF');

INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'superadmin@gmail.com';

-- Compte Client 1
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Dupont', 'Jean', 'client1@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33987654321', CURRENT_DATE, 'ACTIF');

INSERT INTO public.clients (id)
SELECT id FROM public.utilisateurs WHERE email = 'client1@gmail.com';

-- Compte Client 2
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Martin', 'Sophie', 'client2@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33987654322', CURRENT_DATE, 'ACTIF');

INSERT INTO public.clients (id)
SELECT id FROM public.utilisateurs WHERE email = 'client2@gmail.com';

-- Compte Technicien 1
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Durand', 'Pierre', 'technicien1@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33555555551', CURRENT_DATE, 'ACTIF');

INSERT INTO public.techniciens (id)
SELECT id FROM public.utilisateurs WHERE email = 'technicien1@gmail.com';

-- Compte Technicien 2
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Leroy', 'Michel', 'technicien2@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33555555552', CURRENT_DATE, 'ACTIF');

INSERT INTO public.techniciens (id)
SELECT id FROM public.utilisateurs WHERE email = 'technicien2@gmail.com';

-- Compte RH 1
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Bernard', 'Marie', 'rh1@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33444444441', CURRENT_DATE, 'ACTIF');

INSERT INTO public.rhs (id)
SELECT id FROM public.utilisateurs WHERE email = 'rh1@gmail.com';

-- Compte RH 2
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Petit', 'Claire', 'rh2@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33444444442', CURRENT_DATE, 'ACTIF');

INSERT INTO public.rhs (id)
SELECT id FROM public.utilisateurs WHERE email = 'rh2@gmail.com';

-- Compte Superviseur
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Moreau', 'Paul', 'superviseur@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+33666666666', CURRENT_DATE, 'ACTIF');

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
    END as mot_de_passe,
    CASE 
        WHEN u.mot_de_passe LIKE '$2a$%' THEN 'BCrypt Valide'
        ELSE 'PROBLEME DE CRYPTAGE'
    END as statut_cryptage
FROM public.utilisateurs u
LEFT JOIN public.admins a ON u.id = a.id
LEFT JOIN public.clients c ON u.id = c.id
LEFT JOIN public.rhs r ON u.id = r.id
LEFT JOIN public.techniciens t ON u.id = t.id
ORDER BY u.email;

-- 4. RÉSUMÉ DES COMPTES
-- =====================

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
