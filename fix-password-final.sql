-- Script final pour corriger le mot de passe admin
-- Hash BCrypt généré par Spring Boot pour "admin"

-- 1. Mise à jour avec le bon hash BCrypt
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S'
WHERE email = 'admin@gmail.com';

-- 2. S'assurer que l'utilisateur est dans la table admins
INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'admin@gmail.com'
ON CONFLICT (id) DO NOTHING;

-- 3. Vérification finale
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
