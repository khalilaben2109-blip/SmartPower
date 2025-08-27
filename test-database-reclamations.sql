-- Vérifier la structure de la table reclamations
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'reclamations'
ORDER BY ordinal_position;

-- Vérifier les contraintes de la table
SELECT 
    tc.constraint_name, 
    tc.constraint_type, 
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.constraint_column_usage ccu 
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'reclamations';

-- Vérifier les données existantes
SELECT * FROM reclamations LIMIT 5;

-- Vérifier les RH et Admin disponibles
SELECT 'RH' as type, id, nom, prenom, email FROM rhs LIMIT 3;
SELECT 'ADMIN' as type, id, nom, prenom, email FROM admins LIMIT 3;
