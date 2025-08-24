Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST DE LA PROTECTION DES ROUTES" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Test de connexion backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "  Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "  Backend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Test de connexion frontend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 5
    Write-Host "  Frontend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "  Frontend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Instructions pour tester la protection des routes:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  TEST 1 - ADMIN:" -ForegroundColor White
Write-Host "  1. Connectez-vous avec: admin@gmail.com / password" -ForegroundColor Yellow
Write-Host "  2. Vous devriez être sur: http://localhost:5173/admin" -ForegroundColor Cyan
Write-Host "  3. Essayez d'accéder à: http://localhost:5173/client" -ForegroundColor Yellow
Write-Host "  4. Vous devriez voir un message d'accès refusé puis être redirigé" -ForegroundColor Yellow
Write-Host ""
Write-Host "  TEST 2 - CLIENT:" -ForegroundColor White
Write-Host "  1. Connectez-vous avec: client1@gmail.com / password" -ForegroundColor Yellow
Write-Host "  2. Vous devriez être sur: http://localhost:5173/client" -ForegroundColor Cyan
Write-Host "  3. Essayez d'accéder à: http://localhost:5173/admin" -ForegroundColor Yellow
Write-Host "  4. Vous devriez voir un message d'accès refusé puis être redirigé" -ForegroundColor Yellow
Write-Host ""
Write-Host "  TEST 3 - TECHNICIEN:" -ForegroundColor White
Write-Host "  1. Connectez-vous avec: technicien1@gmail.com / password" -ForegroundColor Yellow
Write-Host "  2. Vous devriez être sur: http://localhost:5173/technical" -ForegroundColor Cyan
Write-Host "  3. Essayez d'accéder à: http://localhost:5173/admin" -ForegroundColor Yellow
Write-Host "  4. Vous devriez voir un message d'accès refusé puis être redirigé" -ForegroundColor Yellow
Write-Host ""
Write-Host "  TEST 4 - RH:" -ForegroundColor White
Write-Host "  1. Connectez-vous avec: rh1@gmail.com / password" -ForegroundColor Yellow
Write-Host "  2. Vous devriez être sur: http://localhost:5173/hr" -ForegroundColor Cyan
Write-Host "  3. Essayez d'accéder à: http://localhost:5173/admin" -ForegroundColor Yellow
Write-Host "  4. Vous devriez voir un message d'accès refusé puis être redirigé" -ForegroundColor Yellow
Write-Host ""
Write-Host "  ROUTES PROTEGEES:" -ForegroundColor White
Write-Host "  - /admin : ADMIN uniquement" -ForegroundColor Gray
Write-Host "  - /client : CLIENT uniquement" -ForegroundColor Gray
Write-Host "  - /technical : TECHNICIEN uniquement" -ForegroundColor Gray
Write-Host "  - /hr : RH uniquement" -ForegroundColor Gray
Write-Host "  - /supervisor : SUPERVISOR uniquement" -ForegroundColor Gray
Write-Host ""
Write-Host "  ROUTES PARTAGEES:" -ForegroundColor White
Write-Host "  - /bills : ADMIN, CLIENT, RH" -ForegroundColor Gray
Write-Host "  - /consumption : ADMIN, CLIENT, TECHNICIEN" -ForegroundColor Gray
Write-Host "  - /claims : ADMIN, CLIENT, RH, TECHNICIEN" -ForegroundColor Gray
Write-Host "  - /chatbot : Tous les rôles" -ForegroundColor Gray
Write-Host "  - /users : ADMIN uniquement" -ForegroundColor Gray
Write-Host "  - /meters : ADMIN, TECHNICIEN" -ForegroundColor Gray
Write-Host ""
