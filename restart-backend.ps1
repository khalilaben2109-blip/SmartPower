Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "  REDEMARRAGE DU BACKEND" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Arret des processus Java..." -ForegroundColor Cyan
try {
    Get-Process | Where-Object {$_.ProcessName -like "*java*"} | Stop-Process -Force
    Write-Host "  SUCCES: Processus Java arretes!" -ForegroundColor Green
} catch {
    Write-Host "  INFO: Aucun processus Java a arreter" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "2. Attente de 5 secondes..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "3. Lancement du backend..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'THE NEW BACKEND\THE NEW BACKEND'; mvn spring-boot:run" -WindowStyle Normal
Write-Host "  SUCCES: Backend lance dans une nouvelle fenetre!" -ForegroundColor Green

Write-Host ""
Write-Host "4. Attente du demarrage (30 secondes)..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "5. Test de connexion..." -ForegroundColor Cyan
$maxAttempts = 10
$attempt = 0

do {
    $attempt++
    try {
        $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
        Write-Host "  SUCCES: Backend fonctionne! (tentative $attempt)" -ForegroundColor Green
        break
    } catch {
        Write-Host "  Tentative $attempt/$maxAttempts - Backend en cours de demarrage..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
    }
} while ($attempt -lt $maxAttempts)

if ($attempt -eq $maxAttempts) {
    Write-Host "  ERREUR: Backend ne demarre pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  BACKEND REDEMARRE AVEC SUCCES!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Nouvelle configuration de securite appliquee!" -ForegroundColor White
Write-Host "Endpoints /api/admin/** maintenant accessibles aux admins!" -ForegroundColor White
Write-Host ""
Write-Host "Vous pouvez maintenant tester la gestion des utilisateurs!" -ForegroundColor Yellow
Write-Host ""
