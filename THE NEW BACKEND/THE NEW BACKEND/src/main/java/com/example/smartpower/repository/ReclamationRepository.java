package com.example.smartpower.repository;

import com.example.smartpower.domain.Reclamation;
import com.example.smartpower.domain.Technicien;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

@RepositoryRestResource(path = "reclamations")
public interface ReclamationRepository extends JpaRepository<Reclamation, Long> {
    List<Reclamation> findByTechnicienExpediteur(Technicien technicien);
}
