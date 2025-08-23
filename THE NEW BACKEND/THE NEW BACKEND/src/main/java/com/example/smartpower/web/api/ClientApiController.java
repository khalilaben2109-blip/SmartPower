package com.example.smartpower.web.api;

import com.example.smartpower.domain.Client;
import com.example.smartpower.repository.ClientRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/clients")
public class ClientApiController {
    private final ClientRepository clientRepository;

    public ClientApiController(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    @GetMapping
    public List<Client> findAll() {
        return clientRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Client> findById(@PathVariable Long id) {
        return clientRepository.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Client> create(@RequestBody Client client) {
        Client saved = clientRepository.save(client);
        return ResponseEntity.created(URI.create("/api/v1/clients/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Client> update(@PathVariable Long id, @RequestBody Client changes) {
        return clientRepository.findById(id)
                .map(existing -> {
                    if (changes.getNom() != null) existing.setNom(changes.getNom());
                    if (changes.getPrenom() != null) existing.setPrenom(changes.getPrenom());
                    if (changes.getEmail() != null) existing.setEmail(changes.getEmail());
                    if (changes.getTelephone() != null) existing.setTelephone(changes.getTelephone());
                    if (changes.getAdresse() != null) existing.setAdresse(changes.getAdresse());
                    if (changes.getVille() != null) existing.setVille(changes.getVille());
                    if (changes.getProvince() != null) existing.setProvince(changes.getProvince());
                    if (changes.getTypeResidence() != null) existing.setTypeResidence(changes.getTypeResidence());
                    if (changes.getNombrePersonnes() != null) existing.setNombrePersonnes(changes.getNombrePersonnes());
                    if (changes.getZoneTarifaire() != null) existing.setZoneTarifaire(changes.getZoneTarifaire());
                    if (changes.getTypeActivite() != null) existing.setTypeActivite(changes.getTypeActivite());
                    if (changes.getTypeClient() != null) existing.setTypeClient(changes.getTypeClient());
                    if (changes.getSegmentClient() != null) existing.setSegmentClient(changes.getSegmentClient());
                    if (changes.getScoreCredit() != null) existing.setScoreCredit(changes.getScoreCredit());
                    return ResponseEntity.ok(clientRepository.save(existing));
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return clientRepository.findById(id)
                .map(client -> {
                    clientRepository.delete(client);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}


