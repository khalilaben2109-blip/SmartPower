Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST CREATION CLIENT - CRYPTAGE MOT DE PASSE" -ForegroundColor Green
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

# 3. Test de création d'un client
Write-Host "`n3. Test de creation d'un client..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $clientData = @{
        nom = "Test"
        prenom = "Client"
        email = "test.client.$(Get-Date -Format 'yyyyMMdd-HHmmss')@example.com"
        telephone = "01 23 45 67 89"
        adresse = "123 Rue de Test"
        ville = "Paris"
        codePostal = "75001"
        password = "motdepasse123"
    } | ConvertTo-Json

    $createResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/clients" -Method POST -Body $clientData -Headers $headers -TimeoutSec 10
    
    if ($createResponse.StatusCode -eq 200) {
        $result = $createResponse.Content | ConvertFrom-Json
        Write-Host "   OK Client cree avec succes!" -ForegroundColor Green
        Write-Host "   ID: $($result.clientId)" -ForegroundColor Gray
        Write-Host "   Nom: $($result.nom) $($result.prenom)" -ForegroundColor Gray
        Write-Host "   Email: $($result.email)" -ForegroundColor Gray
        Write-Host "   Mot de passe utilise: motdepasse123" -ForegroundColor Gray
    } else {
        Write-Host "   X Echec de creation du client" -ForegroundColor Red
        Write-Host "   Reponse: $($createResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la creation du client: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorContent = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorContent)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Details: $errorBody" -ForegroundColor Red
    }
}

# 4. Test de connexion avec le nouveau client
Write-Host "`n4. Test de connexion avec le nouveau client..." -ForegroundColor Yellow
try {
    $clientLoginBody = @{
        email = "test.client.$(Get-Date -Format 'yyyyMMdd-HHmmss')@example.com"
        password = "motdepasse123"
    } | ConvertTo-Json

    $clientLoginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $clientLoginBody -ContentType "application/json" -TimeoutSec 10
    
    if ($clientLoginResponse.StatusCode -eq 200) {
        $clientLoginData = $clientLoginResponse.Content | ConvertFrom-Json
        Write-Host "   OK Connexion reussie avec le nouveau client!" -ForegroundColor Green
        Write-Host "   Token client: $($clientLoginData.token.Substring(0, 20))..." -ForegroundColor Gray
    } else {
        Write-Host "   X Echec de connexion avec le nouveau client" -ForegroundColor Red
        Write-Host "   Reponse: $($clientLoginResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la connexion du client: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nInstructions pour verifier le cryptage:" -ForegroundColor Yellow
Write-Host "1. Ouvrez pgAdmin ou votre client SQL" -ForegroundColor Cyan
Write-Host "2. Connectez-vous a la base de donnees" -ForegroundColor White
Write-Host "3. Executez: SELECT email, mot_de_passe FROM clients WHERE email LIKE 'test.client%'" -ForegroundColor White
Write-Host "4. Verifiez que le mot de passe commence par '$2a$' (format BCrypt)" -ForegroundColor White
Write-Host "5. Le mot de passe ne doit PAS etre 'motdepasse123' en clair" -ForegroundColor White
