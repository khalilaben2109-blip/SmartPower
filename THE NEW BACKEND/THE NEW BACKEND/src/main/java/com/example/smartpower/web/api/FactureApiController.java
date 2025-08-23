package com.example.smartpower.web.api;

import com.example.smartpower.domain.Client;
import com.example.smartpower.domain.Facture;
import com.example.smartpower.repository.ClientRepository;
import com.example.smartpower.repository.FactureRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/factures")
public class FactureApiController {
    private final FactureRepository repository;
    private final ClientRepository clientRepository;

    public FactureApiController(FactureRepository repository, ClientRepository clientRepository) {
        this.repository = repository;
        this.clientRepository = clientRepository;
    }

    @GetMapping
    public List<Facture> all() { return repository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Facture> one(@PathVariable Long id) {
        return repository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Facture> create(@RequestBody Facture body, @RequestParam Long clientId) {
        Client client = clientRepository.findById(clientId).orElse(null);
        if (client == null) return ResponseEntity.badRequest().build();
        body.setClient(client);
        Facture saved = repository.save(body);
        return ResponseEntity.created(URI.create("/api/v1/factures/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Facture> update(@PathVariable Long id, @RequestBody Facture body, @RequestParam(required = false) Long clientId) {
        Client targetClient = null;
        if (clientId != null) {
            targetClient = clientRepository.findById(clientId).orElse(null);
            if (targetClient == null) {
                return ResponseEntity.badRequest().build();
            }
        }
        Client finalTargetClient = targetClient;
        return repository.findById(id).map(existing -> {
            existing.setMontant(body.getMontant());
            existing.setDateEmission(body.getDateEmission());
            existing.setDateEcheance(body.getDateEcheance());
            existing.setStatutPaiement(body.getStatutPaiement());
            existing.setConsommationMois(body.getConsommationMois());
            existing.setMoyenPaiement(body.getMoyenPaiement());
            if (finalTargetClient != null) {
                existing.setClient(finalTargetClient);
            }
            return ResponseEntity.ok(repository.save(existing));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repository.findById(id)
                .map(facture -> {
                    repository.delete(facture);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}


