import React from 'react';
import { Activity, Clock, CheckCircle, AlertTriangle } from 'lucide-react';
import StatsCard from '../components/StatsCard';

export default function SupervisorDashboard() {
  const stats = [
    {
      title: 'Compteurs Surveillés',
      value: '856',
      change: '+2.1%',
      changeType: 'increase' as const,
      icon: Activity,
      color: 'blue'
    },
    {
      title: 'Interventions en Cours',
      value: '12',
      change: '3 nouvelles',
      changeType: 'neutral' as const,
      icon: Clock,
      color: 'yellow'
    },
    {
      title: 'Interventions Terminées',
      value: '45',
      change: '+18%',
      changeType: 'increase' as const,
      icon: CheckCircle,
      color: 'green'
    },
    {
      title: 'Retards de Paiement',
      value: '28',
      change: '-5.2%',
      changeType: 'decrease' as const,
      icon: AlertTriangle,
      color: 'red'
    }
  ];

  const interventions = [
    { id: 'INT001', client: 'Jean Martin', type: 'Maintenance', technician: 'Pierre D.', status: 'En cours' },
    { id: 'INT002', client: 'Sophie L.', type: 'Réparation', technician: 'Marc R.', status: 'Planifiée' },
    { id: 'INT003', client: 'Paul Durand', type: 'Installation', technician: 'Luc M.', status: 'Terminée' }
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
          Tableau de Bord Superviseur
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Supervision et coordination des opérations terrain
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
            Interventions Actives
          </h3>
          <div className="space-y-3">
            {interventions.map((intervention) => (
              <div key={intervention.id} className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900 dark:text-white">{intervention.client}</p>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    {intervention.type} - {intervention.technician}
                  </p>
                </div>
                <span className={`px-3 py-1 text-xs rounded-full font-medium ${
                  intervention.status === 'Terminée'
                    ? 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300'
                    : intervention.status === 'En cours'
                    ? 'bg-blue-100 dark:bg-blue-900/20 text-blue-800 dark:text-blue-300'
                    : 'bg-yellow-100 dark:bg-yellow-900/20 text-yellow-800 dark:text-yellow-300'
                }`}>
                  {intervention.status}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Performance Équipe
          </h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-gray-600 dark:text-gray-400">Interventions réussites</span>
              <span className="font-semibold text-gray-900 dark:text-white">94.2%</span>
            </div>
            <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
              <div className="bg-green-600 h-2 rounded-full" style={{ width: '94.2%' }}></div>
            </div>
            
            <div className="flex justify-between items-center">
              <span className="text-gray-600 dark:text-gray-400">Temps moyen d'intervention</span>
              <span className="font-semibold text-gray-900 dark:text-white">2.3h</span>
            </div>
            <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
              <div className="bg-blue-600 h-2 rounded-full" style={{ width: '76%' }}></div>
            </div>

            <div className="flex justify-between items-center">
              <span className="text-gray-600 dark:text-gray-400">Satisfaction client</span>
              <span className="font-semibold text-gray-900 dark:text-white">4.8/5</span>
            </div>
            <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
              <div className="bg-purple-600 h-2 rounded-full" style={{ width: '96%' }}></div>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Actions de Supervision
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <button className="p-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Activity className="h-5 w-5" />
            <span>Planifier Intervention</span>
          </button>
          <button className="p-4 bg-green-600 hover:bg-green-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <CheckCircle className="h-5 w-5" />
            <span>Valider Travaux</span>
          </button>
          <button className="p-4 bg-orange-600 hover:bg-orange-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <AlertTriangle className="h-5 w-5" />
            <span>Gérer Urgences</span>
          </button>
        </div>
      </div>
    </div>
  );
}