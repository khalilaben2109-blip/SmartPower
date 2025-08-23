Write-Host "Test d'authentification frontend..." -ForegroundColor Green

# Test direct de l'API backend
Write-Host "1. Test direct de l'API backend..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
    $responseData = $response.Content | ConvertFrom-Json
    
    Write-Host "✅ API Backend fonctionne!" -ForegroundColor Green
    Write-Host "Token: $($responseData.token.Substring(0,20))..." -ForegroundColor Cyan
    Write-Host "Email: $($responseData.email)" -ForegroundColor Cyan
    Write-Host "Role: $($responseData.role)" -ForegroundColor Cyan
    Write-Host "Nom: $($responseData.nom)" -ForegroundColor Cyan
    Write-Host "Prénom: $($responseData.prenom)" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Erreur API Backend: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "2. Test du frontend..." -ForegroundColor Yellow
Write-Host "Ouvrez http://localhost:5173 dans votre navigateur" -ForegroundColor Cyan
Write-Host "Connectez-vous avec: admin@gmail.com / admin" -ForegroundColor Cyan
Write-Host ""

Write-Host "3. Si l'authentification échoue toujours:" -ForegroundColor Yellow
Write-Host "   - Ouvrez les outils de développement (F12)" -ForegroundColor White
Write-Host "   - Allez dans l'onglet Console" -ForegroundColor White
Write-Host "   - Allez dans l'onglet Network" -ForegroundColor White
Write-Host "   - Essayez de vous connecter et regardez les requêtes" -ForegroundColor White
Write-Host ""
