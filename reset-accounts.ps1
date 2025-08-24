Write-Host "=============================================" -ForegroundColor Red
Write-Host "  REINITIALISATION COMPLETE DES COMPTES" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Red
Write-Host ""
Write-Host "ATTENTION: Ce script va supprimer TOUS les comptes existants!" -ForegroundColor Red
Write-Host ""

$confirmation = Read-Host "Etes-vous sur de vouloir continuer? (oui/non)"
if ($confirmation -ne "oui") {
    Write-Host "Operation annulee." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "1. Verification du backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas. Veuillez demarrer le backend d'abord." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Execution du script SQL..." -ForegroundColor Yellow
Write-Host "Veuillez executer le script 'reset-and-create-accounts.sql' dans pgAdmin" -ForegroundColor Cyan
Write-Host "Ou copiez-collez le contenu du fichier dans votre client SQL" -ForegroundColor Cyan
Write-Host ""

$wait = Read-Host "Appuyez sur Entree une fois le script SQL execute"

Write-Host ""
Write-Host "3. Test des nouveaux comptes..." -ForegroundColor Yellow

# Liste des nouveaux comptes
$newAccounts = @(
    @{ email = "admin@gmail.com"; password = "password"; role = "ADMIN" },
    @{ email = "superadmin@gmail.com"; password = "admin"; role = "ADMIN" },
    @{ email = "client1@gmail.com"; password = "password"; role = "CLIENT" },
    @{ email = "client2@gmail.com"; password = "password"; role = "CLIENT" },
    @{ email = "technicien1@gmail.com"; password = "password"; role = "TECHNICIEN" },
    @{ email = "technicien2@gmail.com"; password = "password"; role = "TECHNICIEN" },
    @{ email = "rh1@gmail.com"; password = "password"; role = "RH" },
    @{ email = "rh2@gmail.com"; password = "password"; role = "RH" },
    @{ email = "superviseur@gmail.com"; password = "password"; role = "ADMIN" }
)

$successCount = 0
foreach ($account in $newAccounts) {
    try {
        Write-Host "Test: $($account.email)..." -ForegroundColor Yellow
        
        $body = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        $responseData = $response.Content | ConvertFrom-Json
        Write-Host "  SUCCES: Role = $($responseData.role)" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "4. Mise a jour du frontend..." -ForegroundColor Yellow

# Mettre à jour le fichier LoginPage.tsx avec les nouveaux comptes
$loginPagePath = "New FrontEnd\project\src\pages\LoginPage.tsx"
if (Test-Path $loginPagePath) {
    Write-Host "Mise a jour du fichier LoginPage.tsx..." -ForegroundColor Cyan
    
    # Créer le contenu des nouveaux comptes
    $demoUsersContent = @"
  const demoUsers = [
    { email: 'admin@gmail.com', role: 'Admin Principal', password: 'password' },
    { email: 'superadmin@gmail.com', role: 'Super Admin', password: 'admin' },
    { email: 'client1@gmail.com', role: 'Client 1', password: 'password' },
    { email: 'client2@gmail.com', role: 'Client 2', password: 'password' },
    { email: 'technicien1@gmail.com', role: 'Technicien 1', password: 'password' },
    { email: 'technicien2@gmail.com', role: 'Technicien 2', password: 'password' },
    { email: 'rh1@gmail.com', role: 'RH 1', password: 'password' },
    { email: 'rh2@gmail.com', role: 'RH 2', password: 'password' },
    { email: 'superviseur@gmail.com', role: 'Superviseur', password: 'password' }
  ];
"@

    # Lire le fichier actuel
    $content = Get-Content $loginPagePath -Raw
    
    # Remplacer la section demoUsers
    $pattern = 'const demoUsers = \[[\s\S]*?\];'
    $content = $content -replace $pattern, $demoUsersContent
    
    # Sauvegarder le fichier
    Set-Content $loginPagePath $content -Encoding UTF8
    Write-Host "Fichier LoginPage.tsx mis a jour!" -ForegroundColor Green
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  REINITIALISATION TERMINEE!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Comptes crees: $successCount/$($newAccounts.Count)" -ForegroundColor White
Write-Host ""
Write-Host "Nouveaux comptes disponibles:" -ForegroundColor White
Write-Host "  ADMIN:" -ForegroundColor Cyan
Write-Host "    admin@gmail.com / password" -ForegroundColor Gray
Write-Host "    superadmin@gmail.com / admin" -ForegroundColor Gray
Write-Host "    superviseur@gmail.com / password" -ForegroundColor Gray
Write-Host "  CLIENT:" -ForegroundColor Cyan
Write-Host "    client1@gmail.com / password" -ForegroundColor Gray
Write-Host "    client2@gmail.com / password" -ForegroundColor Gray
Write-Host "  TECHNICIEN:" -ForegroundColor Cyan
Write-Host "    technicien1@gmail.com / password" -ForegroundColor Gray
Write-Host "    technicien2@gmail.com / password" -ForegroundColor Gray
Write-Host "  RH:" -ForegroundColor Cyan
Write-Host "    rh1@gmail.com / password" -ForegroundColor Gray
Write-Host "    rh2@gmail.com / password" -ForegroundColor Gray
Write-Host ""
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "Backend: http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
