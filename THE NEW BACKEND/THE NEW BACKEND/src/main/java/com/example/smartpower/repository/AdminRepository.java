package com.example.smartpower.repository;

import com.example.smartpower.domain.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "admins")
public interface AdminRepository extends JpaRepository<Admin, Long> {
    java.util.Optional<Admin> findByEmail(String email);
}


