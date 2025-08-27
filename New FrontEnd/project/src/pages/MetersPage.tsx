import React, { useState, useEffect } from 'react';
import { Plus, Search, Zap, Wifi, WifiOff, Settings, RefreshCw, AlertCircle, User } from 'lucide-react';
import { technicienService, Compteur, Client, CreateCompteurRequest, CreateClientRequest } from '../services/technicienService';
import CompteurModal from '../components/CompteurModal';
import ClientModal from '../components/ClientModal';

export default function MetersPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [compteurs, setCompteurs] = useState<Compteur[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [modalMode, setModalMode] = useState<'create' | 'edit'>('create');
  const [selectedCompteur, setSelectedCompteur] = useState<Compteur | null>(null);
  const [actionLoading, setActionLoading] = useState<number | null>(null);
  const [clientModalOpen, setClientModalOpen] = useState(false);
  const [clientModalMode, setClientModalMode] = useState<'create' | 'edit'>('create');
  const [selectedClient, setSelectedClient] = useState<Client | null>(null);

  // Charger les données
  const loadData = async () => {
    setLoading(true);
    setError(null);
    try {
      const [compteursData, clientsData] = await Promise.all([
        technicienService.getAllCompteurs(),
        technicienService.getAllClients()
      ]);
      setCompteurs(compteursData);
      setClients(clientsData);
    } catch (err) {
      console.error('Erreur loadData:', err);
      setError('Erreur lors du chargement des données');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  // Créer un compteur
  const handleCreateCompteur = async (compteurData: CreateCompteurRequest) => {
    try {
      await technicienService.createCompteur(compteurData);
      await loadData(); // Recharger la liste
    } catch (err) {
      throw err;
    }
  };

  // Créer un client
  const handleCreateClient = async (clientData: CreateClientRequest) => {
    try {
      await technicienService.createClient(clientData);
      await loadData(); // Recharger la liste
    } catch (err) {
      throw err;
    }
  };

  // Ouvrir le modal de création de compteur
  const openCreateModal = () => {
    setModalMode('create');
    setSelectedCompteur(null);
    setModalOpen(true);
  };

  // Ouvrir le modal de création de client
  const openCreateClientModal = () => {
    setClientModalMode('create');
    setSelectedClient(null);
    setClientModalOpen(true);
  };

  // Convertir les compteurs en format compatible avec l'interface existante
  const meters = compteurs.map(compteur => ({
    id: compteur.numeroSerie,
    client: compteur.client ? `${compteur.client.nom} ${compteur.client.prenom}` : 'Non assigné',
    address: compteur.client ? `${compteur.client.adresse}, ${compteur.client.codePostal} ${compteur.client.ville}` : 'Adresse non disponible',
    status: compteur.statutCompteur.toLowerCase() === 'actif' ? 'connected' : 
            compteur.statutCompteur.toLowerCase() === 'inactif' ? 'disconnected' : 'maintenance',
    lastReading: `${compteur.consommationMensuelle} kWh`,
    lastUpdate: compteur.dateInstallation,
    batteryLevel: 85, // Valeur par défaut
    signal: 95 // Valeur par défaut
  }));

  const getStatusInfo = (status: string) => {
    const statusMap = {
      connected: { 
        label: 'Connecté', 
        color: 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300',
        icon: Wifi
      },
      disconnected: { 
        label: 'Déconnecté', 
        color: 'bg-red-100 dark:bg-red-900/20 text-red-800 dark:text-red-300',
        icon: WifiOff
      },
      maintenance: { 
        label: 'Maintenance', 
        color: 'bg-yellow-100 dark:bg-yellow-900/20 text-yellow-800 dark:text-yellow-300',
        icon: Settings
      }
    };
    return statusMap[status as keyof typeof statusMap] || statusMap.connected;
  };

  const getBatteryColor = (level: number) => {
    if (level > 70) return 'bg-green-500';
    if (level > 30) return 'bg-yellow-500';
    return 'bg-red-500';
  };

  const filteredMeters = meters.filter(meter => {
    const matchesSearch = meter.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         meter.client.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         meter.address.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || meter.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const connectedCount = meters.filter(m => m.status === 'connected').length;
  const disconnectedCount = meters.filter(m => m.status === 'disconnected').length;
  const maintenanceCount = meters.filter(m => m.status === 'maintenance').length;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Gestion des Compteurs
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Surveillez et gérez les compteurs intelligents
          </p>
        </div>
        
        <div className="flex items-center space-x-3">
          <button
            onClick={loadData}
            disabled={loading}
            className="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors disabled:opacity-50"
            title="Actualiser"
          >
            <RefreshCw className={`h-5 w-5 ${loading ? 'animate-spin' : ''}`} />
          </button>
          
          <button 
            onClick={openCreateClientModal}
            className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2"
          >
            <User className="h-4 w-4" />
            <span>Nouveau Client</span>
          </button>
          
          <button 
            onClick={openCreateModal}
            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2"
          >
            <Plus className="h-4 w-4" />
            <span>Nouveau Compteur</span>
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-green-100 dark:bg-green-900/20 rounded-lg">
              <Wifi className="h-6 w-6 text-green-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Connectés</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {loading ? <RefreshCw className="h-6 w-6 animate-spin" /> : connectedCount}
              </p>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-red-100 dark:bg-red-900/20 rounded-lg">
              <WifiOff className="h-6 w-6 text-red-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Déconnectés</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {loading ? <RefreshCw className="h-6 w-6 animate-spin" /> : disconnectedCount}
              </p>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-yellow-100 dark:bg-yellow-900/20 rounded-lg">
              <Settings className="h-6 w-6 text-yellow-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">En maintenance</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {loading ? <RefreshCw className="h-6 w-6 animate-spin" /> : maintenanceCount}
              </p>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-4 sm:space-y-0 mb-6">
          <div className="flex items-center space-x-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <input
                type="text"
                placeholder="Rechercher un compteur..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white w-64"
              />
            </div>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
            >
              <option value="all">Tous les statuts</option>
              <option value="connected">Connectés</option>
              <option value="disconnected">Déconnectés</option>
              <option value="maintenance">En maintenance</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
          {loading ? (
            <div className="col-span-full flex items-center justify-center py-12">
              <div className="flex items-center space-x-2">
                <RefreshCw className="h-6 w-6 animate-spin text-blue-600" />
                <span className="text-gray-600 dark:text-gray-400">Chargement des compteurs...</span>
              </div>
            </div>
          ) : filteredMeters.length === 0 ? (
            <div className="col-span-full text-center py-12">
              <p className="text-gray-600 dark:text-gray-400">Aucun compteur trouvé</p>
            </div>
          ) : (
            filteredMeters.map((meter) => {
            const statusInfo = getStatusInfo(meter.status);
            const StatusIcon = statusInfo.icon;
            
            return (
              <div key={meter.id} className="border border-gray-200 dark:border-gray-600 rounded-lg p-6">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex items-center space-x-3">
                    <div className="p-2 bg-blue-100 dark:bg-blue-900/20 rounded-lg">
                      <Zap className="h-5 w-5 text-blue-600" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-gray-900 dark:text-white">
                        {meter.id}
                      </h3>
                      <p className="text-sm text-gray-600 dark:text-gray-400">
                        {meter.client}
                      </p>
                    </div>
                  </div>
                  <span className={`px-2 py-1 text-xs font-medium rounded-full ${statusInfo.color}`}>
                    {statusInfo.label}
                  </span>
                </div>

                <div className="space-y-3">
                  <div>
                    <p className="text-sm text-gray-600 dark:text-gray-400">Adresse</p>
                    <p className="text-sm text-gray-900 dark:text-white">{meter.address}</p>
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <p className="text-sm text-gray-600 dark:text-gray-400">Dernière lecture</p>
                      <p className="font-medium text-gray-900 dark:text-white">{meter.lastReading}</p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-600 dark:text-gray-400">Mise à jour</p>
                      <p className="text-sm text-gray-900 dark:text-white">
                        {new Date(meter.lastUpdate).toLocaleString('fr-FR')}
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 flex-1 max-w-20">
                        <div 
                          className={`h-2 rounded-full ${getBatteryColor(meter.batteryLevel)}`}
                          style={{ width: `${meter.batteryLevel}%` }}
                        ></div>
                      </div>
                      <span className="text-xs text-gray-600 dark:text-gray-400">
                        {meter.batteryLevel}%
                      </span>
                    </div>
                    
                    <div className="flex items-center space-x-1">
                      <StatusIcon className="h-4 w-4 text-gray-400" />
                      <span className="text-xs text-gray-600 dark:text-gray-400">
                        {meter.signal}%
                      </span>
                    </div>
                  </div>

                  <div className="flex space-x-2 mt-4">
                    <button className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2 px-3 rounded text-sm transition-colors">
                      Configurer
                    </button>
                    <button className="flex-1 bg-gray-600 hover:bg-gray-700 text-white py-2 px-3 rounded text-sm transition-colors">
                      Détails
                    </button>
                  </div>
                </div>
              </div>
            );
          })
          )}
        </div>
      </div>

      {/* Affichage de l'erreur */}
      {error && (
        <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
          <div className="flex items-center space-x-3">
            <AlertCircle className="h-5 w-5 text-red-500" />
            <div>
              <h3 className="text-sm font-medium text-red-800 dark:text-red-200">
                Erreur de chargement
              </h3>
              <p className="text-sm text-red-700 dark:text-red-300 mt-1">
                {error}
              </p>
            </div>
          </div>
          <button
            onClick={loadData}
            className="mt-3 bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-sm transition-colors"
          >
            Réessayer
          </button>
        </div>
      )}

      {/* Modal pour créer/éditer un compteur */}
      <CompteurModal
        isOpen={modalOpen}
        onClose={() => setModalOpen(false)}
        onSave={handleCreateCompteur}
        compteur={selectedCompteur}
        clients={clients}
        mode={modalMode}
      />

      {/* Modal pour créer/éditer un client */}
      <ClientModal
        isOpen={clientModalOpen}
        onClose={() => setClientModalOpen(false)}
        onSave={handleCreateClient}
        client={selectedClient}
        mode={clientModalMode}
      />
    </div>
  );
}