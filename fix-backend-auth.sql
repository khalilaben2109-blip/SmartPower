-- Script pour verifier la structure de la base de donnees
-- et comprendre pourquoi l'authentification echoue

-- 1. Verifier les tables existantes
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('utilisateurs', 'admins', 'clients', 'rhs', 'techniciens')
ORDER BY table_name;

-- 2. Verifier la structure de la table utilisateurs
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'utilisateurs'
ORDER BY ordinal_position;

-- 3. Verifier les contraintes de cles etrangeres
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'public'
AND tc.table_name IN ('admins', 'clients', 'rhs', 'techniciens');

-- 4. Verifier le contenu des tables
SELECT 'utilisateurs' as table_name, COUNT(*) as count FROM public.utilisateurs
UNION ALL
SELECT 'admins' as table_name, COUNT(*) as count FROM public.admins
UNION ALL
SELECT 'clients' as table_name, COUNT(*) as count FROM public.clients
UNION ALL
SELECT 'rhs' as table_name, COUNT(*) as count FROM public.rhs
UNION ALL
SELECT 'techniciens' as table_name, COUNT(*) as count FROM public.techniciens;
