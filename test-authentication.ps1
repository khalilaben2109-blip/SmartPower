Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST D'AUTHENTIFICATION DES COMPTES" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Liste des comptes à tester
$testAccounts = @(
    @{ email = "admin@gmail.com"; password = "password" },
    @{ email = "client@gmail.com"; password = "password" },
    @{ email = "technical@gmail.com"; password = "password" },
    @{ email = "hr@gmail.com"; password = "password" },
    @{ email = "supervisor@gmail.com"; password = "password" },
    @{ email = "admin@example.com"; password = "password" },
    @{ email = "client@example.com"; password = "password" },
    @{ email = "technicien@example.com"; password = "password" },
    @{ email = "rh@example.com"; password = "password" },
    @{ email = "admin"; password = "admin" },
    @{ email = "admin@gmail.com"; password = "admin" }
)

foreach ($account in $testAccounts) {
    try {
        Write-Host "Test de connexion avec $($account.email)..." -ForegroundColor Yellow
        
        $body = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        if ($response.StatusCode -eq 200) {
            $responseData = $response.Content | ConvertFrom-Json
            Write-Host "SUCCES: $($account.email) - Role: $($responseData.role)" -ForegroundColor Green
        } else {
            Write-Host "ECHEC: $($account.email) - Status: $($response.StatusCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "ECHEC: $($account.email) - Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "  FIN DES TESTS" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
