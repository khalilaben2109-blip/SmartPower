Write-Host "=============================================" -ForegroundColor Green
Write-Host "  PUSH VERS GITHUB - SMARTPOWER" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Vérification du statut Git..." -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "2. Ajout de l'origine GitHub..." -ForegroundColor Yellow
Write-Host "Repository: https://github.com/khalilaben2109-blip/SmartPower.git" -ForegroundColor Cyan

# Ajouter l'origine GitHub
git remote add origin https://github.com/khalilaben2109-blip/SmartPower.git

Write-Host ""
Write-Host "3. Push vers GitHub..." -ForegroundColor Yellow
Write-Host "IMPORTANT: Vous devrez vous authentifier avec GitHub" -ForegroundColor Red
Write-Host ""

# Push vers GitHub
git push -u origin master

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  PROJET PUBLIÉ SUR GITHUB!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 URL du repository: https://github.com/khalilaben2109-blip/SmartPower" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Prochaines étapes:" -ForegroundColor White
Write-Host "1. Vérifier que le repository a été créé sur GitHub" -ForegroundColor Gray
Write-Host "2. Ajouter une description au repository" -ForegroundColor Gray
Write-Host "3. Configurer les topics et la visibilité" -ForegroundColor Gray
Write-Host ""
