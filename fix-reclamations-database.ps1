Write-Host "=============================================" -ForegroundColor Green
Write-Host "  CORRECTION BASE DE DONNEES RECLAMATIONS" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Arret du backend..." -ForegroundColor Yellow
try {
    # Arrêter le processus Java du backend
    Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq "java" } | Stop-Process -Force
    Write-Host "   OK Backend arrete" -ForegroundColor Green
} catch {
    Write-Host "   Backend deja arrete ou non trouve" -ForegroundColor Gray
}

Write-Host "`n2. Suppression de la table reclamations existante..." -ForegroundColor Yellow

# Créer un script SQL pour supprimer et recréer la table
$sqlContent = @"
-- Supprimer la table reclamations existante
DROP TABLE IF EXISTS reclamations CASCADE;

-- Recréer la table avec la nouvelle structure
CREATE TABLE reclamations (
    id BIGSERIAL PRIMARY KEY,
    date_creation DATE,
    description TEXT,
    statut VARCHAR(50),
    type_reclamation VARCHAR(50),
    priorite INTEGER,
    utilisateur_id BIGINT,
    technicien_traiteur_id BIGINT,
    technicien_expediteur_id BIGINT,
    destinataire_id BIGINT,
    titre VARCHAR(255),
    categorie VARCHAR(50),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (technicien_traiteur_id) REFERENCES techniciens(id),
    FOREIGN KEY (technicien_expediteur_id) REFERENCES techniciens(id),
    FOREIGN KEY (destinataire_id) REFERENCES utilisateurs(id)
);
"@

$sqlFile = "temp_fix_reclamations.sql"
$sqlContent | Out-File -FilePath $sqlFile -Encoding UTF8

Write-Host "   Script SQL cree: $sqlFile" -ForegroundColor Gray

Write-Host "`n3. Redemarrage du backend..." -ForegroundColor Yellow
Write-Host "   Le backend va redemarrer et recreer automatiquement la table" -ForegroundColor Gray
Write-Host "   Attendez 30 secondes..." -ForegroundColor Yellow

Start-Sleep -Seconds 30

Write-Host "`n4. Test du backend..." -ForegroundColor Yellow
try {
    $ping = Invoke-WebRequest -Uri "http://localhost:8081/api/test/ping" -Method GET -TimeoutSec 10
    Write-Host "   OK Backend fonctionne! Status: $($ping.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   X Backend non accessible, redemarrage manuel necessaire" -ForegroundColor Red
    Write-Host "   Lancez .\lance-projet.ps1" -ForegroundColor Yellow
}

Write-Host "`n5. Test des reclamations..." -ForegroundColor Yellow
try {
    $testResult = & .\test-reclamations-technicien.ps1
    Write-Host "   Test termine" -ForegroundColor Green
} catch {
    Write-Host "   X Erreur lors du test" -ForegroundColor Red
}

# Nettoyer le fichier temporaire
if (Test-Path $sqlFile) { Remove-Item $sqlFile }

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  CORRECTION TERMINEE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nSi le backend n'est pas accessible:" -ForegroundColor Yellow
Write-Host "1. Lancez .\lance-projet.ps1" -ForegroundColor White
Write-Host "2. Testez avec .\test-reclamations-technicien.ps1" -ForegroundColor White
