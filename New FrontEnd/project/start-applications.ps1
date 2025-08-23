Write-Host "========================================" -ForegroundColor Green
Write-Host "  DEMARRAGE DE L'APPLICATION SMARTPOWER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Demarrage du Backend Spring Boot..." -ForegroundColor Yellow
$backendJob = Start-Job -ScriptBlock {
    Set-Location "C:\Users\pc\Desktop\Projet Stage 2.0\THE NEW BACKEND\THE NEW BACKEND"
    mvn spring-boot:run
}

Write-Host "2. Attente du demarrage du backend..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host "3. Demarrage du Frontend React..." -ForegroundColor Yellow
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

Write-Host "Appuyez sur une touche pour arrêter les applications..." -ForegroundColor Red
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Stop-Job $backendJob, $frontendJob
Remove-Job $backendJob, $frontendJob
