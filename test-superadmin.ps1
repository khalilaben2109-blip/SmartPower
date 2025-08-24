Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "  TEST DU COMPTE SUPERADMIN" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Test de connexion backend..." -ForegroundColor Cyan
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Test du compte superadmin..." -ForegroundColor Cyan

# Test avec le mot de passe "admin"
try {
    $body = @{
        email = "superadmin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    
    $responseData = $response.Content | ConvertFrom-Json
    Write-Host "  SUCCES: Role = $($responseData.role)" -ForegroundColor Green
    Write-Host "  Token: $($responseData.token.Substring(0, 20))..." -ForegroundColor Gray
} catch {
    Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "3. Test avec mauvais mot de passe..." -ForegroundColor Cyan

# Test avec un mauvais mot de passe
try {
    $body = @{
        email = "superadmin@gmail.com"
        password = "wrongpassword"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "  PROBLEME: Mauvais mot de passe accepte!" -ForegroundColor Red
} catch {
    Write-Host "  SUCCES: Mauvais mot de passe correctement rejete" -ForegroundColor Green
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Si le test reussit, le probleme de cryptage est completement resolu!" -ForegroundColor White
Write-Host ""
