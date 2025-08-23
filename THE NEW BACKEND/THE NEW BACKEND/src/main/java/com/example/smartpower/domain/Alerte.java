package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "alertes")
public class Alerte {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String message;
    private LocalDate dateEnvoi;
    private String typeAlerte;

    @ManyToOne
    private Admin admin;

    @ManyToOne
    private Client client;
}


