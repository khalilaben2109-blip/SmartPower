package com.example.smartpower.repository;

import com.example.smartpower.domain.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "clients")
public interface ClientRepository extends JpaRepository<Client, Long> {
    java.util.Optional<Client> findByEmail(String email);
}


