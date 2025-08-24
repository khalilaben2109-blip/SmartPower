Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CONFIGURATION DES COMPTES DE TEST" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "IMPORTANT: Exécutez le script SQL create-test-accounts.sql dans pgAdmin!" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Ouvrez pgAdmin 4" -ForegroundColor White
Write-Host "2. Connectez-vous à votre base de données PostgreSQL" -ForegroundColor White
Write-Host "3. Sélectionnez la base de données SmartCompteur" -ForegroundColor White
Write-Host "4. Ouvrez l'éditeur de requêtes SQL" -ForegroundColor White
Write-Host "5. Copiez et exécutez le contenu du fichier create-test-accounts.sql" -ForegroundColor White
Write-Host ""

Write-Host "Une fois le script SQL exécuté, lancez:" -ForegroundColor Yellow
Write-Host "   .\test-all-accounts.ps1" -ForegroundColor Cyan
Write-Host ""

Write-Host "Comptes qui seront créés:" -ForegroundColor White
Write-Host "   👤 CLIENT:    client@example.com / password" -ForegroundColor Cyan
Write-Host "   🔧 TECHNICIEN: technicien@example.com / password" -ForegroundColor Cyan
Write-Host "   👥 RH:        rh@example.com / password" -ForegroundColor Cyan
Write-Host ""

Write-Host "Appuyez sur une touche quand vous avez exécuté le script SQL..." -ForegroundColor Red
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host ""
Write-Host "Test des comptes créés..." -ForegroundColor Yellow
& .\test-all-accounts.ps1
