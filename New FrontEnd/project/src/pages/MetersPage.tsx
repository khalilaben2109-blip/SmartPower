import React, { useState } from 'react';
import { Plus, Search, Zap, Wifi, WifiOff, Settings } from 'lucide-react';

export default function MetersPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  
  const meters = [
    {
      id: 'MTR001',
      client: 'Jean Dupont',
      address: '15 Rue de la Paix, 75001 Paris',
      status: 'connected',
      lastReading: '245 kWh',
      lastUpdate: '2024-11-15 14:30',
      batteryLevel: 85,
      signal: 95
    },
    {
      id: 'MTR002',
      client: 'Sophie Bernard',
      address: '42 Avenue des Roses, 75002 Paris',
      status: 'connected',
      lastReading: '189 kWh',
      lastUpdate: '2024-11-15 14:25',
      batteryLevel: 72,
      signal: 88
    },
    {
      id: 'MTR003',
      client: 'Non assigné',
      address: '8 Boulevard Victor Hugo, 75003 Paris',
      status: 'disconnected',
      lastReading: '0 kWh',
      lastUpdate: '2024-11-13 09:15',
      batteryLevel: 45,
      signal: 0
    },
    {
      id: 'MTR004',
      client: 'Paul Durand',
      address: '23 Rue de Rivoli, 75001 Paris',
      status: 'maintenance',
      lastReading: '167 kWh',
      lastUpdate: '2024-11-14 16:45',
      batteryLevel: 91,
      signal: 92
    }
  ];

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
        
        <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2">
          <Plus className="h-4 w-4" />
          <span>Nouveau Compteur</span>
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-green-100 dark:bg-green-900/20 rounded-lg">
              <Wifi className="h-6 w-6 text-green-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Connectés</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{connectedCount}</p>
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
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{disconnectedCount}</p>
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
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{maintenanceCount}</p>
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
          {filteredMeters.map((meter) => {
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
          })}
        </div>
      </div>
    </div>
  );
}