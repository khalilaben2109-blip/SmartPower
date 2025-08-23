Write-Host "=============================================" -ForegroundColor Green
Write-Host "  GENERATION DU BON HASH BCrypt" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Test d'authentification avec l'API backend pour générer le hash
Write-Host "1. Génération du hash BCrypt via l'API..." -ForegroundColor Yellow
try {
    $body = @{
        email = "admin@gmail.com"
        password = "admin"
        nom = "aziz"
        prenom = "kimouli"
        role = "ADMIN"
        telephone = "0798522325"
    } | ConvertTo-Json
    
    # Utiliser l'endpoint de test pour obtenir le hash encodé
    $hashResponse = Invoke-WebRequest -Uri "http://localhost:8081/api/existing/fix-passwords" -Method POST -TimeoutSec 5
    $hashData = $hashResponse.Content | ConvertFrom-Json
    
    Write-Host "✅ Hash BCrypt généré!" -ForegroundColor Green
    Write-Host "Hash: $($hashData.encoded_password)" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "2. Script SQL à exécuter dans pgAdmin:" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Gray
    Write-Host "-- Mise à jour avec le bon hash" -ForegroundColor White
    Write-Host "UPDATE public.utilisateurs" -ForegroundColor White
    Write-Host "SET mot_de_passe = '$($hashData.encoded_password)'" -ForegroundColor Cyan
    Write-Host "WHERE email = 'admin@gmail.com';" -ForegroundColor White
    Write-Host ""
    Write-Host "-- Vérification" -ForegroundColor White
    Write-Host "SELECT id, email, nom, prenom, LEFT(mot_de_passe, 20) || '...' as hash_debut" -ForegroundColor White
    Write-Host "FROM public.utilisateurs WHERE email = 'admin@gmail.com';" -ForegroundColor White
    Write-Host "=============================================" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Erreur lors de la génération du hash" -ForegroundColor Red
    Write-Host "Message d'erreur: $($_.Exception.Message)" -ForegroundColor Red
    
    # Hash BCrypt par défaut pour "admin"
    Write-Host ""
    Write-Host "3. Utilisation du hash par défaut:" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Gray
    Write-Host "-- Hash BCrypt pour 'admin'" -ForegroundColor White
    Write-Host "UPDATE public.utilisateurs" -ForegroundColor White
    Write-Host "SET mot_de_passe = '\$2a\$10\$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa'" -ForegroundColor Cyan
    Write-Host "WHERE email = 'admin@gmail.com';" -ForegroundColor White
    Write-Host "=============================================" -ForegroundColor Gray
}

Write-Host ""
Write-Host "4. Après avoir exécuté le script SQL:" -ForegroundColor Yellow
Write-Host "   - Redémarrez le backend" -ForegroundColor White
Write-Host "   - Testez avec: admin@gmail.com / admin" -ForegroundColor White
Write-Host ""
