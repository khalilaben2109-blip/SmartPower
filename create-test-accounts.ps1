Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CREATION COMPTES DE TEST" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Creation du compte Admin..." -ForegroundColor Yellow
try {
    $adminData = @{
        nom = "Admin"
        prenom = "Principal"
        email = "admin@gmail.com"
        password = "password"
        role = "ADMIN"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $adminData -ContentType "application/json" -TimeoutSec 10
    
    if ($response.StatusCode -eq 200) {
        Write-Host "   OK Admin cree" -ForegroundColor Green
    } else {
        Write-Host "   X Echec creation admin" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur creation admin: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n2. Creation du compte Technicien..." -ForegroundColor Yellow
try {
    $techData = @{
        nom = "Technicien"
        prenom = "Test"
        email = "technicien@gmail.com"
        password = "password"
        role = "TECHNICAL"
        telephone = "01 23 45 67 89"
        specialite = "Electricite"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $techData -ContentType "application/json" -TimeoutSec 10
    
    if ($response.StatusCode -eq 200) {
        Write-Host "   OK Technicien cree" -ForegroundColor Green
    } else {
        Write-Host "   X Echec creation technicien" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur creation technicien: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n3. Creation du compte RH..." -ForegroundColor Yellow
try {
    $rhData = @{
        nom = "RH"
        prenom = "Test"
        email = "rh@gmail.com"
        password = "password"
        role = "RH"
        telephone = "01 23 45 67 90"
        departement = "Ressources Humaines"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $rhData -ContentType "application/json" -TimeoutSec 10
    
    if ($response.StatusCode -eq 200) {
        Write-Host "   OK RH cree" -ForegroundColor Green
    } else {
        Write-Host "   X Echec creation RH" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur creation RH: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n4. Creation du compte Client..." -ForegroundColor Yellow
try {
    $clientData = @{
        nom = "Client"
        prenom = "Test"
        email = "client@gmail.com"
        password = "password"
        role = "CLIENT"
        telephone = "01 23 45 67 91"
        adresse = "123 Rue de Test"
        ville = "Paris"
        codePostal = "75001"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $clientData -ContentType "application/json" -TimeoutSec 10
    
    if ($response.StatusCode -eq 200) {
        Write-Host "   OK Client cree" -ForegroundColor Green
    } else {
        Write-Host "   X Echec creation client" -ForegroundColor Red
    }
} catch {
    Write-Host "   X Erreur creation client: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  CREATION TERMINEE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nComptes crees:" -ForegroundColor Yellow
Write-Host "- Admin: admin@gmail.com / password" -ForegroundColor White
Write-Host "- Technicien: technicien@gmail.com / password" -ForegroundColor White
Write-Host "- RH: rh@gmail.com / password" -ForegroundColor White
Write-Host "- Client: client@gmail.com / password" -ForegroundColor White

Write-Host "`nTestez maintenant avec .\test-get-rh.ps1" -ForegroundColor Yellow
