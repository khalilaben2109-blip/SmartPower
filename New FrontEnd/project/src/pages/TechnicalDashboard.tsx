import React from 'react';
import { Wrench, Clock, CheckCircle2, AlertTriangle } from 'lucide-react';
import StatsCard from '../components/StatsCard';

export default function TechnicalDashboard() {
  const stats = [
    {
      title: 'Interventions Assignées',
      value: '8',
      change: '2 nouvelles',
      changeType: 'neutral' as const,
      icon: Wrench,
      color: 'blue'
    },
    {
      title: 'En Cours',
      value: '3',
      change: 'Prioritaire',
      changeType: 'increase' as const,
      icon: Clock,
      color: 'yellow'
    },
    {
      title: 'Terminées Aujourd\'hui',
      value: '5',
      change: '+25%',
      changeType: 'increase' as const,
      icon: CheckCircle2,
      color: 'green'
    },
    {
      title: 'Réclamations Techniques',
      value: '2',
      change: 'À traiter',
      changeType: 'neutral' as const,
      icon: AlertTriangle,
      color: 'red'
    }
  ];

  const interventions = [
    { id: 'INT001', client: 'Jean Martin', address: '15 Rue de la Paix', type: 'Maintenance', priority: 'Haute', time: '14:30' },
    { id: 'INT002', client: 'Sophie L.', address: '42 Av. des Roses', type: 'Réparation', priority: 'Moyenne', time: '16:00' },
    { id: 'INT003', client: 'Paul Durand', address: '8 Bd Victor Hugo', type: 'Installation', priority: 'Basse', time: '09:00' }
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
          Tableau de Bord Technique
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Gestion des interventions et maintenance des compteurs
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => (
          <StatsCard key={index} {...stat} />
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Interventions du Jour
          </h3>
          <div className="space-y-3">
            {interventions.map((intervention) => (
              <div key={intervention.id} className="p-4 border border-gray-200 dark:border-gray-600 rounded-lg">
                <div className="flex justify-between items-start mb-2">
                  <div>
                    <h4 className="font-medium text-gray-900 dark:text-white">{intervention.client}</h4>
                    <p className="text-sm text-gray-600 dark:text-gray-400">{intervention.address}</p>
                  </div>
                  <span className={`px-2 py-1 text-xs rounded-full font-medium ${
                    intervention.priority === 'Haute'
                      ? 'bg-red-100 dark:bg-red-900/20 text-red-800 dark:text-red-300'
                      : intervention.priority === 'Moyenne'
                      ? 'bg-yellow-100 dark:bg-yellow-900/20 text-yellow-800 dark:text-yellow-300'
                      : 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300'
                  }`}>
                    {intervention.priority}
                  </span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                    {intervention.type}
                  </span>
                  <span className="text-sm text-gray-600 dark:text-gray-400">
                    {intervention.time}
                  </span>
                </div>
                <div className="mt-3 flex space-x-2">
                  <button className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2 px-3 rounded text-sm transition-colors">
                    Commencer
                  </button>
                  <button className="flex-1 bg-green-600 hover:bg-green-700 text-white py-2 px-3 rounded text-sm transition-colors">
                    Terminer
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Outils & Matériel
          </h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
              <span className="text-gray-700 dark:text-gray-300">Compteurs disponibles</span>
              <span className="font-semibold text-green-600">15</span>
            </div>
            <div className="flex justify-between items-center p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
              <span className="text-gray-700 dark:text-gray-300">Outils en stock</span>
              <span className="font-semibold text-blue-600">√</span>
            </div>
            <div className="flex justify-between items-center p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
              <span className="text-gray-700 dark:text-gray-300">Véhicule assigné</span>
              <span className="font-semibold text-gray-900 dark:text-white">TEC-001</span>
            </div>
          </div>
          
          <div className="mt-6">
            <h4 className="font-medium text-gray-900 dark:text-white mb-3">Actions Rapides</h4>
            <div className="space-y-2">
                          <button 
              onClick={() => window.location.href = '/technical/compteurs'}
              className="w-full bg-purple-600 hover:bg-purple-700 text-white p-3 rounded-lg transition-colors"
            >
              Gérer les Compteurs
            </button>
            <button 
              onClick={() => window.location.href = '/technical/reclamations'}
              className="w-full bg-orange-600 hover:bg-orange-700 text-white p-3 rounded-lg transition-colors"
            >
              Mes Réclamations
            </button>
              <button className="w-full bg-blue-600 hover:bg-blue-700 text-white p-3 rounded-lg transition-colors">
                Signaler un Problème
              </button>
              <button className="w-full bg-green-600 hover:bg-green-700 text-white p-3 rounded-lg transition-colors">
                Demander du Matériel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}