package com.example.smartpower.web.api;

import com.example.smartpower.domain.*;
import com.example.smartpower.repository.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/taches")
public class TacheApiController {
    private final TacheRepository repository;
    private final AdminRepository adminRepository;
    private final TechnicienRepository technicienRepository;
    private final ClientRepository clientRepository;

    public TacheApiController(TacheRepository repository, AdminRepository adminRepository, TechnicienRepository technicienRepository, ClientRepository clientRepository) {
        this.repository = repository;
        this.adminRepository = adminRepository;
        this.technicienRepository = technicienRepository;
        this.clientRepository = clientRepository;
    }

    @GetMapping
    public List<Tache> all() { return repository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Tache> one(@PathVariable Long id) { return repository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }

    @PostMapping
    public ResponseEntity<Tache> create(@RequestBody Tache body, @RequestParam(required = false) Long adminId, @RequestParam(required = false) Long technicienId, @RequestParam(required = false) Long clientId) {
        if (adminId != null) repositoryAdmin(body, adminId);
        if (technicienId != null) repositoryTechnicien(body, technicienId);
        if (clientId != null) repositoryClient(body, clientId);
        Tache saved = repository.save(body);
        return ResponseEntity.created(URI.create("/api/v1/taches/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Tache> update(@PathVariable Long id, @RequestBody Tache body, @RequestParam(required = false) Long adminId, @RequestParam(required = false) Long technicienId, @RequestParam(required = false) Long clientId) {
        return repository.findById(id).map(existing -> {
            existing.setTitre(body.getTitre());
            existing.setDescription(body.getDescription());
            existing.setDateCreation(body.getDateCreation());
            existing.setEcheance(body.getEcheance());
            existing.setStatut(body.getStatut());
            existing.setPriorite(body.getPriorite());
            if (adminId != null) repositoryAdmin(existing, adminId);
            if (technicienId != null) repositoryTechnicien(existing, technicienId);
            if (clientId != null) repositoryClient(existing, clientId);
            return ResponseEntity.ok(repository.save(existing));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repository.findById(id)
                .map(tache -> {
                    repository.delete(tache);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    private void repositoryAdmin(Tache t, Long adminId) {
        adminRepository.findById(adminId).ifPresent(t::setAdminAffecteur);
    }

    private void repositoryTechnicien(Tache t, Long technicienId) {
        technicienRepository.findById(technicienId).ifPresent(t::setTechnicienAssigne);
    }

    private void repositoryClient(Tache t, Long clientId) {
        clientRepository.findById(clientId).ifPresent(t::setClient);
    }
}


