package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "incidents")
public class Incident {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String codeIncident;
    private LocalDate dateOccurrence;
    private int duree;
    private int typeInterruption;
    private String statut;

    @ManyToOne(optional = false)
    private Compteur compteur;
}


