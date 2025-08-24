Write-Host "Verification de la base de donnees..." -ForegroundColor Green
Write-Host ""

Write-Host "IMPORTANT: Executez ce script SQL dans pgAdmin pour voir l'etat actuel:" -ForegroundColor Yellow
Write-Host ""

Write-Host "-- Verification de tous les utilisateurs" -ForegroundColor Cyan
Write-Host "SELECT " -ForegroundColor White
Write-Host "    u.id," -ForegroundColor White
Write-Host "    u.email," -ForegroundColor White
Write-Host "    u.nom," -ForegroundColor White
Write-Host "    u.prenom," -ForegroundColor White
Write-Host "    u.telephone," -ForegroundColor White
Write-Host "    u.statut_compte," -ForegroundColor White
Write-Host "    LEFT(u.mot_de_passe, 20) || '...' as mot_de_passe_debut," -ForegroundColor White
Write-Host "    CASE " -ForegroundColor White
Write-Host "        WHEN a.id IS NOT NULL THEN 'ADMIN'" -ForegroundColor White
Write-Host "        WHEN c.id IS NOT NULL THEN 'CLIENT'" -ForegroundColor White
Write-Host "        WHEN r.id IS NOT NULL THEN 'RH'" -ForegroundColor White
Write-Host "        WHEN t.id IS NOT NULL THEN 'TECHNICIEN'" -ForegroundColor White
Write-Host "        ELSE 'UTILISATEUR'" -ForegroundColor White
Write-Host "    END as role," -ForegroundColor White
Write-Host "    CASE " -ForegroundColor White
Write-Host "        WHEN u.mot_de_passe LIKE '$2a$%' THEN 'BCrypt Encodé'" -ForegroundColor White
Write-Host "        ELSE 'Texte clair - PROBLEME'" -ForegroundColor White
Write-Host "    END as password_status" -ForegroundColor White
Write-Host "FROM public.utilisateurs u" -ForegroundColor White
Write-Host "LEFT JOIN public.admins a ON u.id = a.id" -ForegroundColor White
Write-Host "LEFT JOIN public.clients c ON u.id = c.id" -ForegroundColor White
Write-Host "LEFT JOIN public.rhs r ON u.id = r.id" -ForegroundColor White
Write-Host "LEFT JOIN public.techniciens t ON u.id = t.id" -ForegroundColor White
Write-Host "ORDER BY u.email;" -ForegroundColor White
Write-Host ""

Write-Host "Copiez et executez ce script dans pgAdmin, puis dites-moi le resultat!" -ForegroundColor Yellow
