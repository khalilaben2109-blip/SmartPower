Write-Host "=============================================" -ForegroundColor Green
Write-Host "  LANCEMENT DU PROJET SMART POWER" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Arrêter les processus existants
Write-Host "1. Arrêt des processus existants..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -like "*java*" -or $_.ProcessName -like "*node*" -or $_.ProcessName -like "*pnpm*"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Vérifier les chemins
$backendPath = "THE NEW BACKEND\THE NEW BACKEND"
$frontendPath = "New FrontEnd\project"

if (-not (Test-Path $backendPath)) {
    Write-Host "❌ Répertoire backend non trouvé: $backendPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $frontendPath)) {
    Write-Host "❌ Répertoire frontend non trouvé: $frontendPath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Chemins vérifiés" -ForegroundColor Green

# Lancer le backend
Write-Host ""
Write-Host "2. Lancement du backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\$backendPath'; Write-Host 'Lancement du backend...' -ForegroundColor Green; mvn spring-boot:run" -WindowStyle Normal

Write-Host "⏳ Attente du démarrage du backend (45 secondes)..." -ForegroundColor Cyan
Start-Sleep -Seconds 45

# Tester le backend
Write-Host "3. Test du backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 10
    Write-Host "✅ Backend fonctionne! Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend ne répond pas encore. Attente supplémentaire..." -ForegroundColor Red
    Start-Sleep -Seconds 15
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 10
        Write-Host "✅ Backend fonctionne maintenant! Status: $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Problème avec le backend. Vérifiez la fenêtre backend." -ForegroundColor Red
    }
}

# Lancer le frontend
Write-Host ""
Write-Host "4. Lancement du frontend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\$frontendPath'; Write-Host 'Lancement du frontend...' -ForegroundColor Green; pnpm dev" -WindowStyle Normal

Write-Host "⏳ Attente du démarrage du frontend (20 secondes)..." -ForegroundColor Cyan
Start-Sleep -Seconds 20

# Tester le frontend
Write-Host "5. Test du frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 10
    Write-Host "✅ Frontend fonctionne! Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend ne répond pas encore. Attente supplémentaire..." -ForegroundColor Red
    Start-Sleep -Seconds 10
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 10
        Write-Host "✅ Frontend fonctionne maintenant! Status: $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Problème avec le frontend. Vérifiez la fenêtre frontend." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  RÉSUMÉ" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "Backend:  http://localhost:8081" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "Comptes de test:" -ForegroundColor Yellow
Write-Host "- Admin: admin@gmail.com / password" -ForegroundColor White
Write-Host "- Client: client@gmail.com / password" -ForegroundColor White
Write-Host "- Technicien: technicien@gmail.com / password" -ForegroundColor White
Write-Host "- RH: rh@gmail.com / password" -ForegroundColor White
Write-Host ""
Write-Host "Ouvrez votre navigateur sur: http://localhost:5173" -ForegroundColor Green
Write-Host ""
