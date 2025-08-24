Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST DE TOUS LES MOTS DE PASSE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Test de connexion backend
Write-Host "1. Test de connexion backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Test des comptes avec differents mots de passe..." -ForegroundColor Yellow

# Liste des comptes à tester
$accounts = @(
    "admin@gmail.com",
    "superadmin@gmail.com", 
    "client1@gmail.com",
    "client2@gmail.com",
    "technicien1@gmail.com",
    "technicien2@gmail.com",
    "rh1@gmail.com",
    "rh2@gmail.com",
    "superviseur@gmail.com"
)

# Mots de passe à tester
$passwords = @("password", "admin", "123456", "test")

foreach ($email in $accounts) {
    Write-Host ""
    Write-Host "Test du compte: $email" -ForegroundColor Cyan
    
    $foundPassword = $false
    foreach ($password in $passwords) {
        try {
            $body = @{
                email = $email
                password = $password
            } | ConvertTo-Json
            
            $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
            
            if ($response.StatusCode -eq 200) {
                $responseData = $response.Content | ConvertFrom-Json
                Write-Host "  SUCCES avec '$password' - Role: $($responseData.role)" -ForegroundColor Green
                $foundPassword = $true
                break
            }
        } catch {
            # Erreur attendue pour les mauvais mots de passe
        }
    }
    
    if (-not $foundPassword) {
        Write-Host "  ECHEC: Aucun mot de passe ne fonctionne" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  FIN DES TESTS" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
