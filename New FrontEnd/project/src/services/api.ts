import axios, { AxiosInstance, AxiosResponse, AxiosError } from 'axios';
import { API_CONFIG } from '../config/api';

// Types pour les réponses API
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  user: {
    id: string;
    email: string;
    role: string;
    name?: string;
  };
}

export interface RegisterRequest {
  email: string;
  password: string;
  name: string;
  role: string;
}

// Configuration d'axios
const createApiInstance = (): AxiosInstance => {
  const instance = axios.create({
    baseURL: API_CONFIG.BASE_URL,
    timeout: API_CONFIG.TIMEOUT,
    headers: {
      'Content-Type': 'application/json',
    },
  });

  // Intercepteur pour ajouter le token d'authentification
  instance.interceptors.request.use(
    (config) => {
      const token = localStorage.getItem('token');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      return Promise.reject(error);
    }
  );

  // Intercepteur pour gérer les réponses
  instance.interceptors.response.use(
    (response: AxiosResponse) => {
      return response;
    },
    (error: AxiosError) => {
      if (error.response?.status === 401) {
        // Token expiré ou invalide
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );

  return instance;
};

const api = createApiInstance();

// Service d'authentification
export const authService = {
  async login(credentials: LoginRequest): Promise<ApiResponse<LoginResponse>> {
    try {
      const response = await api.post(API_CONFIG.ENDPOINTS.AUTH.LOGIN, credentials);
      
      // Le backend retourne directement les données, pas dans un objet data
      const responseData = response.data;
      
      // Adapter la structure pour correspondre à notre interface
      const adaptedData: LoginResponse = {
        token: responseData.token,
        user: {
          id: responseData.userId?.toString() || '1',
          email: responseData.email,
          role: responseData.role,
          name: `${responseData.nom} ${responseData.prenom}`.trim()
        }
      };
      
      return {
        success: true,
        data: adaptedData
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data || 'Erreur de connexion'
      };
    }
  },

  async register(userData: RegisterRequest): Promise<ApiResponse> {
    try {
      const response = await api.post(API_CONFIG.ENDPOINTS.AUTH.REGISTER, userData);
      return {
        success: true,
        data: response.data
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data || 'Erreur d\'inscription'
      };
    }
  },

  async logout(): Promise<ApiResponse> {
    try {
      await api.post(API_CONFIG.ENDPOINTS.AUTH.LOGOUT);
      return { success: true };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data || 'Erreur de déconnexion'
      };
    }
  }
};

// Service générique pour les entités
export const createEntityService = <T>(endpoint: string) => ({
  async getAll(): Promise<ApiResponse<T[]>> {
    try {
      const response = await api.get(endpoint);
      return {
        success: true,
        data: response.data
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data?.message || 'Erreur lors de la récupération des données'
      };
    }
  },

  async getById(id: string): Promise<ApiResponse<T>> {
    try {
      const response = await api.get(`${endpoint}/${id}`);
      return {
        success: true,
        data: response.data
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data?.message || 'Erreur lors de la récupération de l\'élément'
      };
    }
  },

  async create(data: Partial<T>): Promise<ApiResponse<T>> {
    try {
      const response = await api.post(endpoint, data);
      return {
        success: true,
        data: response.data
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data?.message || 'Erreur lors de la création'
      };
    }
  },

  async update(id: string, data: Partial<T>): Promise<ApiResponse<T>> {
    try {
      const response = await api.put(`${endpoint}/${id}`, data);
      return {
        success: true,
        data: response.data
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data?.message || 'Erreur lors de la mise à jour'
      };
    }
  },

  async delete(id: string): Promise<ApiResponse> {
    try {
      await api.delete(`${endpoint}/${id}`);
      return { success: true };
    } catch (error: any) {
      return {
        success: false,
        error: error.response?.data?.message || 'Erreur lors de la suppression'
      };
    }
  }
});

// Services spécifiques pour chaque entité
export const clientService = createEntityService(API_CONFIG.ENDPOINTS.CLIENTS);
export const technicienService = createEntityService(API_CONFIG.ENDPOINTS.TECHNICIENS);
export const compteurService = createEntityService(API_CONFIG.ENDPOINTS.COMPTEURS);
export const factureService = createEntityService(API_CONFIG.ENDPOINTS.FACTURES);
export const reclamationService = createEntityService(API_CONFIG.ENDPOINTS.RECLAMATIONS);
export const incidentService = createEntityService(API_CONFIG.ENDPOINTS.INCIDENTS);
export const tacheService = createEntityService(API_CONFIG.ENDPOINTS.TACHES);
export const adminService = createEntityService(API_CONFIG.ENDPOINTS.ADMINS);
export const rhService = createEntityService(API_CONFIG.ENDPOINTS.RH);

export default api;
