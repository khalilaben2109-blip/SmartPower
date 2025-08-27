Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST RECUPERATION RH" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# 1. Authentification
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

# 2. Récupérer les destinataires
Write-Host "`n2. Recuperation des destinataires..." -ForegroundColor Yellow
try {
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
        
        # Utiliser le premier RH disponible pour le test
        if ($destinataires.rh.Count -gt 0) {
            $firstRh = $destinataires.rh[0]
            Write-Host "`n   Premier RH disponible: ID=$($firstRh.id)" -ForegroundColor Yellow
            
            # Test d'envoi avec le bon ID
            Write-Host "`n3. Test envoi avec le bon ID..." -ForegroundColor Yellow
            $reclamationData = @{
                titre = "Test avec bon ID"
                description = "Description test avec ID correct"
                categorie = "TECHNIQUE"
                destinataireId = $firstRh.id
                typeDestinataire = "RH"
                priorite = 2
            } | ConvertTo-Json

            Write-Host "   Envoi des donnees: $reclamationData" -ForegroundColor Gray
            
            $sendResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/reclamations" -Method POST -Body $reclamationData -Headers $headers -TimeoutSec 10
            
            Write-Host "   Status Code: $($sendResponse.StatusCode)" -ForegroundColor Gray
            Write-Host "   Reponse: $($sendResponse.Content)" -ForegroundColor Gray
            
            if ($sendResponse.StatusCode -eq 200) {
                Write-Host "   OK Reclamation envoyee avec succes!" -ForegroundColor Green
            } else {
                Write-Host "   X Echec envoi reclamation" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "   X Echec recuperation destinataires" -ForegroundColor Red
        Write-Host "   Reponse: $($response.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la recuperation: $($_.Exception.Message)" -ForegroundColor Red
    
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
