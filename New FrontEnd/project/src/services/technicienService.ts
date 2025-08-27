import api from './api';

export interface Compteur {
  id: number;
  numeroSerie: string;
  typeCompteur: string;
  typeAbonnement: string;
  puissanceSouscrite: number;
  dateInstallation: string;
  statutCompteur: string;
  tension: number;
  phase: number;
  consommationMensuelle: number;
  typeCompteurIntelligent: boolean;
  client?: Client;
}

export interface Client {
  id: number;
  nom: string;
  prenom: string;
  email: string;
  telephone: string;
  adresse: string;
  ville: string;
  codePostal: string;
}

export interface CreateCompteurRequest {
  numeroSerie: string;
  typeCompteur: string;
  typeAbonnement: string;
  puissanceSouscrite: number;
  tension: number;
  phase: number;
  typeCompteurIntelligent: boolean;
  clientId?: number;
}

export interface CreateClientRequest {
  nom: string;
  prenom: string;
  email: string;
  telephone: string;
  adresse: string;
  ville: string;
  codePostal: string;
  password: string;
}

export interface Destinataire {
  id: number;
  nom: string;
  prenom: string;
  email: string;
  type: 'RH' | 'ADMIN';
  departement?: string;
}

export interface CreateReclamationRequest {
  titre: string;
  description: string;
  categorie: string;
  destinataireId: number;
  typeDestinataire: 'RH' | 'ADMIN';
  priorite?: number;
}

export interface Reclamation {
  id: number;
  titre: string;
  description: string;
  categorie: string;
  statut: string;
  priorite: number;
  dateCreation: string;
  destinataire: string;
  typeDestinataire: string;
}

export const technicienService = {
  // Récupérer tous les clients
  async getAllClients(): Promise<Client[]> {
    try {
      const response = await api.get('/api/technicien/clients');
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des clients:', error);
      throw error;
    }
  },

  // Récupérer tous les compteurs
  async getAllCompteurs(): Promise<Compteur[]> {
    try {
      const response = await api.get('/api/technicien/compteurs');
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des compteurs:', error);
      throw error;
    }
  },

  // Créer un nouveau compteur
  async createCompteur(compteurData: CreateCompteurRequest): Promise<any> {
    try {
      const response = await api.post('/api/technicien/compteurs', compteurData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la création du compteur:', error);
      throw error;
    }
  },

  // Affecter un compteur à un client
  async affecterCompteurAClient(compteurId: number, clientId: number): Promise<any> {
    try {
      const response = await api.put(`/api/technicien/compteurs/${compteurId}/affecter-client`, { clientId });
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'affectation du compteur:', error);
      throw error;
    }
  },

  // Désaffecter un compteur
  async desaffecterCompteur(compteurId: number): Promise<any> {
    try {
      const response = await api.put(`/api/technicien/compteurs/${compteurId}/desaffecter-client`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la désaffectation du compteur:', error);
      throw error;
    }
  },

  // Modifier le statut d'un compteur
  async updateCompteurStatus(compteurId: number, statut: string): Promise<any> {
    try {
      const response = await api.put(`/api/technicien/compteurs/${compteurId}/statut`, { statutCompteur: statut });
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la mise à jour du statut:', error);
      throw error;
    }
  },

  // Rechercher des compteurs
  async searchCompteurs(query: string): Promise<Compteur[]> {
    try {
      const response = await api.get(`/api/technicien/compteurs/search?q=${encodeURIComponent(query)}`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la recherche:', error);
      throw error;
    }
  },

  // Créer un nouveau client
  async createClient(clientData: CreateClientRequest): Promise<any> {
    try {
      const response = await api.post('/api/technicien/clients', clientData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la création du client:', error);
      throw error;
    }
  },

  // Récupérer les destinataires (RH et Admin)
  async getDestinataires(): Promise<{ rh: Destinataire[], admin: Destinataire[] }> {
    try {
      const response = await api.get('/api/technicien/destinataires');
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des destinataires:', error);
      throw error;
    }
  },

  // Envoyer une réclamation
  async envoyerReclamation(reclamationData: CreateReclamationRequest): Promise<any> {
    try {
      const response = await api.post('/api/technicien/reclamations', reclamationData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'envoi de la réclamation:', error);
      throw error;
    }
  },

  // Récupérer les réclamations envoyées
  async getReclamationsEnvoyees(): Promise<Reclamation[]> {
    try {
      const response = await api.get('/api/technicien/reclamations');
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des réclamations:', error);
      throw error;
    }
  }
};
