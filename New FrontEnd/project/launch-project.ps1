Write-Host "=============================================" -ForegroundColor Green
Write-Host "  LANCEMENT DU PROJET SMARTPOWER" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Test de connexion backend
Write-Host "1. Test de connexion backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "✅ Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend ne répond pas. Démarrage..." -ForegroundColor Red
    Write-Host "Démarrage du backend en arrière-plan..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit -Command `"Set-Location 'C:\Users\pc\Desktop\Projet Stage 2.0\THE NEW BACKEND\THE NEW BACKEND'; mvn spring-boot:run`"" -WindowStyle Hidden
    Write-Host "Attente du démarrage du backend..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
}

# Test d'authentification
Write-Host "2. Test d'authentification..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    $login = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-Host "✅ Authentification OK!" -ForegroundColor Green
} catch {
    Write-Host "❌ Problème d'authentification" -ForegroundColor Red
    Write-Host "Exécutez le script SQL fix-password-final.sql dans pgAdmin" -ForegroundColor Yellow
}

# Démarrage du frontend
Write-Host "3. Démarrage du frontend React..." -ForegroundColor Yellow
Write-Host "Ouverture du navigateur..." -ForegroundColor Cyan
Start-Process "http://localhost:5173"

# Démarrage du frontend en arrière-plan
Start-Process powershell -ArgumentList "-NoExit -Command `"Set-Location 'C:\Users\pc\Desktop\Projet Stage 2.0\New FrontEnd\project'; pnpm dev`"" -WindowStyle Hidden

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  PROJET LANCÉ AVEC SUCCÈS!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "🔧 Backend: http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
Write-Host "👤 Identifiants de connexion:" -ForegroundColor White
Write-Host "   Email: admin@gmail.com" -ForegroundColor Gray
Write-Host "   Mot de passe: admin" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ Le navigateur devrait s'ouvrir automatiquement!" -ForegroundColor Green
Write-Host ""
