Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST DU ROUTAGE ET DES ROLES" -ForegroundColor Green
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
Write-Host "2. Test d'authentification avec admin..." -ForegroundColor Yellow

$loginBody = @{
    email = "admin@gmail.com"
    password = "password"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    $loginData = $loginResponse.Content | ConvertFrom-Json
    
    Write-Host "  Authentification reussie!" -ForegroundColor Green
    Write-Host "  Role backend: $($loginData.role)" -ForegroundColor Gray
    Write-Host "  Nom: $($loginData.nom) $($loginData.prenom)" -ForegroundColor Gray
    Write-Host "  Email: $($loginData.email)" -ForegroundColor Gray
    
} catch {
    Write-Host "  Echec: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "3. Instructions pour tester le routage:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  POUR TESTER LE ROUTAGE:" -ForegroundColor White
Write-Host "  1. Ouvrez: http://localhost:5173" -ForegroundColor Cyan
Write-Host "  2. Connectez-vous avec admin@gmail.com / password" -ForegroundColor Yellow
Write-Host "  3. Vous devriez voir l'interface ADMIN avec les onglets" -ForegroundColor Yellow
Write-Host "  4. Cliquez sur 'Gestion Utilisateurs' pour tester" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Si le routage ne fonctionne pas:" -ForegroundColor White
Write-Host "  - Appuyez sur Ctrl + F5 pour forcer le rechargement" -ForegroundColor Yellow
Write-Host "  - Ou videz le cache du navigateur" -ForegroundColor Yellow
Write-Host "  - Ou redemarrez le frontend" -ForegroundColor Yellow
Write-Host ""
Write-Host "  ROUTES ATTENDUES:" -ForegroundColor White
Write-Host "  - ADMIN: /admin (avec onglets Tableau de Bord + Gestion Utilisateurs)" -ForegroundColor Gray
Write-Host "  - CLIENT: /client (interface client)" -ForegroundColor Gray
Write-Host "  - TECHNICIEN: /technical (interface technicien)" -ForegroundColor Gray
Write-Host "  - RH: /hr (interface RH)" -ForegroundColor Gray
Write-Host ""
