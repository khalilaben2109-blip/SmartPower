Write-Host "=============================================" -ForegroundColor Green
Write-Host "  DIAGNOSTIC ET CORRECTION AUTHENTIFICATION" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Test si le backend répond
Write-Host "1. Test de connexion backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "✅ Backend répond!" -ForegroundColor Green
    $backendOk = $true
} catch {
    Write-Host "❌ Backend ne répond pas. Veuillez le démarrer d'abord." -ForegroundColor Red
    $backendOk = $false
}

if ($backendOk) {
    # Test des comptes existants
    Write-Host "2. Vérification du compte admin..." -ForegroundColor Yellow
    try {
        $testLogin = Invoke-WebRequest -Uri "http://localhost:8081/api/existing/test-login" -Method GET -TimeoutSec 5
        $response = $testLogin.Content | ConvertFrom-Json
        
        Write-Host "Email: $($response.admin_email)" -ForegroundColor Cyan
        Write-Host "Nom: $($response.admin_nom)" -ForegroundColor Cyan
        Write-Host "Prénom: $($response.admin_prenom)" -ForegroundColor Cyan
        Write-Host "Mot de passe encodé: $($response.password_encoded)" -ForegroundColor Cyan
        Write-Host "Admin existe: $($response.admin_exists)" -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ Erreur lors de la vérification du compte" -ForegroundColor Red
    }

    # Test d'authentification avec "admin"
    Write-Host "3. Test d'authentification avec mot de passe 'admin'..." -ForegroundColor Yellow
    try {
        $body = @{
            email = "admin@gmail.com"
            password = "admin"
        } | ConvertTo-Json
        
        $login = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
        $loginResponse = $login.Content | ConvertFrom-Json
        Write-Host "✅ Authentification réussie!" -ForegroundColor Green
        Write-Host "Token: $($loginResponse.token.Substring(0,20))..." -ForegroundColor Cyan
        Write-Host "Rôle: $($loginResponse.role)" -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ Échec de l'authentification avec 'admin'" -ForegroundColor Red
        
        # Essayons avec le mot de passe original de la base
        Write-Host "4. Test avec d'autres mots de passe possibles..." -ForegroundColor Yellow
        
        $passwords = @("admin", "kimouli", "aziz", "password", "123456", "admin123")
        
        foreach ($pwd in $passwords) {
            try {
                Write-Host "   Test avec: '$pwd'..." -ForegroundColor Gray
                $bodyTest = @{
                    email = "admin@gmail.com"
                    password = $pwd
                } | ConvertTo-Json
                
                $loginTest = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $bodyTest -ContentType "application/json" -TimeoutSec 3
                $loginTestResponse = $loginTest.Content | ConvertFrom-Json
                Write-Host "✅ TROUVÉ! Le mot de passe est: '$pwd'" -ForegroundColor Green
                Write-Host "Token: $($loginTestResponse.token.Substring(0,20))..." -ForegroundColor Cyan
                break
                
            } catch {
                Write-Host "   ❌ '$pwd' ne fonctionne pas" -ForegroundColor DarkRed
            }
        }
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  INSTRUCTIONS FINALES" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Si aucun mot de passe ne fonctionne:" -ForegroundColor Yellow
Write-Host "1. Exécutez le script SQL fix-admin-password-final.sql dans pgAdmin" -ForegroundColor White
Write-Host "2. Redémarrez le backend" -ForegroundColor White
Write-Host "3. Utilisez: admin@gmail.com / admin" -ForegroundColor White
Write-Host ""
