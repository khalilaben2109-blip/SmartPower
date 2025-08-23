-- Script pour mettre à jour le mot de passe admin avec BCrypt
-- Le mot de passe "admin" encodé avec BCrypt
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'
WHERE email = 'admin@gmail.com';

-- Vérification
SELECT id, email, nom, prenom, mot_de_passe FROM public.utilisateurs WHERE email = 'admin@gmail.com';
