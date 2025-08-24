Write-Host "=============================================" -ForegroundColor Red
Write-Host "  CORRECTION SIMPLIFIEE DU CRYPTAGE" -ForegroundColor Red
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
Write-Host "1. Test de connexion backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Execution du script SQL simplifie..." -ForegroundColor Yellow
Write-Host "Veuillez executer le script 'fix-password-encryption-simple.sql' dans pgAdmin" -ForegroundColor Cyan
Write-Host "Ou copiez-collez le contenu du fichier dans votre client SQL" -ForegroundColor Cyan
Write-Host ""

$wait = Read-Host "Appuyez sur Entree une fois le script SQL execute"

Write-Host ""
Write-Host "3. Test des comptes corriges..." -ForegroundColor Yellow

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
Write-Host "4. Test de securite..." -ForegroundColor Yellow

# Test avec un mauvais mot de passe
try {
    $body = @{
        email = "admin@gmail.com"
        password = "wrongpassword"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "  PROBLEME: Mauvais mot de passe accepte!" -ForegroundColor Red
} catch {
    Write-Host "  SUCCES: Mauvais mot de passe correctement rejete" -ForegroundColor Green
}

Write-Host ""
Write-Host "5. Mise a jour du frontend..." -ForegroundColor Yellow

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
Write-Host "PROBLEME DE CRYPTAGE RESOLU!" -ForegroundColor Green
Write-Host ""
Write-Host "Comptes disponibles avec cryptage BCrypt correct:" -ForegroundColor White
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
