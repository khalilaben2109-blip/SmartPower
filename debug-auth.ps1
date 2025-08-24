Write-Host "Debug de l'authentification..." -ForegroundColor Green
Write-Host ""

# Test avec le compte RH qui échoue
Write-Host "Test detaille pour RH..." -ForegroundColor Yellow
try {
    $body = @{
        email = "rh@example.com"
        password = "password"
    } | ConvertTo-Json
    
    Write-Host "Body envoye: $body" -ForegroundColor Cyan
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
    
} catch {
    Write-Host "Erreur detaillee:" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
    
    # Essayer de récupérer le contenu de l'erreur
    try {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $errorContent = $reader.ReadToEnd()
        Write-Host "Contenu de l'erreur: $errorContent" -ForegroundColor Red
    } catch {
        Write-Host "Impossible de lire le contenu de l'erreur" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Test avec admin (qui fonctionne) pour comparaison..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
    } | ConvertTo-Json
    
    Write-Host "Body envoye: $body" -ForegroundColor Cyan
    
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
    
} catch {
    Write-Host "Erreur admin: $($_.Exception.Message)" -ForegroundColor Red
}
