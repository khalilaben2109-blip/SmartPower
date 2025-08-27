Write-Host "=============================================" -ForegroundColor Green
Write-Host "  TEST FORMULAIRE DESTINATAIRES" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n1. Test avec des donnees simulees..." -ForegroundColor Yellow

# Données simulées de destinataires
$destinatairesSimules = @{
    rh = @(
        @{
            id = 1
            nom = "Dupont"
            prenom = "Marie"
            email = "marie.dupont@rh.com"
            type = "RH"
            departement = "Ressources Humaines"
        },
        @{
            id = 2
            nom = "Martin"
            prenom = "Jean"
            email = "jean.martin@rh.com"
            type = "RH"
            departement = "Formation"
        }
    )
    admin = @(
        @{
            id = 3
            nom = "Admin"
            prenom = "Principal"
            email = "admin@company.com"
            type = "ADMIN"
        },
        @{
            id = 4
            nom = "Super"
            prenom = "Admin"
            email = "superadmin@company.com"
            type = "ADMIN"
        }
    )
}

Write-Host "   RH disponibles:" -ForegroundColor Cyan
foreach ($rh in $destinatairesSimules.rh) {
    Write-Host "     ID: $($rh.id) - $($rh.nom) $($rh.prenom) ($($rh.email)) - $($rh.departement)" -ForegroundColor White
}

Write-Host "`n   Admin disponibles:" -ForegroundColor Cyan
foreach ($admin in $destinatairesSimules.admin) {
    Write-Host "     ID: $($admin.id) - $($admin.nom) $($admin.prenom) ($($admin.email))" -ForegroundColor White
}

Write-Host "`n2. Test d'envoi de reclamation simulee..." -ForegroundColor Yellow

$reclamationTest = @{
    titre = "Test de réclamation"
    description = "Ceci est un test de réclamation avec des destinataires simulés"
    categorie = "TECHNIQUE"
    destinataireId = 1
    typeDestinataire = "RH"
    priorite = 2
}

Write-Host "   Donnees de reclamation:" -ForegroundColor Gray
Write-Host "     Titre: $($reclamationTest.titre)" -ForegroundColor White
Write-Host "     Destinataire: RH ID $($reclamationTest.destinataireId)" -ForegroundColor White
Write-Host "     Categorie: $($reclamationTest.categorie)" -ForegroundColor White
Write-Host "     Priorite: $($reclamationTest.priorite)" -ForegroundColor White

Write-Host "`n3. Instructions pour tester le formulaire:" -ForegroundColor Yellow
Write-Host "   1. Ouvrez le navigateur sur http://localhost:5173" -ForegroundColor White
Write-Host "   2. Connectez-vous avec technicien@gmail.com / password" -ForegroundColor White
Write-Host "   3. Allez dans 'Mes Réclamations'" -ForegroundColor White
Write-Host "   4. Cliquez sur 'Nouvelle Réclamation'" -ForegroundColor White
Write-Host "   5. Vérifiez que le dropdown 'Destinataire' affiche les options" -ForegroundColor White

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "  TEST TERMINE" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nSi les destinataires ne s'affichent pas:" -ForegroundColor Yellow
Write-Host "   - Vérifiez que le backend fonctionne sur http://localhost:8081" -ForegroundColor White
Write-Host "   - Vérifiez la console du navigateur pour les erreurs" -ForegroundColor White
Write-Host "   - Vérifiez que les comptes RH et Admin existent" -ForegroundColor White
