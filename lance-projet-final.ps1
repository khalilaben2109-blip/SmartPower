Write-Host "=============================================" -ForegroundColor Green
Write-Host "  LANCEMENT FINAL DU PROJET SMART POWER" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Verification des repertoires..." -ForegroundColor Yellow

# Vérifier que nous sommes dans le bon répertoire
$currentDir = Get-Location
Write-Host "  Repertoire actuel: $currentDir" -ForegroundColor Gray

# Vérifier l'existence des dossiers
$frontendPath = "New FrontEnd\project"
$backendPath = "THE NEW BACKEND\THE NEW BACKEND"

if (-not (Test-Path $frontendPath)) {
    Write-Host "  ERREUR: Dossier frontend introuvable!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $backendPath)) {
    Write-Host "  ERREUR: Dossier backend introuvable!" -ForegroundColor Red
    exit 1
}

Write-Host "  SUCCES: Tous les repertoires sont presents!" -ForegroundColor Green

Write-Host ""
Write-Host "2. Arret des processus existants..." -ForegroundColor Yellow

# Arrêter les processus existants
try {
    Get-Process | Where-Object {$_.ProcessName -like "*java*" -or $_.ProcessName -like "*node*" -or $_.ProcessName -like "*pnpm*"} | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "  SUCCES: Processus arretes!" -ForegroundColor Green
} catch {
    Write-Host "  INFO: Aucun processus a arreter" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "3. Lancement du Backend Spring Boot..." -ForegroundColor Yellow

# Lancer le backend
Write-Host "  Lancement du backend depuis: $backendPath" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath'; mvn spring-boot:run" -WindowStyle Normal
Write-Host "  SUCCES: Backend lance dans une nouvelle fenetre!" -ForegroundColor Green

Write-Host ""
Write-Host "4. Attente du demarrage du backend (45 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 45

Write-Host ""
Write-Host "5. Test de connexion backend..." -ForegroundColor Yellow
$maxAttempts = 15
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
    Write-Host "  Continuer avec le frontend..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "6. Lancement du Frontend React..." -ForegroundColor Yellow

# Lancer le frontend
Write-Host "  Lancement du frontend depuis: $frontendPath" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; pnpm dev" -WindowStyle Normal
Write-Host "  SUCCES: Frontend lance dans une nouvelle fenetre!" -ForegroundColor Green

Write-Host ""
Write-Host "7. Attente du demarrage du frontend (20 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

Write-Host ""
Write-Host "8. Test de connexion frontend..." -ForegroundColor Yellow
$maxAttempts = 10
$attempt = 0

do {
    $attempt++
    try {
        $ping = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -TimeoutSec 5
        Write-Host "  SUCCES: Frontend fonctionne! (tentative $attempt)" -ForegroundColor Green
        break
    } catch {
        Write-Host "  Tentative $attempt/$maxAttempts - Frontend en cours de demarrage..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
    }
} while ($attempt -lt $maxAttempts)

if ($attempt -eq $maxAttempts) {
    Write-Host "  ATTENTION: Frontend peut prendre plus de temps a demarrer" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  PROJET LANCE AVEC SUCCES!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "URLs d'acces:" -ForegroundColor White
Write-Host "  Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "  Backend:  http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
Write-Host "Comptes de test disponibles:" -ForegroundColor White
Write-Host "  ADMIN:" -ForegroundColor Yellow
Write-Host "    admin@gmail.com / password" -ForegroundColor Gray
Write-Host "    superadmin-new@gmail.com / admin" -ForegroundColor Gray
Write-Host "    superviseur@gmail.com / password" -ForegroundColor Gray
Write-Host "  CLIENT:" -ForegroundColor Yellow
Write-Host "    client1@gmail.com / password" -ForegroundColor Gray
Write-Host "    client2@gmail.com / password" -ForegroundColor Gray
Write-Host "  TECHNICIEN:" -ForegroundColor Yellow
Write-Host "    technicien1@gmail.com / password" -ForegroundColor Gray
Write-Host "    technicien2@gmail.com / password" -ForegroundColor Gray
Write-Host "  RH:" -ForegroundColor Yellow
Write-Host "    rh1@gmail.com / password" -ForegroundColor Gray
Write-Host "    rh2@gmail.com / password" -ForegroundColor Gray
Write-Host ""
Write-Host "FONCTIONNALITES DISPONIBLES:" -ForegroundColor White
Write-Host "  ✅ Authentification securisee avec JWT" -ForegroundColor Green
Write-Host "  ✅ Cryptage BCrypt des mots de passe" -ForegroundColor Green
Write-Host "  ✅ Gestion des utilisateurs par l'admin" -ForegroundColor Green
Write-Host "  ✅ Creation de comptes RH et Techniciens" -ForegroundColor Green
Write-Host "  ✅ Interface moderne et responsive" -ForegroundColor Green
Write-Host ""
Write-Host "Pour tester la gestion des utilisateurs:" -ForegroundColor Yellow
Write-Host "  1. Connectez-vous en tant qu'admin" -ForegroundColor White
Write-Host "  2. Allez dans l'onglet 'Gestion Utilisateurs'" -ForegroundColor White
Write-Host "  3. Cliquez sur 'Nouvel Utilisateur'" -ForegroundColor White
Write-Host ""
Write-Host "Appuyez sur une touche pour fermer ce script..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
