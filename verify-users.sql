-- Verification des utilisateurs et leurs mots de passe
-- Vérifier si les utilisateurs existent et ont les bons mots de passe

-- 1. Vérifier tous les utilisateurs
SELECT 
    id,
    email,
    nom,
    prenom,
    LEFT(mot_de_passe, 30) || '...' as mot_de_passe_debut,
    LENGTH(mot_de_passe) as password_length,
    CASE 
        WHEN mot_de_passe LIKE '$2a$%' THEN 'BCrypt Encodé'
        ELSE 'Texte clair - PROBLEME'
    END as password_status
FROM public.utilisateurs 
WHERE email IN ('admin@gmail.com', 'client@example.com', 'technicien@example.com', 'rh@example.com')
ORDER BY email;

-- 2. Vérifier les rôles
SELECT 
    u.email,
    CASE 
        WHEN a.id IS NOT NULL THEN 'ADMIN'
        WHEN c.id IS NOT NULL THEN 'CLIENT'
        WHEN r.id IS NOT NULL THEN 'RH'
        WHEN t.id IS NOT NULL THEN 'TECHNICIEN'
        ELSE 'UTILISATEUR'
    END as role
FROM public.utilisateurs u
LEFT JOIN public.admins a ON u.id = a.id
LEFT JOIN public.clients c ON u.id = c.id
LEFT JOIN public.rhs r ON u.id = r.id
LEFT JOIN public.techniciens t ON u.id = t.id
WHERE u.email IN ('admin@gmail.com', 'client@example.com', 'technicien@example.com', 'rh@example.com')
ORDER BY u.email;
