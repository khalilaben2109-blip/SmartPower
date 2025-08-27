Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST RECLAMATIONS TECHNICIEN" -ForegroundColor Green
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

# 3. Test de récupération des destinataires
Write-Host "`n3. Test de recuperation des destinataires..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $destinatairesResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/destinataires" -Method GET -Headers $headers -TimeoutSec 10
    
    if ($destinatairesResponse.StatusCode -eq 200) {
        $destinataires = $destinatairesResponse.Content | ConvertFrom-Json
        Write-Host "   OK Destinataires recuperes" -ForegroundColor Green
        Write-Host "   RH disponibles: $($destinataires.rh.Count)" -ForegroundColor Gray
        Write-Host "   Admin disponibles: $($destinataires.admin.Count)" -ForegroundColor Gray
        
        if ($destinataires.rh.Count -eq 0 -and $destinataires.admin.Count -eq 0) {
            Write-Host "   ⚠️  Aucun destinataire disponible" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   X Echec de recuperation des destinataires" -ForegroundColor Red
        Write-Host "   Reponse: $($destinatairesResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la recuperation des destinataires: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Test d'envoi d'une réclamation
Write-Host "`n4. Test d'envoi d'une reclamation..." -ForegroundColor Yellow
try {
    # Récupérer d'abord les destinataires pour avoir un ID valide
    $destinatairesResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/destinataires" -Method GET -Headers $headers -TimeoutSec 10
    $destinataires = $destinatairesResponse.Content | ConvertFrom-Json
    
    $destinataireId = $null
    $typeDestinataire = $null
    
    if ($destinataires.rh.Count -gt 0) {
        $destinataireId = $destinataires.rh[0].id
        $typeDestinataire = "RH"
        Write-Host "   Utilisation d'un RH comme destinataire" -ForegroundColor Gray
    } elseif ($destinataires.admin.Count -gt 0) {
        $destinataireId = $destinataires.admin[0].id
        $typeDestinataire = "ADMIN"
        Write-Host "   Utilisation d'un Admin comme destinataire" -ForegroundColor Gray
    } else {
        Write-Host "   X Aucun destinataire disponible pour le test" -ForegroundColor Red
        exit 1
    }
    
    $reclamationData = @{
        titre = "Test de réclamation - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        description = "Ceci est un test de réclamation envoyée par un technicien pour vérifier le bon fonctionnement du système."
        categorie = "TECHNIQUE"
        destinataireId = $destinataireId
        typeDestinataire = $typeDestinataire
        priorite = 2
    } | ConvertTo-Json

    $reclamationResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/reclamations" -Method POST -Body $reclamationData -Headers $headers -TimeoutSec 10
    
    if ($reclamationResponse.StatusCode -eq 200) {
        $result = $reclamationResponse.Content | ConvertFrom-Json
        Write-Host "   OK Reclamation envoyee avec succes!" -ForegroundColor Green
        Write-Host "   ID: $($result.reclamationId)" -ForegroundColor Gray
        Write-Host "   Titre: $($result.titre)" -ForegroundColor Gray
        Write-Host "   Destinataire: $($result.destinataire)" -ForegroundColor Gray
    } else {
        Write-Host "   X Echec d'envoi de la reclamation" -ForegroundColor Red
        Write-Host "   Reponse: $($reclamationResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de l'envoi de la reclamation: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorContent = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorContent)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Details: $errorBody" -ForegroundColor Red
    }
}

# 5. Test de récupération des réclamations envoyées
Write-Host "`n5. Test de recuperation des reclamations envoyees..." -ForegroundColor Yellow
try {
    $reclamationsResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/technicien/reclamations" -Method GET -Headers $headers -TimeoutSec 10
    
    if ($reclamationsResponse.StatusCode -eq 200) {
        $reclamations = $reclamationsResponse.Content | ConvertFrom-Json
        Write-Host "   OK Reclamations recuperees" -ForegroundColor Green
        Write-Host "   Nombre de reclamations: $($reclamations.Count)" -ForegroundColor Gray
        
        if ($reclamations.Count -gt 0) {
            Write-Host "   Derniere reclamation:" -ForegroundColor Gray
            $lastReclamation = $reclamations[0]
            Write-Host "     - Titre: $($lastReclamation.titre)" -ForegroundColor Gray
            Write-Host "     - Statut: $($lastReclamation.statut)" -ForegroundColor Gray
            Write-Host "     - Destinataire: $($lastReclamation.destinataire)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   X Echec de recuperation des reclamations" -ForegroundColor Red
        Write-Host "   Reponse: $($reclamationsResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur lors de la recuperation des reclamations: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nInstructions pour tester dans le frontend:" -ForegroundColor Yellow
Write-Host "1. Ouvrez http://localhost:5173" -ForegroundColor Cyan
Write-Host "2. Connectez-vous avec: technicien@gmail.com / password" -ForegroundColor White
Write-Host "3. Cliquez sur 'Mes Réclamations' dans le dashboard" -ForegroundColor White
Write-Host "4. Cliquez sur 'Nouvelle Réclamation'" -ForegroundColor White
Write-Host "5. Remplissez le formulaire et envoyez la réclamation" -ForegroundColor White
