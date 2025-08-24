Write-Host "Test direct du backend..." -ForegroundColor Green
Write-Host ""

# Test 1: Vérifier si le backend répond
Write-Host "=== TEST 1: Ping du backend ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 10
    Write-Host "SUCCES! Backend répond" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "ERREUR! Backend ne répond pas" -ForegroundColor Red
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 2: Vérifier les utilisateurs existants
Write-Host "=== TEST 2: Utilisateurs existants ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/existing/getExistingAccounts" -Method GET -TimeoutSec 10
    Write-Host "SUCCES! Récupération des comptes" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "ERREUR! Impossible de récupérer les comptes" -ForegroundColor Red
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Test de login avec admin (qui fonctionne)
Write-Host "=== TEST 3: Login admin (référence) ===" -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "SUCCES! Login admin" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "ERREUR! Login admin échoué" -ForegroundColor Red
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Test de login avec client (qui échoue)
Write-Host "=== TEST 4: Login client (problématique) ===" -ForegroundColor Yellow
try {
    $body = @{
        email = "client@example.com"
        password = "password"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "SUCCES! Login client" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "ERREUR! Login client échoué" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
    
    # Essayer de récupérer le contenu de l'erreur
    try {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $errorContent = $reader.ReadToEnd()
        Write-Host "Contenu de l'erreur: $errorContent" -ForegroundColor Red
    } catch {
        Write-Host "Impossible de lire le contenu de l'erreur" -ForegroundColor Red
    }
}
