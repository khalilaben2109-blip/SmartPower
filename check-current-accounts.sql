-- Script pour vérifier l'état actuel des comptes
-- Exécutez ce script AVANT le script de mise à jour

-- Vérifier tous les utilisateurs existants
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
        WHEN u.mot_de_passe LIKE '$2a$%' THEN 'BCrypt Encodé'
        ELSE 'Texte clair - PROBLEME'
    END as password_status
FROM public.utilisateurs u
LEFT JOIN public.admins a ON u.id = a.id
LEFT JOIN public.clients c ON u.id = c.id
LEFT JOIN public.rhs r ON u.id = r.id
LEFT JOIN public.techniciens t ON u.id = t.id
ORDER BY u.email;
