Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST SIMPLE RECLAMATION" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# 1. Test de l'authentification
Write-Host "`n1. Authentification technicien..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "technicien@gmail.com"
        password = "password"
    } | ConvertTo-Json

    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    
    if ($loginResponse.StatusCode -eq 200) {
        $loginData = $loginResponse.Content | ConvertFrom-Json
        $token = $loginData.token
        Write-Host "   OK Authentification reussie" -ForegroundColor Green
    } else {
        Write-Host "   X Echec authentification" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "   X Erreur authentification: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 2. Test simple d'envoi de réclamation
Write-Host "`n2. Test envoi reclamation simple..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    # Données de test minimales
    $reclamationData = @{
        titre = "Test simple"
        description = "Description test"
        categorie = "TECHNIQUE"
        destinataireId = 1
        typeDestinataire = "RH"
        priorite = 2
    } | ConvertTo-Json

    Write-Host "   Envoi des donnees: $reclamationData" -ForegroundColor Gray
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/reclamations" -Method POST -Body $reclamationData -Headers $headers -TimeoutSec 10
    
    Write-Host "   Status Code: $($response.StatusCode)" -ForegroundColor Gray
    Write-Host "   Reponse: $($response.Content)" -ForegroundColor Gray
    
    if ($response.StatusCode -eq 200) {
        Write-Host "   OK Reclamation envoyee avec succes!" -ForegroundColor Green
    } else {
        Write-Host "   X Echec envoi reclamation" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de l'envoi: $($_.Exception.Message)" -ForegroundColor Red
    
    # Afficher les détails de l'erreur
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Details erreur: $errorBody" -ForegroundColor Red
    }
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
