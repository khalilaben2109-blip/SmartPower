-- =====================================================
-- SCRIPT DE CORRECTION DES MOTS DE PASSE
-- =====================================================
-- Ce script met à jour tous les mots de passe pour utiliser "password"

-- Hash BCrypt pour le mot de passe "password"
-- Hash BCrypt pour le mot de passe "admin"

-- 1. MISE À JOUR DE TOUS LES MOTS DE PASSE
-- =========================================

-- Mettre à jour tous les comptes pour utiliser "password"
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S'
WHERE email IN (
    'admin@gmail.com',
    'client1@gmail.com',
    'client2@gmail.com',
    'technicien1@gmail.com',
    'technicien2@gmail.com',
    'rh1@gmail.com',
    'rh2@gmail.com',
    'superviseur@gmail.com'
);

-- Mettre à jour le compte superadmin pour utiliser "admin"
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'
WHERE email = 'superadmin@gmail.com';

-- 2. VÉRIFICATION DES COMPTES MIS À JOUR
-- ======================================

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
WHERE u.email IN (
    'admin@gmail.com',
    'superadmin@gmail.com',
    'client1@gmail.com',
    'client2@gmail.com',
    'technicien1@gmail.com',
    'technicien2@gmail.com',
    'rh1@gmail.com',
    'rh2@gmail.com',
    'superviseur@gmail.com'
)
ORDER BY u.email;

-- 3. RÉSUMÉ DES COMPTES
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
