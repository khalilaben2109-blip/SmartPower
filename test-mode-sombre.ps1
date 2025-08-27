Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST DU MODE SOMBRE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Vérification du frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 5
    Write-Host "✅ Frontend accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend non accessible. Lancez d'abord le projet." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Instructions pour tester le mode sombre:" -ForegroundColor Yellow
Write-Host "  1. Ouvrez votre navigateur sur: http://localhost:5173" -ForegroundColor Cyan
Write-Host "  2. Connectez-vous avec un compte (ex: admin@gmail.com / password)" -ForegroundColor White
Write-Host "  3. Dans l'en-tête, cliquez sur l'icône lune/soleil" -ForegroundColor White
Write-Host "  4. Vérifiez que l'interface change de couleur" -ForegroundColor White
Write-Host "  5. Rechargez la page pour vérifier la persistance" -ForegroundColor White
Write-Host ""
Write-Host "3. Vérifications à faire:" -ForegroundColor Yellow
Write-Host "  ✅ L'arrière-plan devient sombre" -ForegroundColor Green
Write-Host "  ✅ Le texte devient clair" -ForegroundColor Green
Write-Host "  ✅ Les bordures s'adaptent" -ForegroundColor Green
Write-Host "  ✅ Le thème persiste après rechargement" -ForegroundColor Green
Write-Host "  - L'icone change (lune soleil)" -ForegroundColor Green
Write-Host ""
Write-Host "4. Si le mode sombre ne fonctionne pas:" -ForegroundColor Yellow
Write-Host "  - Ouvrez la console du navigateur (F12)" -ForegroundColor Gray
Write-Host "  - Verifiez les messages de debug du theme" -ForegroundColor Gray
Write-Host "  - Verifiez que la classe 'dark' est ajoutee a html" -ForegroundColor Gray
Write-Host ""
