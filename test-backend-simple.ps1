Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST BACKEND SIMPLE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Test ping backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 10
    Write-Host "   OK Backend accessible! Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   X Backend non accessible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n2. Test endpoint destinataires..." -ForegroundColor Yellow
try {
    # D'abord se connecter
    $loginBody = @{
        email = "admin@gmail.com"
        password = "password"
    } | ConvertTo-Json

    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    
    if ($loginResponse.StatusCode -eq 200) {
        $loginData = $loginResponse.Content | ConvertFrom-Json
        $token = $loginData.token
        Write-Host "   OK Connexion reussie" -ForegroundColor Green
        
        # Test endpoint destinataires
        $headers = @{
            "Authorization" = "Bearer $token"
            "Content-Type" = "application/json"
        }
        
        $destResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/destinataires" -Method GET -Headers $headers -TimeoutSec 10
        Write-Host "   OK Endpoint destinataires accessible! Status: $($destResponse.StatusCode)" -ForegroundColor Green
        Write-Host "   Reponse: $($destResponse.Content)" -ForegroundColor Gray
    } else {
        Write-Host "   X Echec connexion" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur test destinataires: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
