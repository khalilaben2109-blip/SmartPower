package com.example.smartpower.domain;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "clients")
public class Client extends Utilisateur {
    private String adresse;
    private String codePostal;
    private String ville;
    private String province;
    private String typeResidence;
    private Integer nombrePersonnes;
    private String zoneTarifaire;
    private String typeActivite;
    private String typeClient;
    private String segmentClient;
    private Float scoreCredit;

    @JsonIgnore
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Compteur> compteurs = new HashSet<>();

    @JsonIgnore
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Facture> factures = new HashSet<>();

    // Constructeur
    public Client() {
        super();
    }

    // Getters et Setters pour les champs spécifiques à Client
    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getCodePostal() {
        return codePostal;
    }

    public void setCodePostal(String codePostal) {
        this.codePostal = codePostal;
    }

    public String getVille() {
        return ville;
    }

    public void setVille(String ville) {
        this.ville = ville;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getTypeResidence() {
        return typeResidence;
    }

    public void setTypeResidence(String typeResidence) {
        this.typeResidence = typeResidence;
    }

    public Integer getNombrePersonnes() {
        return nombrePersonnes;
    }

    public void setNombrePersonnes(Integer nombrePersonnes) {
        this.nombrePersonnes = nombrePersonnes;
    }

    public String getZoneTarifaire() {
        return zoneTarifaire;
    }

    public void setZoneTarifaire(String zoneTarifaire) {
        this.zoneTarifaire = zoneTarifaire;
    }

    public String getTypeActivite() {
        return typeActivite;
    }

    public void setTypeActivite(String typeActivite) {
        this.typeActivite = typeActivite;
    }

    public String getTypeClient() {
        return typeClient;
    }

    public void setTypeClient(String typeClient) {
        this.typeClient = typeClient;
    }

    public String getSegmentClient() {
        return segmentClient;
    }

    public void setSegmentClient(String segmentClient) {
        this.segmentClient = segmentClient;
    }

    public Float getScoreCredit() {
        return scoreCredit;
    }

    public void setScoreCredit(Float scoreCredit) {
        this.scoreCredit = scoreCredit;
    }

    public Set<Compteur> getCompteurs() {
        return compteurs;
    }

    public void setCompteurs(Set<Compteur> compteurs) {
        this.compteurs = compteurs;
    }

    public Set<Facture> getFactures() {
        return factures;
    }

    public void setFactures(Set<Facture> factures) {
        this.factures = factures;
    }
}


