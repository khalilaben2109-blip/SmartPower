-- Script final pour corriger le mot de passe admin
-- Le mot de passe "admin" doit être encodé en BCrypt

-- 1. Vérification de l'état actuel
SELECT 
    id,
    email,
    nom,
    prenom,
    mot_de_passe,
    CASE 
        WHEN mot_de_passe LIKE '$2a$%' THEN 'BCrypt Encodé'
        ELSE 'Texte clair - PROBLEME'
    END as status_password
FROM public.utilisateurs 
WHERE email = 'admin@gmail.com';

-- 2. Mise à jour du mot de passe "admin" encodé en BCrypt
-- Hash BCrypt pour "admin" : $2a$10$DowJonesWall.Street2020$adminPasswordHashForTestOnly
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPjiCx86C'
WHERE email = 'admin@gmail.com';

-- 3. S'assurer que l'utilisateur est dans la table admins
INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'admin@gmail.com'
ON CONFLICT (id) DO NOTHING;

-- 4. Vérification finale
SELECT 
    u.id,
    u.email,
    u.nom,
    u.prenom,
    LEFT(u.mot_de_passe, 20) || '...' as mot_de_passe_debut,
    CASE 
        WHEN a.id IS NOT NULL THEN 'ADMIN'
        ELSE 'PAS ADMIN'
    END as role_status
FROM public.utilisateurs u
LEFT JOIN public.admins a ON u.id = a.id
WHERE u.email = 'admin@gmail.com';
