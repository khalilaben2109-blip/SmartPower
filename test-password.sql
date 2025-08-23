-- Script pour vérifier le mot de passe actuel
SELECT 
    id,
    email,
    nom,
    prenom,
    mot_de_passe,
    CASE 
        WHEN mot_de_passe LIKE '$2a$%' THEN 'BCrypt Encodé'
        WHEN mot_de_passe IS NULL THEN 'NULL'
        ELSE 'Texte clair'
    END as type_mot_de_passe
FROM public.utilisateurs 
WHERE email = 'admin@gmail.com';

-- Vérifier si l'utilisateur est dans la table admins
SELECT 
    'ADMIN' as role,
    COUNT(*) as count
FROM public.admins a
JOIN public.utilisateurs u ON a.id = u.id
WHERE u.email = 'admin@gmail.com'

UNION ALL

SELECT 
    'UTILISATEUR' as role,
    COUNT(*) as count
FROM public.utilisateurs
WHERE email = 'admin@gmail.com';
