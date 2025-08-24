Write-Host "Debug detaille du backend..." -ForegroundColor Green
Write-Host ""

# Test avec le compte CLIENT
Write-Host "=== TEST CLIENT ===" -ForegroundColor Yellow
try {
    $body = @{
        email = "client@example.com"
        password = "password"
    } | ConvertTo-Json
    
    Write-Host "Envoi de la requete..." -ForegroundColor Cyan
    Write-Host "URL: http://localhost:8081/api/auth/login" -ForegroundColor Cyan
    Write-Host "Body: $body" -ForegroundColor Cyan
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    
    Write-Host "SUCCES!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
    
} catch {
    Write-Host "ERREUR!" -ForegroundColor Red
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

Write-Host ""
Write-Host "=== TEST ADMIN (pour comparaison) ===" -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    Write-Host "Envoi de la requete..." -ForegroundColor Cyan
    Write-Host "Body: $body" -ForegroundColor Cyan
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    
    Write-Host "SUCCES!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
    
} catch {
    Write-Host "ERREUR ADMIN: $($_.Exception.Message)" -ForegroundColor Red
}
