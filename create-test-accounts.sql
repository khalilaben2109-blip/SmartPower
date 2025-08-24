-- Script pour créer des comptes de test pour tous les rôles
-- Hash BCrypt pour le mot de passe "password"

-- 1. Créer un compte Client
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Dupont', 'Jean', 'client@example.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33987654321', CURRENT_DATE, 'ACTIF')
ON CONFLICT (email) DO NOTHING;

-- Insérer dans la table clients
INSERT INTO public.clients (id)
SELECT id FROM public.utilisateurs WHERE email = 'client@example.com'
ON CONFLICT (id) DO NOTHING;

-- 2. Créer un compte Technicien
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Durand', 'Pierre', 'technicien@example.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33555555555', CURRENT_DATE, 'ACTIF')
ON CONFLICT (email) DO NOTHING;

-- Insérer dans la table techniciens
INSERT INTO public.techniciens (id)
SELECT id FROM public.utilisateurs WHERE email = 'technicien@example.com'
ON CONFLICT (id) DO NOTHING;

-- 3. Créer un compte RH
INSERT INTO public.utilisateurs (nom, prenom, email, mot_de_passe, telephone, date_creation, statut_compte)
VALUES ('Bernard', 'Sophie', 'rh@example.com', '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S', '+33444444444', CURRENT_DATE, 'ACTIF')
ON CONFLICT (email) DO NOTHING;

-- Insérer dans la table rhs
INSERT INTO public.rhs (id)
SELECT id FROM public.utilisateurs WHERE email = 'rh@example.com'
ON CONFLICT (id) DO NOTHING;

-- 4. Vérification des comptes créés
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
    END as role
FROM public.utilisateurs u
LEFT JOIN public.admins a ON u.id = a.id
LEFT JOIN public.clients c ON u.id = c.id
LEFT JOIN public.rhs r ON u.id = r.id
LEFT JOIN public.techniciens t ON u.id = t.id
WHERE u.email IN ('admin@gmail.com', 'client@example.com', 'technicien@example.com', 'rh@example.com')
ORDER BY u.email;
