package com.example.smartpower.controller;

import com.example.smartpower.domain.*;
import com.example.smartpower.repository.*;
import com.example.smartpower.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/technicien")
@CrossOrigin(origins = "*")
public class TechnicienController {

    @Autowired
    private CompteurRepository compteurRepository;

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private TechnicienRepository technicienRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private ReclamationRepository reclamationRepository;
    
    @Autowired
    private RHRepository rhRepository;
    
    @Autowired
    private AdminRepository adminRepository;

    // Vérifier si l'utilisateur connecté est un technicien
    private boolean isCurrentUserTechnicien() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }

        String email = authentication.getName();
        Optional<Utilisateur> userOpt = utilisateurRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return false;
        }

        Utilisateur user = userOpt.get();
        return technicienRepository.existsById(user.getId());
    }

    // Récupérer tous les clients (pour l'affectation de compteurs)
    @GetMapping("/clients")
    public ResponseEntity<?> getAllClients() {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            List<Client> clients = clientRepository.findAll();
            return ResponseEntity.ok(clients);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la récupération des clients");
        }
    }

    // Récupérer tous les compteurs
    @GetMapping("/compteurs")
    public ResponseEntity<?> getAllCompteurs() {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            List<Compteur> compteurs = compteurRepository.findAll();
            return ResponseEntity.ok(compteurs);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la récupération des compteurs");
        }
    }

    // Créer un nouveau compteur
    @PostMapping("/compteurs")
    public ResponseEntity<?> createCompteur(@RequestBody Map<String, Object> request) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            // Validation des champs requis
            String numeroSerie = (String) request.get("numeroSerie");
            String typeCompteur = (String) request.get("typeCompteur");
            String typeAbonnement = (String) request.get("typeAbonnement");
            Float puissanceSouscrite = Float.valueOf(request.get("puissanceSouscrite").toString());
            Float tension = Float.valueOf(request.get("tension").toString());
            Integer phase = Integer.valueOf(request.get("phase").toString());
            Boolean typeCompteurIntelligent = (Boolean) request.get("typeCompteurIntelligent");
            Long clientId = request.get("clientId") != null ? Long.valueOf(request.get("clientId").toString()) : null;

            if (numeroSerie == null || numeroSerie.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le numéro de série est requis");
            }
            if (typeCompteur == null || typeCompteur.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le type de compteur est requis");
            }
            if (typeAbonnement == null || typeAbonnement.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le type d'abonnement est requis");
            }
            if (puissanceSouscrite == null || puissanceSouscrite <= 0) {
                return ResponseEntity.badRequest().body("La puissance souscrite doit être positive");
            }
            if (tension == null || tension <= 0) {
                return ResponseEntity.badRequest().body("La tension doit être positive");
            }
            if (phase == null || phase <= 0) {
                return ResponseEntity.badRequest().body("Le nombre de phases doit être positif");
            }

            // Vérifier si le numéro de série existe déjà
            if (compteurRepository.findByNumeroSerie(numeroSerie).isPresent()) {
                return ResponseEntity.badRequest().body("Un compteur avec ce numéro de série existe déjà");
            }

            // Créer le compteur
            Compteur compteur = new Compteur();
            compteur.setNumeroSerie(numeroSerie.trim());
            compteur.setTypeCompteur(typeCompteur.trim());
            compteur.setTypeAbonnement(typeAbonnement.trim());
            compteur.setPuissanceSouscrite(puissanceSouscrite);
            compteur.setTension(tension);
            compteur.setPhase(phase);
            compteur.setTypeCompteurIntelligent(typeCompteurIntelligent != null ? typeCompteurIntelligent : false);
            compteur.setDateInstallation(LocalDate.now());
            compteur.setStatutCompteur("ACTIF");
            compteur.setConsommationMensuelle(0.0f);

            // Affecter le client si spécifié
            if (clientId != null) {
                Optional<Client> clientOpt = clientRepository.findById(clientId);
                if (clientOpt.isEmpty()) {
                    return ResponseEntity.badRequest().body("Client non trouvé");
                }
                compteur.setClient(clientOpt.get());
            } else {
                // Si aucun client n'est spécifié, on ne peut pas créer le compteur
                // car la relation est obligatoire dans l'entité
                return ResponseEntity.badRequest().body("Un client doit être assigné au compteur");
            }

            Compteur savedCompteur = compteurRepository.save(compteur);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Compteur créé avec succès");
            response.put("compteurId", savedCompteur.getId());
            response.put("numeroSerie", savedCompteur.getNumeroSerie());
            response.put("clientId", savedCompteur.getClient() != null ? savedCompteur.getClient().getId() : null);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la création du compteur");
        }
    }

    // Affecter un compteur à un client
    @PutMapping("/compteurs/{compteurId}/affecter-client")
    public ResponseEntity<?> affecterCompteurAClient(@PathVariable Long compteurId, @RequestBody Map<String, Object> request) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            Long clientId = Long.valueOf(request.get("clientId").toString());

            Optional<Compteur> compteurOpt = compteurRepository.findById(compteurId);
            if (compteurOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Optional<Client> clientOpt = clientRepository.findById(clientId);
            if (clientOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Client non trouvé");
            }

            Compteur compteur = compteurOpt.get();
            Client client = clientOpt.get();

            // Vérifier si le compteur n'est pas déjà affecté à un autre client
            if (compteur.getClient() != null && !compteur.getClient().getId().equals(clientId)) {
                return ResponseEntity.badRequest().body("Ce compteur est déjà affecté à un autre client");
            }

            compteur.setClient(client);
            compteurRepository.save(compteur);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Compteur affecté au client avec succès");
            response.put("compteurId", compteurId);
            response.put("clientId", clientId);
            response.put("clientNom", client.getNom() + " " + client.getPrenom());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de l'affectation du compteur");
        }
    }

    // Désaffecter un compteur d'un client
    @PutMapping("/compteurs/{compteurId}/desaffecter-client")
    public ResponseEntity<?> desaffecterCompteur(@PathVariable Long compteurId) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            Optional<Compteur> compteurOpt = compteurRepository.findById(compteurId);
            if (compteurOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Compteur compteur = compteurOpt.get();
            compteur.setClient(null);
            compteurRepository.save(compteur);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Compteur désaffecté avec succès");
            response.put("compteurId", compteurId);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la désaffectation du compteur");
        }
    }

    // Modifier le statut d'un compteur
    @PutMapping("/compteurs/{compteurId}/statut")
    public ResponseEntity<?> updateCompteurStatus(@PathVariable Long compteurId, @RequestBody Map<String, String> request) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            String newStatus = request.get("statutCompteur");
            if (newStatus == null || (!newStatus.equals("ACTIF") && !newStatus.equals("INACTIF") && !newStatus.equals("MAINTENANCE"))) {
                return ResponseEntity.badRequest().body("Le statut doit être ACTIF, INACTIF ou MAINTENANCE");
            }

            Optional<Compteur> compteurOpt = compteurRepository.findById(compteurId);
            if (compteurOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Compteur compteur = compteurOpt.get();
            compteur.setStatutCompteur(newStatus);
            compteurRepository.save(compteur);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Statut du compteur mis à jour avec succès");
            response.put("compteurId", compteurId);
            response.put("statut", newStatus);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la mise à jour du statut");
        }
    }

    // Rechercher des compteurs
    @GetMapping("/compteurs/search")
    public ResponseEntity<?> searchCompteurs(@RequestParam String q) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            List<Compteur> compteurs = compteurRepository.findByNumeroSerieContainingIgnoreCase(q);
            return ResponseEntity.ok(compteurs);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la recherche des compteurs");
        }
    }

    // Créer un nouveau client
    @PostMapping("/clients")
    public ResponseEntity<?> createClient(@RequestBody Map<String, Object> request) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            // Validation des champs requis
            String nom = (String) request.get("nom");
            String prenom = (String) request.get("prenom");
            String email = (String) request.get("email");
            String telephone = (String) request.get("telephone");
            String adresse = (String) request.get("adresse");
            String ville = (String) request.get("ville");
            String codePostal = (String) request.get("codePostal");
            String password = (String) request.get("password");

            if (nom == null || nom.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le nom est requis");
            }
            if (prenom == null || prenom.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le prénom est requis");
            }
            if (email == null || email.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("L'email est requis");
            }
            if (telephone == null || telephone.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le téléphone est requis");
            }
            if (adresse == null || adresse.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("L'adresse est requise");
            }
            if (ville == null || ville.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("La ville est requise");
            }
            if (codePostal == null || codePostal.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le code postal est requis");
            }
            if (password == null || password.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le mot de passe est requis");
            }

            // Vérifier si l'email existe déjà
            if (utilisateurRepository.findByEmail(email).isPresent()) {
                return ResponseEntity.badRequest().body("Un utilisateur avec cet email existe déjà");
            }

            // Créer le client
            Client client = new Client();
            client.setNom(nom.trim());
            client.setPrenom(prenom.trim());
            client.setEmail(email.trim().toLowerCase());
            client.setTelephone(telephone.trim());
            client.setAdresse(adresse.trim());
            client.setVille(ville.trim());
            client.setCodePostal(codePostal.trim());
            client.setMotDePasse(passwordEncoder.encode(password)); // Crypter le mot de passe
            client.setDateCreation(LocalDate.now());
            client.setStatutCompte("ACTIF");

            Client savedClient = clientRepository.save(client);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Client créé avec succès");
            response.put("clientId", savedClient.getId());
            response.put("nom", savedClient.getNom());
            response.put("prenom", savedClient.getPrenom());
            response.put("email", savedClient.getEmail());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la création du client");
        }
    }
    
    // Récupérer tous les RH et Admin pour l'envoi de réclamations
    @GetMapping("/destinataires")
    public ResponseEntity<?> getDestinataires() {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            Map<String, Object> response = new HashMap<>();
            
            // Récupérer tous les RH
            List<RH> rhs = rhRepository.findAll();
            List<Map<String, Object>> rhList = rhs.stream()
                .map(rh -> {
                    Map<String, Object> rhMap = new HashMap<>();
                    rhMap.put("id", rh.getId());
                    rhMap.put("nom", rh.getNom());
                    rhMap.put("prenom", rh.getPrenom());
                    rhMap.put("email", rh.getEmail());
                    rhMap.put("departement", rh.getDepartement());
                    rhMap.put("type", "RH");
                    return rhMap;
                })
                .collect(java.util.stream.Collectors.toList());
            
            // Récupérer tous les Admin
            List<Admin> admins = adminRepository.findAll();
            List<Map<String, Object>> adminList = admins.stream()
                .map(admin -> {
                    Map<String, Object> adminMap = new HashMap<>();
                    adminMap.put("id", admin.getId());
                    adminMap.put("nom", admin.getNom());
                    adminMap.put("prenom", admin.getPrenom());
                    adminMap.put("email", admin.getEmail());
                    adminMap.put("type", "ADMIN");
                    return adminMap;
                })
                .collect(java.util.stream.Collectors.toList());
            
            response.put("rh", rhList);
            response.put("admin", adminList);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la récupération des destinataires");
        }
    }
    
    // Envoyer une réclamation
    @PostMapping("/reclamations")
    public ResponseEntity<?> envoyerReclamation(@RequestBody Map<String, Object> request) {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            // Récupérer le technicien connecté
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String email = authentication.getName();
            Optional<Utilisateur> userOpt = utilisateurRepository.findByEmail(email);
            if (userOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Utilisateur non trouvé");
            }
            
            Utilisateur user = userOpt.get();
            Optional<Technicien> technicienOpt = technicienRepository.findById(user.getId());
            if (technicienOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Technicien non trouvé");
            }
            
            Technicien technicien = technicienOpt.get();
            
            // Validation des champs requis
            String titre = (String) request.get("titre");
            String description = (String) request.get("description");
            String categorie = (String) request.get("categorie");
            Long destinataireId = Long.valueOf(request.get("destinataireId").toString());
            String typeDestinataire = (String) request.get("typeDestinataire"); // "RH" ou "ADMIN"
            Integer priorite = request.get("priorite") != null ? Integer.valueOf(request.get("priorite").toString()) : 2;

            if (titre == null || titre.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le titre est requis");
            }
            if (description == null || description.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("La description est requise");
            }
            if (categorie == null || categorie.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("La catégorie est requise");
            }
            if (destinataireId == null) {
                return ResponseEntity.badRequest().body("Le destinataire est requis");
            }
            if (typeDestinataire == null || (!typeDestinataire.equals("RH") && !typeDestinataire.equals("ADMIN"))) {
                return ResponseEntity.badRequest().body("Le type de destinataire doit être RH ou ADMIN");
            }

            // Récupérer le destinataire
            Optional<Utilisateur> destinataireOpt = Optional.empty();
            if ("RH".equals(typeDestinataire)) {
                Optional<RH> rhOpt = rhRepository.findById(destinataireId);
                if (rhOpt.isPresent()) {
                    destinataireOpt = Optional.of(rhOpt.get());
                }
            } else if ("ADMIN".equals(typeDestinataire)) {
                Optional<Admin> adminOpt = adminRepository.findById(destinataireId);
                if (adminOpt.isPresent()) {
                    destinataireOpt = Optional.of(adminOpt.get());
                }
            }
            
            if (destinataireOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Destinataire non trouvé");
            }

            // Créer la réclamation
            Reclamation reclamation = new Reclamation();
            reclamation.setTitre(titre.trim());
            reclamation.setDescription(description.trim());
            reclamation.setCategorie(categorie.trim());
            reclamation.setTechnicienExpediteur(technicien);
            reclamation.setDestinataire(destinataireOpt.get());
            reclamation.setDateCreation(LocalDate.now());
            reclamation.setStatut("EN_ATTENTE");
            reclamation.setPriorite(priorite);
            reclamation.setTypeReclamation("TECHNICIEN");

            Reclamation savedReclamation = reclamationRepository.save(reclamation);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Réclamation envoyée avec succès");
            response.put("reclamationId", savedReclamation.getId());
            response.put("titre", savedReclamation.getTitre());
            response.put("destinataire", savedReclamation.getDestinataire().getNom() + " " + savedReclamation.getDestinataire().getPrenom());
            response.put("dateCreation", savedReclamation.getDateCreation());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de l'envoi de la réclamation");
        }
    }
    
    // Récupérer les réclamations envoyées par le technicien
    @GetMapping("/reclamations")
    public ResponseEntity<?> getReclamationsEnvoyees() {
        if (!isCurrentUserTechnicien()) {
            return ResponseEntity.status(403).body("Accès refusé: droits technicien requis");
        }

        try {
            // Récupérer le technicien connecté
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String email = authentication.getName();
            Optional<Utilisateur> userOpt = utilisateurRepository.findByEmail(email);
            if (userOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Utilisateur non trouvé");
            }
            
            Utilisateur user = userOpt.get();
            Optional<Technicien> technicienOpt = technicienRepository.findById(user.getId());
            if (technicienOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Technicien non trouvé");
            }
            
            Technicien technicien = technicienOpt.get();
            
            // Récupérer les réclamations envoyées par ce technicien
            List<Reclamation> reclamations = reclamationRepository.findByTechnicienExpediteur(technicien);
            
            List<Map<String, Object>> reclamationsList = reclamations.stream()
                .map(reclamation -> {
                    Map<String, Object> reclamationMap = new HashMap<>();
                    reclamationMap.put("id", reclamation.getId());
                    reclamationMap.put("titre", reclamation.getTitre());
                    reclamationMap.put("description", reclamation.getDescription());
                    reclamationMap.put("categorie", reclamation.getCategorie());
                    reclamationMap.put("statut", reclamation.getStatut());
                    reclamationMap.put("priorite", reclamation.getPriorite());
                    reclamationMap.put("dateCreation", reclamation.getDateCreation());
                    reclamationMap.put("destinataire", reclamation.getDestinataire() != null ? 
                        reclamation.getDestinataire().getNom() + " " + reclamation.getDestinataire().getPrenom() : null);
                    reclamationMap.put("typeDestinataire", reclamation.getDestinataire() != null ? 
                        (reclamation.getDestinataire() instanceof RH ? "RH" : "ADMIN") : null);
                    return reclamationMap;
                })
                .collect(java.util.stream.Collectors.toList());
            
            return ResponseEntity.ok(reclamationsList);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la récupération des réclamations");
        }
    }
}
