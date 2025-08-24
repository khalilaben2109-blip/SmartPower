Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST D'AUTHENTIFICATION - TOUS LES COMPTES" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Liste des comptes à tester
$accounts = @(
    @{ email = "admin@gmail.com"; password = "admin"; role = "ADMIN" },
    @{ email = "client@example.com"; password = "password"; role = "CLIENT" },
    @{ email = "technicien@example.com"; password = "password"; role = "TECHNICIEN" },
    @{ email = "rh@example.com"; password = "password"; role = "RH" }
)

foreach ($account in $accounts) {
    Write-Host "Test d'authentification pour $($account.role)..." -ForegroundColor Yellow
    Write-Host "Email: $($account.email)" -ForegroundColor Cyan
    Write-Host "Mot de passe: $($account.password)" -ForegroundColor Cyan
    
    try {
        $body = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
        $responseData = $response.Content | ConvertFrom-Json
        
        Write-Host "✅ SUCCÈS! Authentification réussie pour $($account.role)" -ForegroundColor Green
        Write-Host "   Token: $($responseData.token.Substring(0,20))..." -ForegroundColor Gray
        Write-Host "   Rôle retourné: $($responseData.role)" -ForegroundColor Gray
        Write-Host "   Nom: $($responseData.nom) $($responseData.prenom)" -ForegroundColor Gray
        
    } catch {
        Write-Host "❌ ÉCHEC! Authentification échouée pour $($account.role)" -ForegroundColor Red
        Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "  RÉSUMÉ DES COMPTES DE TEST" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🔐 Comptes disponibles:" -ForegroundColor White
Write-Host "   👑 ADMIN:     admin@gmail.com / admin" -ForegroundColor Cyan
Write-Host "   👤 CLIENT:    client@example.com / password" -ForegroundColor Cyan
Write-Host "   🔧 TECHNICIEN: technicien@example.com / password" -ForegroundColor Cyan
Write-Host "   👥 RH:        rh@example.com / password" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Testez ces comptes sur: http://localhost:5173" -ForegroundColor Yellow
Write-Host ""
