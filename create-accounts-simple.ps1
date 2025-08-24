Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CREATION DES COMPTES DE TEST" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "ETAPES A SUIVRE:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Ouvrez pgAdmin 4" -ForegroundColor White
Write-Host "2. Connectez-vous a votre base de donnees PostgreSQL" -ForegroundColor White
Write-Host "3. Selectionnez la base de donnees SmartCompteur" -ForegroundColor White
Write-Host "4. Ouvrez l'editeur de requetes SQL" -ForegroundColor White
Write-Host "5. Copiez et executez le contenu du fichier create-test-accounts.sql" -ForegroundColor White
Write-Host ""

Write-Host "Comptes qui seront crees:" -ForegroundColor White
Write-Host "   CLIENT:     client@example.com / password" -ForegroundColor Cyan
Write-Host "   TECHNICIEN: technicien@example.com / password" -ForegroundColor Cyan
Write-Host "   RH:         rh@example.com / password" -ForegroundColor Cyan
Write-Host ""

Write-Host "Une fois le script SQL execute, testez avec:" -ForegroundColor Yellow
Write-Host "   .\test-all-accounts.ps1" -ForegroundColor Cyan
Write-Host ""
