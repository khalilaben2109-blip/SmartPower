package com.example.smartpower.web.api;

import com.example.smartpower.domain.Compteur;
import com.example.smartpower.domain.Incident;
import com.example.smartpower.repository.CompteurRepository;
import com.example.smartpower.repository.IncidentRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/incidents")
public class IncidentApiController {
    private final IncidentRepository repository;
    private final CompteurRepository compteurRepository;

    public IncidentApiController(IncidentRepository repository, CompteurRepository compteurRepository) {
        this.repository = repository;
        this.compteurRepository = compteurRepository;
    }

    @GetMapping
    public List<Incident> all() { return repository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Incident> one(@PathVariable Long id) { return repository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }

    @PostMapping
    public ResponseEntity<Incident> create(@RequestBody Incident body, @RequestParam Long compteurId) {
        Compteur compteur = compteurRepository.findById(compteurId).orElse(null);
        if (compteur == null) return ResponseEntity.badRequest().build();
        body.setCompteur(compteur);
        Incident saved = repository.save(body);
        return ResponseEntity.created(URI.create("/api/v1/incidents/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Incident> update(@PathVariable Long id, @RequestBody Incident body, @RequestParam(required = false) Long compteurId) {
        Compteur target = null;
        if (compteurId != null) {
            target = compteurRepository.findById(compteurId).orElse(null);
            if (target == null) return ResponseEntity.badRequest().build();
        }
        Compteur finalTarget = target;
        return repository.findById(id).map(existing -> {
            existing.setCodeIncident(body.getCodeIncident());
            existing.setDateOccurrence(body.getDateOccurrence());
            existing.setDuree(body.getDuree());
            existing.setTypeInterruption(body.getTypeInterruption());
            existing.setStatut(body.getStatut());
            if (finalTarget != null) existing.setCompteur(finalTarget);
            return ResponseEntity.ok(repository.save(existing));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repository.findById(id)
                .map(incident -> {
                    repository.delete(incident);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}


