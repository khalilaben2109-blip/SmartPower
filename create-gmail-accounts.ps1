Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CREATION DES COMPTES DE TEST GMAIL" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Verifier que le backend est en cours d'execution
Write-Host "1. Verification du backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas. Veuillez demarrer le backend d'abord." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Creation des comptes de test..." -ForegroundColor Yellow

# Creer les comptes via l'API
$accounts = @(
    @{
        email = "admin@gmail.com"
        password = "password"
        nom = "Admin"
        prenom = "Principal"
        role = "ADMIN"
        telephone = "+33123456789"
    },
    @{
        email = "client@gmail.com"
        password = "password"
        nom = "Dupont"
        prenom = "Jean"
        role = "CLIENT"
        telephone = "+33987654321"
    },
    @{
        email = "technical@gmail.com"
        password = "password"
        nom = "Durand"
        prenom = "Pierre"
        role = "TECHNICIEN"
        telephone = "+33555555555"
    },
    @{
        email = "hr@gmail.com"
        password = "password"
        nom = "Bernard"
        prenom = "Sophie"
        role = "RH"
        telephone = "+33444444444"
    },
    @{
        email = "supervisor@gmail.com"
        password = "password"
        nom = "Martin"
        prenom = "Paul"
        role = "ADMIN"
        telephone = "+33666666666"
    }
)

foreach ($account in $accounts) {
    try {
        $body = $account | ConvertTo-Json
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        Write-Host "Compte $($account.email) cree avec succes!" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 409) {
            Write-Host "Compte $($account.email) existe deja" -ForegroundColor Yellow
        } else {
            Write-Host "Erreur lors de la creation du compte $($account.email): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "3. Test d'authentification..." -ForegroundColor Yellow

# Tester l'authentification avec un compte
try {
    $loginBody = @{
        email = "admin@gmail.com"
        password = "password"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "Authentification reussie!" -ForegroundColor Green
} catch {
    Write-Host "Erreur d'authentification: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  COMPTES DE TEST CREES AVEC SUCCES!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Comptes disponibles:" -ForegroundColor White
Write-Host "   admin@gmail.com / password" -ForegroundColor Gray
Write-Host "   client@gmail.com / password" -ForegroundColor Gray
Write-Host "   technical@gmail.com / password" -ForegroundColor Gray
Write-Host "   hr@gmail.com / password" -ForegroundColor Gray
Write-Host "   supervisor@gmail.com / password" -ForegroundColor Gray
Write-Host ""
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "Backend: http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
