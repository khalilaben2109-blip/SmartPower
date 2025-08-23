Write-Host "========================================" -ForegroundColor Green
Write-Host "  DEMARRAGE COMPLET DE SMARTPOWER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Fonction pour tester la connexion
function Test-BackendConnection {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 5
        return $true
    } catch {
        return $false
    }
}

# Fonction pour créer les comptes de test
function Create-TestAccounts {
    try {
        Write-Host "Creation des comptes de test..." -ForegroundColor Yellow
        $body = @{
            email = "admin@example.com"
            password = "password"
            nom = "Administrateur"
            prenom = "Principal"
            role = "ADMIN"
            telephone = "+33123456789"
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json"
        Write-Host "Compte admin cree avec succes!" -ForegroundColor Green
        
        $body = @{
            email = "client@example.com"
            password = "password"
            nom = "Dupont"
            prenom = "Jean"
            role = "CLIENT"
            telephone = "+33987654321"
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json"
        Write-Host "Compte client cree avec succes!" -ForegroundColor Green
        
        $body = @{
            email = "technical@example.com"
            password = "password"
            nom = "Durand"
            prenom = "Pierre"
            role = "TECHNICIEN"
            telephone = "+33555555555"
        } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/register" -Method POST -Body $body -ContentType "application/json"
        Write-Host "Compte technicien cree avec succes!" -ForegroundColor Green
        
    } catch {
        Write-Host "Erreur lors de la creation des comptes: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "1. Demarrage du Backend Spring Boot..." -ForegroundColor Yellow
$backendJob = Start-Job -ScriptBlock {
    Set-Location "C:\Users\pc\Desktop\Projet Stage 2.0\THE NEW BACKEND\THE NEW BACKEND"
    mvn spring-boot:run
}

Write-Host "2. Attente du demarrage du backend..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
do {
    Start-Sleep -Seconds 2
    $attempt++
    Write-Host "Tentative $attempt/$maxAttempts..." -ForegroundColor Gray
} while (-not (Test-BackendConnection) -and $attempt -lt $maxAttempts)

if (Test-BackendConnection) {
    Write-Host "Backend demarre avec succes!" -ForegroundColor Green
    
    Write-Host "3. Creation des comptes de test..." -ForegroundColor Yellow
    Create-TestAccounts
    
    Write-Host "4. Demarrage du Frontend React..." -ForegroundColor Yellow
    $frontendJob = Start-Job -ScriptBlock {
        Set-Location "C:\Users\pc\Desktop\Projet Stage 2.0\New FrontEnd\project"
        pnpm dev
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   APPLICATIONS DEMARREES !" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Backend:  http://localhost:8081" -ForegroundColor Cyan
    Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Comptes de test:" -ForegroundColor White
    Write-Host "- admin@example.com / password" -ForegroundColor Gray
    Write-Host "- client@example.com / password" -ForegroundColor Gray
    Write-Host "- technical@example.com / password" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Test de connexion:" -ForegroundColor Yellow
    Write-Host "curl -X POST http://localhost:8081/api/auth/login -H \"Content-Type: application/json\" -d '{\"email\":\"admin@example.com\",\"password\":\"password\"}'" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Appuyez sur une touche pour arrêter les applications..." -ForegroundColor Red
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    Stop-Job $backendJob, $frontendJob
    Remove-Job $backendJob, $frontendJob
} else {
    Write-Host "Erreur: Le backend n'a pas pu demarrer dans le delai imparti" -ForegroundColor Red
    Stop-Job $backendJob
    Remove-Job $backendJob
}
