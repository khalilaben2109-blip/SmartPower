package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@Entity
@Table(name = "releves")
public class Releve {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate dateReleve;
    private float indexe;
    private float consommationJour;
    private float consommationSemaine;
    private float picConsommation;
    private LocalTime heurePic;

    @ManyToOne(optional = false)
    private Compteur compteur;
}


