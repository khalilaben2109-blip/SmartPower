-- =====================================================
-- CORRECTION DU COMPTE SUPERADMIN
-- =====================================================

-- Supprimer l'ancien compte superadmin
DELETE FROM public.admins WHERE id IN (SELECT id FROM public.utilisateurs WHERE email = 'superadmin@gmail.com');
DELETE FROM public.utilisateurs WHERE email = 'superadmin@gmail.com';

-- Recréer le compte superadmin avec le bon hash BCrypt pour "admin"
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Super', 'Admin', 'superadmin@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '+33123456788', CURRENT_DATE, 'ACTIF');

INSERT INTO public.admins (id)
SELECT id FROM public.utilisateurs WHERE email = 'superadmin@gmail.com';

-- Vérification
SELECT 
    u.email,
    u.nom,
    u.prenom,
    'admin' as mot_de_passe_attendu,
    CASE 
        WHEN u.mot_de_passe LIKE '$2a$%' THEN 'BCrypt Valide'
        ELSE 'PROBLEME DE CRYPTAGE'
    END as statut_cryptage
FROM public.utilisateurs u
WHERE u.email = 'superadmin@gmail.com';
