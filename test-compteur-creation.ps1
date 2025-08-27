Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST CREATION COMPTEUR - DIAGNOSTIC" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# 1. Vérifier que le backend fonctionne
Write-Host "`n1. Test du backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "   OK Backend accessible (Status: $($ping.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "   X Backend non accessible" -ForegroundColor Red
    Write-Host "   Lancez d'abord le projet avec .\lance-projet.ps1" -ForegroundColor Yellow
    exit 1
}

# 2. Test de l'authentification technicien
Write-Host "`n2. Test de l'authentification technicien..." -ForegroundColor Yellow
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
        Write-Host "   Token: $($token.Substring(0, 20))..." -ForegroundColor Gray
    } else {
        Write-Host "   X Echec de l'authentification" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "   X Erreur lors de l'authentification: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 3. Test de l'endpoint des clients
Write-Host "`n3. Test de l'endpoint des clients..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $clientsResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/clients" -Method GET -Headers $headers -TimeoutSec 10
    
    if ($clientsResponse.StatusCode -eq 200) {
        $clients = $clientsResponse.Content | ConvertFrom-Json
        Write-Host "   OK Clients recuperes ($($clients.Count) clients)" -ForegroundColor Green
        if ($clients.Count -gt 0) {
            Write-Host "   Premier client: $($clients[0].nom) $($clients[0].prenom)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   X Echec de recuperation des clients" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la recuperation des clients: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Test de l'endpoint des compteurs
Write-Host "`n4. Test de l'endpoint des compteurs..." -ForegroundColor Yellow
try {
    $compteursResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/compteurs" -Method GET -Headers $headers -TimeoutSec 10
    
    if ($compteursResponse.StatusCode -eq 200) {
        $compteurs = $compteursResponse.Content | ConvertFrom-Json
        Write-Host "   OK Compteurs recuperes ($($compteurs.Count) compteurs)" -ForegroundColor Green
    } else {
        Write-Host "   X Echec de recuperation des compteurs" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la recuperation des compteurs: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. Test de création d'un compteur
Write-Host "`n5. Test de creation d'un compteur..." -ForegroundColor Yellow
try {
    $compteurData = @{
        numeroSerie = "TEST-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        typeCompteur = "MONOPHASE"
        typeAbonnement = "RESIDENTIEL"
        puissanceSouscrite = 6
        tension = 230
        phase = 1
        typeCompteurIntelligent = $false
        clientId = 1
    } | ConvertTo-Json

    $createResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/compteurs" -Method POST -Body $compteurData -Headers $headers -TimeoutSec 10
    
    if ($createResponse.StatusCode -eq 200) {
        $result = $createResponse.Content | ConvertFrom-Json
        Write-Host "   OK Compteur cree avec succes!" -ForegroundColor Green
        Write-Host "   ID: $($result.compteurId)" -ForegroundColor Gray
        Write-Host "   Numero de serie: $($result.numeroSerie)" -ForegroundColor Gray
    } else {
        Write-Host "   X Echec de creation du compteur" -ForegroundColor Red
        Write-Host "   Reponse: $($createResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la creation du compteur: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorContent = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorContent)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Details: $errorBody" -ForegroundColor Red
    }
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  DIAGNOSTIC TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nInstructions pour tester dans le frontend:" -ForegroundColor Yellow
Write-Host "1. Ouvrez http://localhost:5173" -ForegroundColor Cyan
Write-Host "2. Connectez-vous avec: technicien@gmail.com / password" -ForegroundColor White
Write-Host "3. Allez sur la page des compteurs" -ForegroundColor White
Write-Host "4. Cliquez sur 'Nouveau Compteur'" -ForegroundColor White
Write-Host "5. Remplissez le formulaire et soumettez" -ForegroundColor White
