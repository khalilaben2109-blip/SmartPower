package com.example.smartpower.repository;

import com.example.smartpower.domain.Technicien;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "techniciens")
public interface TechnicienRepository extends JpaRepository<Technicien, Long> {
    java.util.Optional<Technicien> findByEmail(String email);
}
