export const API_CONFIG = {
  BASE_URL: 'http://localhost:8081',
  TIMEOUT: 10000,
  ENDPOINTS: {
    AUTH: {
      LOGIN: '/api/auth/login',
      REGISTER: '/api/auth/register',
      LOGOUT: '/api/auth/logout'
    },
    CLIENTS: '/api/v1/clients',
    TECHNICIENS: '/api/v1/techniciens',
    COMPTEURS: '/api/v1/compteurs',
    FACTURES: '/api/v1/factures',
    RECLAMATIONS: '/api/v1/reclamations',
    INCIDENTS: '/api/v1/incidents',
    TACHES: '/api/v1/taches',
    ADMINS: '/api/v1/admins',
    RH: '/api/v1/rh'
  }
};

// Comptes de test disponibles dans la base de données
export const TEST_ACCOUNTS = {
  ADMIN: {
    email: 'admin@gmail.com',
    password: 'admin',
    nom: 'aziz',
    prenom: 'kimouli'
  }
};
