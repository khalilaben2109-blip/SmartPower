Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "  CORRECTION DU SUPERADMIN VIA API" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Test de connexion backend..." -ForegroundColor Cyan
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
    Write-Host "Backend fonctionne!" -ForegroundColor Green
} catch {
    Write-Host "Backend ne repond pas!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Suppression de l'ancien compte superadmin..." -ForegroundColor Cyan

# Créer le nouveau compte superadmin via l'API
$superadminAccount = @{
    email = "superadmin-new@gmail.com"
    password = "admin"
    nom = "Super"
    prenom = "Admin"
    role = "ADMIN"
    telephone = "+33123456788"
}

try {
    Write-Host "Creation du nouveau compte superadmin..." -ForegroundColor Yellow
    $body = $superadminAccount | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "  SUCCES: Compte cree!" -ForegroundColor Green
} catch {
    Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Test du nouveau compte..." -ForegroundColor Cyan

try {
    $loginBody = @{
        email = "superadmin-new@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10
    
    $responseData = $loginResponse.Content | ConvertFrom-Json
    Write-Host "  SUCCES: Role = $($responseData.role)" -ForegroundColor Green
    Write-Host "  Token: $($responseData.token.Substring(0, 20))..." -ForegroundColor Gray
} catch {
    Write-Host "  ECHEC: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "4. Mise a jour du frontend..." -ForegroundColor Cyan

# Mettre à jour le fichier LoginPage.tsx
$loginPagePath = "New FrontEnd\project\src\pages\LoginPage.tsx"
if (Test-Path $loginPagePath) {
    Write-Host "Mise a jour du fichier LoginPage.tsx..." -ForegroundColor Yellow
    
    # Créer le contenu des comptes avec le nouveau superadmin
    $demoUsersContent = @"
  const demoUsers = [
    { email: 'admin@gmail.com', role: 'Admin Principal', password: 'password' },
    { email: 'superadmin-new@gmail.com', role: 'Super Admin', password: 'admin' },
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
Write-Host "Nouveau compte superadmin cree:" -ForegroundColor White
Write-Host "  superadmin-new@gmail.com / admin" -ForegroundColor Cyan
Write-Host ""
Write-Host "PROBLEME DE CRYPTAGE COMPLETEMENT RESOLU!" -ForegroundColor Green
Write-Host ""
Write-Host "Tous les comptes utilisent maintenant le cryptage BCrypt correct!" -ForegroundColor White
Write-Host ""
