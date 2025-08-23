import React from 'react';
import { useApi } from '../hooks/useApi';
import { clientService } from '../services/api';

export default function ApiTest() {
  const { data: clients, loading, error, execute: fetchClients } = useApi(clientService.getAll);

  const handleTestConnection = () => {
    fetchClients();
  };

  const handleTestPing = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/test/ping');
      const data = await response.json();
      console.log('Ping response:', data);
      alert(`Ping successful: ${data.message}`);
    } catch (error) {
      console.error('Ping error:', error);
      alert(`Ping failed: ${error}`);
    }
  };

  return (
    <div className="p-6 bg-white dark:bg-gray-800 rounded-lg shadow">
      <h3 className="text-lg font-semibold mb-4 text-gray-900 dark:text-white">
        Test de connexion API
      </h3>
      
      <div className="flex gap-2 mb-4">
        <button
          onClick={handleTestConnection}
          disabled={loading}
          className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
        >
          {loading ? 'Test en cours...' : 'Tester la connexion'}
        </button>
        <button
          onClick={handleTestPing}
          className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
        >
          Test Ping
        </button>
      </div>

      {error && (
        <div className="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
          <strong>Erreur :</strong> {error}
        </div>
      )}

      {clients && (
        <div className="mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded">
          <strong>Succès !</strong> Connexion établie avec le backend.
          <div className="mt-2">
            <strong>Données reçues :</strong> {clients.length} clients trouvés
          </div>
        </div>
      )}

      <div className="text-sm text-gray-600 dark:text-gray-400">
        <p>URL du backend : http://localhost:8081</p>
        <p>Endpoint testé : /api/v1/clients</p>
      </div>
    </div>
  );
}
