Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CREATION COMPTE TECHNICIEN CORRECT" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Creation du compte Technicien..." -ForegroundColor Yellow
try {
    $techData = @{
        nom = "Technicien"
        prenom = "Test"
        email = "technicien@gmail.com"
        password = "password"
        role = "TECHNICIEN"
        telephone = "01 23 45 67 89"
    } | ConvertTo-Json

    Write-Host "   Donnees envoyees: $techData" -ForegroundColor Gray

    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $techData -ContentType "application/json" -TimeoutSec 10
    
    Write-Host "   Status Code: $($response.StatusCode)" -ForegroundColor Gray
    Write-Host "   Reponse: $($response.Content)" -ForegroundColor Gray
    
    if ($response.StatusCode -eq 200) {
        Write-Host "   OK Technicien cree" -ForegroundColor Green
    } else {
        Write-Host "   X Echec creation technicien" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur creation technicien: $($_.Exception.Message)" -ForegroundColor Red
    
    # Afficher les détails de l'erreur
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Details erreur: $errorBody" -ForegroundColor Red
    }
}

Write-Host "`n2. Test d'authentification..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "technicien@gmail.com"
        password = "password"
    } | ConvertTo-Json

    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    
    if ($loginResponse.StatusCode -eq 200) {
        $loginData = $loginResponse.Content | ConvertFrom-Json
        Write-Host "   OK Authentification reussie" -ForegroundColor Green
        Write-Host "   Role: $($loginData.role)" -ForegroundColor Gray
        Write-Host "   Token: $($loginData.token.Substring(0, 20))..." -ForegroundColor Gray
    } else {
        Write-Host "   X Echec authentification" -ForegroundColor Red
        Write-Host "   Reponse: $($loginResponse.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur authentification: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  CREATION TERMINEE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
