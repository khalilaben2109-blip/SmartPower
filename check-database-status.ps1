Write-Host "=============================================" -ForegroundColor Green
Write-Host "  VERIFICATION DE LA BASE DE DONNEES" -ForegroundColor Green
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
Write-Host "2. Test des comptes problematiques..." -ForegroundColor Yellow

# Test des comptes qui ne fonctionnent pas
$problemAccounts = @(
    @{ email = "admin@gmail.com"; password = "password" },
    @{ email = "client@example.com"; password = "password" },
    @{ email = "technicien@example.com"; password = "password" },
    @{ email = "rh@example.com"; password = "password" }
)

foreach ($account in $problemAccounts) {
    try {
        Write-Host "Test: $($account.email) avec '$($account.password)'..." -ForegroundColor Yellow
        
        $body = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        Write-Host "  Reponse: $($response.Content)" -ForegroundColor Green
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Host "  Erreur: $errorMessage" -ForegroundColor Red
        
        # Analyser l'erreur
        if ($errorMessage -like "*400*") {
            Write-Host "  -> Erreur 400: Demande incorrecte (email ou mot de passe invalide)" -ForegroundColor Red
        } elseif ($errorMessage -like "*404*") {
            Write-Host "  -> Erreur 404: Compte non trouve" -ForegroundColor Red
        } elseif ($errorMessage -like "*401*") {
            Write-Host "  -> Erreur 401: Non autorise (mot de passe incorrect)" -ForegroundColor Red
        }
    }
    Write-Host ""
}

Write-Host "3. Test des comptes qui fonctionnent..." -ForegroundColor Yellow

# Test des comptes qui fonctionnent
$workingAccounts = @(
    @{ email = "admin@gmail.com"; password = "admin" },
    @{ email = "client@gmail.com"; password = "password" },
    @{ email = "technical@gmail.com"; password = "password" }
)

foreach ($account in $workingAccounts) {
    try {
        Write-Host "Test: $($account.email) avec '$($account.password)'..." -ForegroundColor Yellow
        
        $body = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        $responseData = $response.Content | ConvertFrom-Json
        Write-Host "  SUCCES: Role = $($responseData.role)" -ForegroundColor Green
    } catch {
        Write-Host "  Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "  ANALYSE TERMINEE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
