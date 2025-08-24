Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CORRECTION DES MOTS DE PASSE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Test de connexion backend
Write-Host "1. Test de connexion backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Execution du script SQL..." -ForegroundColor Yellow
Write-Host "Veuillez executer le script 'fix-all-passwords.sql' dans pgAdmin" -ForegroundColor Cyan
Write-Host "Ou copiez-collez le contenu du fichier dans votre client SQL" -ForegroundColor Cyan
Write-Host ""

$wait = Read-Host "Appuyez sur Entree une fois le script SQL execute"

Write-Host ""
Write-Host "3. Test des mots de passe corriges..." -ForegroundColor Yellow

# Test des comptes avec les bons mots de passe
$testAccounts = @(
    @{ email = "admin@gmail.com"; password = "password"; expectedRole = "ADMIN" },
    @{ email = "superadmin@gmail.com"; password = "admin"; expectedRole = "ADMIN" },
    @{ email = "client1@gmail.com"; password = "password"; expectedRole = "CLIENT" },
    @{ email = "client2@gmail.com"; password = "password"; expectedRole = "CLIENT" },
    @{ email = "technicien1@gmail.com"; password = "password"; expectedRole = "TECHNICIEN" },
    @{ email = "technicien2@gmail.com"; password = "password"; expectedRole = "TECHNICIEN" },
    @{ email = "rh1@gmail.com"; password = "password"; expectedRole = "RH" },
    @{ email = "rh2@gmail.com"; password = "password"; expectedRole = "RH" },
    @{ email = "superviseur@gmail.com"; password = "password"; expectedRole = "ADMIN" }
)

$successCount = 0
foreach ($account in $testAccounts) {
    try {
        Write-Host "Test: $($account.email) avec '$($account.password)'..." -ForegroundColor Yellow
        
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

# Mettre à jour le fichier LoginPage.tsx
$loginPagePath = "New FrontEnd\project\src\pages\LoginPage.tsx"
if (Test-Path $loginPagePath) {
    Write-Host "Mise a jour du fichier LoginPage.tsx..." -ForegroundColor Cyan
    
    # Créer le contenu des comptes corrigés
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
Write-Host "  CORRECTION TERMINEE!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Comptes testes: $successCount/$($testAccounts.Count)" -ForegroundColor White
Write-Host ""
Write-Host "Mots de passe corriges:" -ForegroundColor White
Write-Host "  • Tous les comptes utilisent 'password'" -ForegroundColor Gray
Write-Host "  • Sauf superadmin@gmail.com qui utilise 'admin'" -ForegroundColor Gray
Write-Host ""
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "Backend: http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
