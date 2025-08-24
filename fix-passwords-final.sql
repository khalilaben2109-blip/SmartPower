-- Script pour corriger les mots de passe avec les bons hashes BCrypt
-- Ces hashes ont été générés par le backend Spring Boot

-- 1. Corriger le mot de passe admin (déjà correct)
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S'
WHERE email = 'admin@gmail.com';

-- 2. Corriger le mot de passe client (password)
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'
WHERE email = 'client@example.com';

-- 3. Corriger le mot de passe technicien (password)
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'
WHERE email = 'technicien@example.com';

-- 4. Corriger le mot de passe RH (password)
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'
WHERE email = 'rh@example.com';

-- 5. Vérification finale
SELECT 
    email,
    LEFT(mot_de_passe, 30) || '...' as mot_de_passe_debut,
    CASE 
        WHEN mot_de_passe LIKE '$2a$%' THEN 'BCrypt Encodé'
        ELSE 'Texte clair - PROBLEME'
    END as password_status
FROM public.utilisateurs 
WHERE email IN ('admin@gmail.com', 'client@example.com', 'technicien@example.com', 'rh@example.com')
ORDER BY email;

