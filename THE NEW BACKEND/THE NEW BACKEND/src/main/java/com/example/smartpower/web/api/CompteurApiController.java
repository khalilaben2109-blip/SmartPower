package com.example.smartpower.web.api;

import com.example.smartpower.domain.Client;
import com.example.smartpower.domain.Compteur;
import com.example.smartpower.repository.ClientRepository;
import com.example.smartpower.repository.CompteurRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/compteurs")
public class CompteurApiController {
    private final CompteurRepository compteurRepository;
    private final ClientRepository clientRepository;

    public CompteurApiController(CompteurRepository compteurRepository, ClientRepository clientRepository) {
        this.compteurRepository = compteurRepository;
        this.clientRepository = clientRepository;
    }

    @GetMapping
    public List<Compteur> all() { return compteurRepository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Compteur> one(@PathVariable Long id) {
        return compteurRepository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Compteur> create(@RequestBody Compteur body, @RequestParam(required = false) Long clientId) {
        if (clientId != null) {
            Client client = clientRepository.findById(clientId).orElse(null);
            if (client == null) return ResponseEntity.badRequest().build();
            body.setClient(client);
        }
        Compteur saved = compteurRepository.save(body);
        return ResponseEntity.created(URI.create("/api/v1/compteurs/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Compteur> update(@PathVariable Long id, @RequestBody Compteur body, @RequestParam(required = false) Long clientId) {
        Client targetClient = null;
        if (clientId != null) {
            targetClient = clientRepository.findById(clientId).orElse(null);
            if (targetClient == null) {
                return ResponseEntity.badRequest().build();
            }
        }
        Client finalTargetClient = targetClient;
        return compteurRepository.findById(id).map(existing -> {
            existing.setNumeroSerie(body.getNumeroSerie());
            existing.setTypeCompteur(body.getTypeCompteur());
            existing.setTypeAbonnement(body.getTypeAbonnement());
            existing.setPuissanceSouscrite(body.getPuissanceSouscrite());
            existing.setDateInstallation(body.getDateInstallation());
            existing.setStatutCompteur(body.getStatutCompteur());
            existing.setTension(body.getTension());
            existing.setPhase(body.getPhase());
            existing.setConsommationMensuelle(body.getConsommationMensuelle());
            existing.setTypeCompteurIntelligent(body.isTypeCompteurIntelligent());
            if (finalTargetClient != null) {
                existing.setClient(finalTargetClient);
            }
            return ResponseEntity.ok(compteurRepository.save(existing));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return compteurRepository.findById(id)
                .map(compteur -> {
                    compteurRepository.delete(compteur);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}


