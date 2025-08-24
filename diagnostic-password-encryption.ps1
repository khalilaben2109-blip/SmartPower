Write-Host "=============================================" -ForegroundColor Red
Write-Host "  DIAGNOSTIC DU PROBLEME DE CRYPTAGE" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Red
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
Write-Host "2. Test de creation d'un compte avec mot de passe simple..." -ForegroundColor Yellow

# Créer un compte de test avec mot de passe simple
$testAccount = @{
    email = "test-encryption@gmail.com"
    password = "test123"
    nom = "Test"
    prenom = "Encryption"
    role = "ADMIN"
    telephone = "+33000000000"
}

try {
    Write-Host "Creation du compte test..." -ForegroundColor Yellow
    $body = $testAccount | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "  SUCCES: Compte cree!" -ForegroundColor Green
} catch {
    Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Test d'authentification avec le mot de passe original..." -ForegroundColor Yellow

try {
    $loginBody = @{
        email = "test-encryption@gmail.com"
        password = "test123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    Write-Host "  SUCCES: Authentification reussie!" -ForegroundColor Green
} catch {
    Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  -> PROBLEME DE CRYPTAGE CONFIRME!" -ForegroundColor Red
}

Write-Host ""
Write-Host "4. Test avec differents mots de passe..." -ForegroundColor Yellow

$testPasswords = @("test123", "password", "admin", "123456")

foreach ($password in $testPasswords) {
    try {
        $loginBody = @{
            email = "test-encryption@gmail.com"
            password = $password
        } | ConvertTo-Json
        
        $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 5
        Write-Host "  SUCCES avec '$password'" -ForegroundColor Green
    } catch {
        Write-Host "  ECHEC avec '$password'" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Red
Write-Host "  DIAGNOSTIC TERMINE" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Red
Write-Host ""
Write-Host "Si plusieurs mots de passe fonctionnent, il y a un probleme de cryptage!" -ForegroundColor Yellow
Write-Host ""
