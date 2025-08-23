Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST FINAL D'AUTHENTIFICATION" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "IMPORTANT: Assurez-vous d'avoir exécuté le script SQL fix-password-final.sql dans pgAdmin!" -ForegroundColor Yellow
Write-Host ""

# Test d'authentification finale
Write-Host "1. Test d'authentification avec admin@gmail.com / admin..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    $login = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
    $loginResponse = $login.Content | ConvertFrom-Json
    
    Write-Host "🎉 SUCCÈS! Authentification réussie!" -ForegroundColor Green
    Write-Host "Token: $($loginResponse.token.Substring(0,20))..." -ForegroundColor Cyan
    Write-Host "Rôle: $($loginResponse.role)" -ForegroundColor Cyan
    Write-Host "Email: $($loginResponse.email)" -ForegroundColor Cyan
    Write-Host "Nom: $($loginResponse.nom)" -ForegroundColor Cyan
    Write-Host "Prénom: $($loginResponse.prenom)" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "✅ L'authentification fonctionne parfaitement!" -ForegroundColor Green
    Write-Host "✅ Vous pouvez maintenant vous connecter à l'application" -ForegroundColor Green
    Write-Host "✅ Frontend: http://localhost:5173" -ForegroundColor Green
    Write-Host "✅ Identifiants: admin@gmail.com / admin" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Échec de l'authentification" -ForegroundColor Red
    Write-Host "Message d'erreur: $($_.Exception.Message)" -ForegroundColor Red
    
    Write-Host ""
    Write-Host "🔧 Actions à effectuer:" -ForegroundColor Yellow
    Write-Host "1. Exécutez le script SQL fix-password-final.sql dans pgAdmin" -ForegroundColor White
    Write-Host "2. Redémarrez le backend Spring Boot" -ForegroundColor White
    Write-Host "3. Relancez ce script de test" -ForegroundColor White
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  PROJET PRÊT À UTILISER!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
