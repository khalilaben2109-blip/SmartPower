Write-Host "=============================================" -ForegroundColor Green
Write-Host "  PUSH VERS GITHUB - VERSION FINALE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Ajout de tous les fichiers modifiés..." -ForegroundColor Yellow
try {
    git add .
    Write-Host "   OK Tous les fichiers ajoutes" -ForegroundColor Green
} catch {
    Write-Host "   X Erreur lors de l'ajout des fichiers: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n2. Verification du statut..." -ForegroundColor Yellow
try {
    $status = git status --porcelain
    if ($status) {
        Write-Host "   Fichiers a commiter:" -ForegroundColor Gray
        $status | ForEach-Object { Write-Host "     $_" -ForegroundColor White }
    } else {
        Write-Host "   Aucun fichier a commiter" -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "   X Erreur lors de la verification du statut: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n3. Creation du commit..." -ForegroundColor Yellow
try {
    $commitMessage = "feat: Ajout fonctionnalité réclamations techniciens

- Ajout de la fonctionnalité pour que les techniciens puissent envoyer des réclamations aux RH et Admin
- Nouveau composant ReclamationModal pour la création de réclamations
- Nouvelle page TechnicienReclamationsPage pour la gestion des réclamations
- Service technicienService avec endpoints pour réclamations
- Contrôleur TechnicienController avec endpoints /api/technicien/destinataires et /api/technicien/reclamations
- Modification de l'entité Reclamation pour supporter les nouveaux champs
- Scripts de test et de configuration pour la base de données
- Amélioration du dashboard technique avec lien vers les réclamations

Fonctionnalités ajoutées:
- Récupération des destinataires (RH et Admin)
- Envoi de réclamations avec titre, description, catégorie, priorité
- Gestion des réclamations envoyées par les techniciens
- Interface utilisateur complète pour la gestion des réclamations"

    git commit -m $commitMessage
    Write-Host "   OK Commit cree avec succes" -ForegroundColor Green
} catch {
    Write-Host "   X Erreur lors de la creation du commit: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n4. Push vers GitHub..." -ForegroundColor Yellow
try {
    git push origin master
    Write-Host "   OK Push vers GitHub reussi!" -ForegroundColor Green
} catch {
    Write-Host "   X Erreur lors du push: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Essayez de pousser manuellement avec: git push origin master" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  PUSH TERMINE AVEC SUCCES!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nResume des modifications:" -ForegroundColor Yellow
Write-Host "- Fonctionnalite reclamations techniciens ajoutee" -ForegroundColor White
Write-Host "- Interface utilisateur complete" -ForegroundColor White
Write-Host "- Backend avec nouveaux endpoints" -ForegroundColor White
Write-Host "- Scripts de test et configuration" -ForegroundColor White
Write-Host "- Base de donnees mise a jour" -ForegroundColor White

Write-Host "`nProchaines etapes:" -ForegroundColor Yellow
Write-Host "1. Testez la fonctionnalite sur http://localhost:5173" -ForegroundColor White
Write-Host "2. Connectez-vous en tant que technicien" -ForegroundColor White
Write-Host "3. Allez dans 'Mes Reclamations'" -ForegroundColor White
Write-Host "4. Testez l'envoi de reclamations" -ForegroundColor White
