-- Verification des tables de roles
-- Vérifier si les utilisateurs sont dans les bonnes tables de rôles

-- 1. Vérifier la table admins
SELECT 'ADMINS' as table_name, COUNT(*) as count FROM public.admins;

-- 2. Vérifier la table clients
SELECT 'CLIENTS' as table_name, COUNT(*) as count FROM public.clients;

-- 3. Vérifier la table rhs
SELECT 'RHS' as table_name, COUNT(*) as count FROM public.rhs;

-- 4. Vérifier la table techniciens
SELECT 'TECHNICIENS' as table_name, COUNT(*) as count FROM public.techniciens;

-- 5. Vérifier les utilisateurs spécifiques dans chaque table
SELECT 'ADMIN dans admins' as info, id FROM public.admins WHERE id = 2
UNION ALL
SELECT 'CLIENT dans clients' as info, id FROM public.clients WHERE id = 3
UNION ALL
SELECT 'RH dans rhs' as info, id FROM public.rhs WHERE id = 5
UNION ALL
SELECT 'TECHNICIEN dans techniciens' as info, id FROM public.techniciens WHERE id = 4;
