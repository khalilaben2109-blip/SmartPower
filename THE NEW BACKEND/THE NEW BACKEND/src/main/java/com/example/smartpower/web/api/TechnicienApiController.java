package com.example.smartpower.web.api;

import com.example.smartpower.domain.Technicien;
import com.example.smartpower.repository.TechnicienRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/techniciens")
public class TechnicienApiController {
    private final TechnicienRepository repository;

    public TechnicienApiController(TechnicienRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Technicien> all() { return repository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Technicien> one(@PathVariable Long id) {
        return repository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Technicien> create(@RequestBody Technicien body) {
        Technicien saved = repository.save(body);
        return ResponseEntity.created(URI.create("/api/v1/techniciens/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Technicien> update(@PathVariable Long id, @RequestBody Technicien body) {
        return repository.findById(id).map(existing -> {
            if (body.getNom() != null) existing.setNom(body.getNom());
            if (body.getPrenom() != null) existing.setPrenom(body.getPrenom());
            if (body.getEmail() != null) existing.setEmail(body.getEmail());
            if (body.getTelephone() != null) existing.setTelephone(body.getTelephone());
            if (body.getCodeAgent() != null) existing.setCodeAgent(body.getCodeAgent());
            if (body.getZoneGeographique() != null) existing.setZoneGeographique(body.getZoneGeographique());
            if (body.getSpecialite() != null) existing.setSpecialite(body.getSpecialite());
            return ResponseEntity.ok(repository.save(existing));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repository.findById(id)
                .map(technicien -> {
                    repository.delete(technicien);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}


