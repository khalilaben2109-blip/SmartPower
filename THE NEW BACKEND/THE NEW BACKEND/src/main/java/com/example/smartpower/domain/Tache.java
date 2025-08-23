package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "taches")
public class Tache {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String titre;
    private String description;
    private LocalDate dateCreation;
    private LocalDate echeance;
    private String statut;
    private Integer priorite;

    @ManyToOne
    private Admin adminAffecteur;

    @ManyToOne
    private Technicien technicienAssigne;

    @ManyToOne
    private Client client;
}


