package com.example.smartpower.web.api;

import com.example.smartpower.domain.Reclamation;
import com.example.smartpower.domain.Technicien;
import com.example.smartpower.domain.Utilisateur;
import com.example.smartpower.repository.ReclamationRepository;
import com.example.smartpower.repository.TechnicienRepository;
import com.example.smartpower.repository.UtilisateurRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/reclamations")
public class ReclamationApiController {
    private final ReclamationRepository repository;
    private final UtilisateurRepository utilisateurRepository;
    private final TechnicienRepository technicienRepository;

    public ReclamationApiController(ReclamationRepository repository, UtilisateurRepository utilisateurRepository, TechnicienRepository technicienRepository) {
        this.repository = repository;
        this.utilisateurRepository = utilisateurRepository;
        this.technicienRepository = technicienRepository;
    }

    @GetMapping
    public List<Reclamation> all() { return repository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Reclamation> one(@PathVariable Long id) {
        return repository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Reclamation> create(@RequestBody Reclamation body, @RequestParam Long utilisateurId, @RequestParam(required = false) Long technicienId) {
        Utilisateur user = utilisateurRepository.findById(utilisateurId).orElse(null);
        if (user == null) return ResponseEntity.badRequest().build();
        body.setUtilisateur(user);
        if (technicienId != null) {
            Technicien tech = technicienRepository.findById(technicienId).orElse(null);
            if (tech == null) return ResponseEntity.badRequest().build();
            body.setTechnicienTraiteur(tech);
        }
        Reclamation saved = repository.save(body);
        return ResponseEntity.created(URI.create("/api/v1/reclamations/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Reclamation> update(@PathVariable Long id, @RequestBody Reclamation body, @RequestParam(required = false) Long utilisateurId, @RequestParam(required = false) Long technicienId) {
        Utilisateur targetUser = null;
        Technicien targetTech = null;
        if (utilisateurId != null) {
            targetUser = utilisateurRepository.findById(utilisateurId).orElse(null);
            if (targetUser == null) return ResponseEntity.badRequest().build();
        }
        if (technicienId != null) {
            targetTech = technicienRepository.findById(technicienId).orElse(null);
            if (targetTech == null) return ResponseEntity.badRequest().build();
        }
        Utilisateur finalTargetUser = targetUser;
        Technicien finalTargetTech = targetTech;
        return repository.findById(id).map(existing -> {
            existing.setDateCreation(body.getDateCreation());
            existing.setDescription(body.getDescription());
            existing.setStatut(body.getStatut());
            existing.setTypeReclamation(body.getTypeReclamation());
            existing.setPriorite(body.getPriorite());
            if (finalTargetUser != null) existing.setUtilisateur(finalTargetUser);
            if (finalTargetTech != null) existing.setTechnicienTraiteur(finalTargetTech);
            return ResponseEntity.ok(repository.save(existing));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repository.findById(id)
                .map(reclamation -> {
                    repository.delete(reclamation);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}


