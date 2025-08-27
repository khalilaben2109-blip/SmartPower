Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST FONCTIONNALITE TECHNICIEN-COMPTEURS" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Vérification du backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "✅ Backend accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend non accessible. Lancez d'abord le projet." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Vérification du frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 5
    Write-Host "✅ Frontend accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend non accessible. Lancez d'abord le projet." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Instructions pour tester la fonctionnalité:" -ForegroundColor Yellow
Write-Host "  1. Ouvrez votre navigateur sur: http://localhost:5173" -ForegroundColor Cyan
Write-Host "  2. Connectez-vous avec: technicien@gmail.com / password" -ForegroundColor White
Write-Host "  3. Vous devriez être sur l'interface technique" -ForegroundColor White
Write-Host "  4. Cliquez sur 'Gérer les Compteurs' dans les Actions Rapides" -ForegroundColor White
Write-Host "  5. Testez les fonctionnalités suivantes:" -ForegroundColor White
Write-Host ""
Write-Host "4. Fonctionnalités à tester:" -ForegroundColor Yellow
Write-Host "  ✅ Créer un nouveau compteur" -ForegroundColor Green
Write-Host "  ✅ Affecter un compteur à un client" -ForegroundColor Green
Write-Host "  ✅ Désaffecter un compteur d'un client" -ForegroundColor Green
Write-Host "  ✅ Changer le statut d'un compteur" -ForegroundColor Green
Write-Host "  ✅ Rechercher des compteurs" -ForegroundColor Green
Write-Host "  ✅ Voir la liste des clients disponibles" -ForegroundColor Green
Write-Host ""
Write-Host "5. Test de création de compteur:" -ForegroundColor Yellow
Write-Host "  - Numéro de série: COMP001" -ForegroundColor Gray
Write-Host "  - Type: Monophasé" -ForegroundColor Gray
Write-Host "  - Abonnement: Résidentiel" -ForegroundColor Gray
Write-Host "  - Puissance: 6 kVA" -ForegroundColor Gray
Write-Host "  - Tension: 230V" -ForegroundColor Gray
Write-Host "  - Phases: 1" -ForegroundColor Gray
Write-Host "  - Intelligent: Non" -ForegroundColor Gray
Write-Host "  - Client: Sélectionner un client existant" -ForegroundColor Gray
Write-Host ""
Write-Host "6. Vérifications à faire:" -ForegroundColor Yellow
Write-Host "  ✅ Le compteur apparaît dans la liste" -ForegroundColor Green
Write-Host "  ✅ Le client est correctement affiché" -ForegroundColor Green
Write-Host "  ✅ Le statut est 'Actif'" -ForegroundColor Green
Write-Host "  ✅ Les actions fonctionnent (désaffecter, changer statut)" -ForegroundColor Green
Write-Host ""
Write-Host "7. API endpoints testés:" -ForegroundColor Yellow
Write-Host "  - GET /api/technicien/clients" -ForegroundColor Gray
Write-Host "  - GET /api/technicien/compteurs" -ForegroundColor Gray
Write-Host "  - POST /api/technicien/compteurs" -ForegroundColor Gray
Write-Host "  - PUT /api/technicien/compteurs/{id}/affecter-client" -ForegroundColor Gray
Write-Host "  - PUT /api/technicien/compteurs/{id}/desaffecter-client" -ForegroundColor Gray
Write-Host "  - PUT /api/technicien/compteurs/{id}/statut" -ForegroundColor Gray
Write-Host "  - GET /api/technicien/compteurs/search" -ForegroundColor Gray
Write-Host ""
