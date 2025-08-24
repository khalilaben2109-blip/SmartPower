Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CREATION DE COMPTES AVEC BONS MOTS DE PASSE" -ForegroundColor Green
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
Write-Host "2. Creation des comptes avec les bons mots de passe..." -ForegroundColor Yellow

# Créer les comptes avec les bons mots de passe
$accounts = @(
    @{
        email = "admin2@gmail.com"
        password = "password"
        nom = "Admin"
        prenom = "Principal"
        role = "ADMIN"
        telephone = "+33123456789"
    },
    @{
        email = "superadmin2@gmail.com"
        password = "admin"
        nom = "Super"
        prenom = "Admin"
        role = "ADMIN"
        telephone = "+33123456788"
    },
    @{
        email = "client3@gmail.com"
        password = "password"
        nom = "Dupont"
        prenom = "Jean"
        role = "CLIENT"
        telephone = "+33987654321"
    },
    @{
        email = "client4@gmail.com"
        password = "password"
        nom = "Martin"
        prenom = "Sophie"
        role = "CLIENT"
        telephone = "+33987654322"
    },
    @{
        email = "technicien3@gmail.com"
        password = "password"
        nom = "Durand"
        prenom = "Pierre"
        role = "TECHNICIEN"
        telephone = "+33555555551"
    },
    @{
        email = "technicien4@gmail.com"
        password = "password"
        nom = "Leroy"
        prenom = "Michel"
        role = "TECHNICIEN"
        telephone = "+33555555552"
    },
    @{
        email = "rh3@gmail.com"
        password = "password"
        nom = "Bernard"
        prenom = "Marie"
        role = "RH"
        telephone = "+33444444441"
    },
    @{
        email = "rh4@gmail.com"
        password = "password"
        nom = "Petit"
        prenom = "Claire"
        role = "RH"
        telephone = "+33444444442"
    },
    @{
        email = "superviseur2@gmail.com"
        password = "password"
        nom = "Moreau"
        prenom = "Paul"
        role = "ADMIN"
        telephone = "+33666666666"
    }
)

$successCount = 0
foreach ($account in $accounts) {
    try {
        Write-Host "Creation du compte $($account.email)..." -ForegroundColor Yellow
        
        $body = $account | ConvertTo-Json
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        Write-Host "  SUCCES: Compte cree!" -ForegroundColor Green
        $successCount++
    } catch {
        if ($_.Exception.Response.StatusCode -eq 409) {
            Write-Host "  INFO: Compte existe deja" -ForegroundColor Yellow
        } else {
            Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "3. Test des nouveaux comptes..." -ForegroundColor Yellow

$testCount = 0
foreach ($account in $accounts) {
    try {
        Write-Host "Test: $($account.email) avec '$($account.password)'..." -ForegroundColor Yellow
        
        $body = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        
        $responseData = $response.Content | ConvertFrom-Json
        Write-Host "  SUCCES: Role = $($responseData.role)" -ForegroundColor Green
        $testCount++
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
    { email: 'admin2@gmail.com', role: 'Admin Principal', password: 'password' },
    { email: 'superadmin2@gmail.com', role: 'Super Admin', password: 'admin' },
    { email: 'client3@gmail.com', role: 'Client 1', password: 'password' },
    { email: 'client4@gmail.com', role: 'Client 2', password: 'password' },
    { email: 'technicien3@gmail.com', role: 'Technicien 1', password: 'password' },
    { email: 'technicien4@gmail.com', role: 'Technicien 2', password: 'password' },
    { email: 'rh3@gmail.com', role: 'RH 1', password: 'password' },
    { email: 'rh4@gmail.com', role: 'RH 2', password: 'password' },
    { email: 'superviseur2@gmail.com', role: 'Superviseur', password: 'password' }
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
Write-Host "  CREATION TERMINEE!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Comptes crees: $successCount/$($accounts.Count)" -ForegroundColor White
Write-Host "Comptes testes: $testCount/$($accounts.Count)" -ForegroundColor White
Write-Host ""
Write-Host "Nouveaux comptes avec bons mots de passe:" -ForegroundColor White
Write-Host "  ADMIN:" -ForegroundColor Cyan
Write-Host "    admin2@gmail.com / password" -ForegroundColor Gray
Write-Host "    superadmin2@gmail.com / admin" -ForegroundColor Gray
Write-Host "    superviseur2@gmail.com / password" -ForegroundColor Gray
Write-Host "  CLIENT:" -ForegroundColor Cyan
Write-Host "    client3@gmail.com / password" -ForegroundColor Gray
Write-Host "    client4@gmail.com / password" -ForegroundColor Gray
Write-Host "  TECHNICIEN:" -ForegroundColor Cyan
Write-Host "    technicien3@gmail.com / password" -ForegroundColor Gray
Write-Host "    technicien4@gmail.com / password" -ForegroundColor Gray
Write-Host "  RH:" -ForegroundColor Cyan
Write-Host "    rh3@gmail.com / password" -ForegroundColor Gray
Write-Host "    rh4@gmail.com / password" -ForegroundColor Gray
Write-Host ""
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "Backend: http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
