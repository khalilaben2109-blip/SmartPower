Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST CONNEXION ADMIN" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Test connexion Admin..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "admin@gmail.com"
        password = "password"
    } | ConvertTo-Json

    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    
    if ($loginResponse.StatusCode -eq 200) {
        $loginData = $loginResponse.Content | ConvertFrom-Json
        $token = $loginData.token
        Write-Host "   OK Connexion admin reussie" -ForegroundColor Green
        Write-Host "   Role: $($loginData.role)" -ForegroundColor Gray
        
        # Test de récupération des destinataires avec le token admin
        Write-Host "`n2. Test recuperation destinataires (avec admin)..." -ForegroundColor Yellow
        $headers = @{
            "Authorization" = "Bearer $token"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/destinataires" -Method GET -Headers $headers -TimeoutSec 10
        
        if ($response.StatusCode -eq 200) {
            $destinataires = $response.Content | ConvertFrom-Json
            Write-Host "   OK Destinataires recuperes" -ForegroundColor Green
            
            Write-Host "`n   RH disponibles:" -ForegroundColor Cyan
            foreach ($rh in $destinataires.rh) {
                Write-Host "     ID: $($rh.id) - $($rh.nom) $($rh.prenom) ($($rh.email))" -ForegroundColor White
            }
            
            Write-Host "`n   Admin disponibles:" -ForegroundColor Cyan
            foreach ($admin in $destinataires.admin) {
                Write-Host "     ID: $($admin.id) - $($admin.nom) $($admin.prenom) ($($admin.email))" -ForegroundColor White
            }
        } else {
            Write-Host "   X Echec recuperation destinataires" -ForegroundColor Red
            Write-Host "   Reponse: $($response.Content)" -ForegroundColor Red
        }
    } else {
        Write-Host "   X Echec connexion admin" -ForegroundColor Red
        Write-Host "   Reponse: $($loginResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur connexion admin: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
