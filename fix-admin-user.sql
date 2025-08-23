-- Script pour corriger l'utilisateur admin
-- 1. Vérifier l'utilisateur existant
SELECT id, email, nom, prenom, mot_de_passe FROM public.utilisateurs WHERE email = 'admin@gmail.com';

-- 2. Mettre à jour le mot de passe avec BCrypt
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'
WHERE email = 'admin@gmail.com';

-- 3. Insérer l'utilisateur dans la table admins
INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'admin@gmail.com'
ON CONFLICT (id) DO NOTHING;

-- 4. Vérification finale
SELECT 
    u.id,
    u.email,
    u.nom,
    u.prenom,
    u.mot_de_passe,
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
WHERE u.email = 'admin@gmail.com';
