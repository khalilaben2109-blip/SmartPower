Write-Host "=============================================" -ForegroundColor Green
Write-Host "  MISE A JOUR BASE DE DONNEES RECLAMATIONS" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Configuration de la base de données
$dbHost = "localhost"
$dbPort = "5432"
$dbName = "smartpower"
$dbUser = "postgres"
$dbPassword = "password"

Write-Host "`n1. Connexion a la base de donnees..." -ForegroundColor Yellow

try {
    # Créer le fichier temporaire avec les commandes SQL
    $sqlFile = "temp_update_reclamations.sql"
    
    # Copier le contenu du fichier SQL vers le fichier temporaire
    Copy-Item "update-reclamations-table.sql" $sqlFile
    
    # Exécuter les commandes SQL via psql
    $env:PGPASSWORD = $dbPassword
    $result = & psql -h $dbHost -p $dbPort -d $dbName -U $dbUser -f $sqlFile 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   OK Base de donnees mise a jour avec succes!" -ForegroundColor Green
    } else {
        Write-Host "   X Erreur lors de la mise a jour: $result" -ForegroundColor Red
    }
    
} catch {
    Write-Host "   X Erreur de connexion a la base de donnees: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Verifiez que PostgreSQL est demarre et accessible" -ForegroundColor Yellow
}

Write-Host "`n2. Verification de la structure..." -ForegroundColor Yellow

try {
    # Vérifier la structure de la table
    $checkQuery = @"
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'reclamations'
ORDER BY ordinal_position;
"@
    
    $checkFile = "temp_check_structure.sql"
    $checkQuery | Out-File -FilePath $checkFile -Encoding UTF8
    
    $structure = & psql -h $dbHost -p $dbPort -d $dbName -U $dbUser -f $checkFile 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   OK Structure de la table reclamations:" -ForegroundColor Green
        Write-Host $structure -ForegroundColor Gray
    } else {
        Write-Host "   X Erreur lors de la verification: $structure" -ForegroundColor Red
    }
    
    # Nettoyer les fichiers temporaires
    if (Test-Path $checkFile) { Remove-Item $checkFile }
    if (Test-Path $sqlFile) { Remove-Item $sqlFile }
    
} catch {
    Write-Host "   X Erreur lors de la verification: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  MISE A JOUR TERMINEE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nInstructions suivantes:" -ForegroundColor Yellow
Write-Host "1. Redemarrez le backend si necessaire" -ForegroundColor White
Write-Host "2. Testez les reclamations avec .\test-reclamations-technicien.ps1" -ForegroundColor White
