import React from 'react';
import { Users, Calendar, Clock, Award } from 'lucide-react';
import StatsCard from '../components/StatsCard';

export default function HRDashboard() {
  const stats = [
    {
      title: 'Employés Actifs',
      value: '45',
      change: '+3 ce mois',
      changeType: 'increase' as const,
      icon: Users,
      color: 'blue'
    },
    {
      title: 'Congés en Cours',
      value: '8',
      change: '2 nouvelles demandes',
      changeType: 'neutral' as const,
      icon: Calendar,
      color: 'green'
    },
    {
      title: 'Heures Travaillées',
      value: '1,856h',
      change: 'Cette semaine',
      changeType: 'neutral' as const,
      icon: Clock,
      color: 'purple'
    },
    {
      title: 'Performance Moyenne',
      value: '4.2/5',
      change: '+0.3 vs dernier mois',
      changeType: 'increase' as const,
      icon: Award,
      color: 'yellow'
    }
  ];

  const employees = [
    { name: 'Pierre Durand', role: 'Technicien', department: 'Technique', status: 'Actif', performance: 4.5 },
    { name: 'Marie Martin', role: 'Superviseur', department: 'Opérations', status: 'En congé', performance: 4.8 },
    { name: 'Luc Moreau', role: 'Technicien', department: 'Technique', status: 'Actif', performance: 4.2 }
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
          Tableau de Bord RH
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Gestion des ressources humaines et suivi des équipes
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
            Équipe Technique
          </h3>
          <div className="space-y-3">
            {employees.map((employee, index) => (
              <div key={index} className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700 rounded-lg">
                <div>
                  <h4 className="font-medium text-gray-900 dark:text-white">{employee.name}</h4>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    {employee.role} - {employee.department}
                  </p>
                </div>
                <div className="text-right">
                  <span className={`px-2 py-1 text-xs rounded-full font-medium ${
                    employee.status === 'Actif'
                      ? 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300'
                      : 'bg-yellow-100 dark:bg-yellow-900/20 text-yellow-800 dark:text-yellow-300'
                  }`}>
                    {employee.status}
                  </span>
                  <p className="text-sm text-gray-600 dark:text-gray-400 mt-1">
                    ⭐ {employee.performance}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Demandes de Congés
          </h3>
          <div className="space-y-3">
            <div className="p-4 border border-gray-200 dark:border-gray-600 rounded-lg">
              <div className="flex justify-between items-start">
                <div>
                  <h4 className="font-medium text-gray-900 dark:text-white">Sophie Bernard</h4>
                  <p className="text-sm text-gray-600 dark:text-gray-400">25-30 Nov 2024</p>
                </div>
                <span className="px-2 py-1 bg-yellow-100 dark:bg-yellow-900/20 text-yellow-800 dark:text-yellow-300 text-xs rounded-full">
                  En attente
                </span>
              </div>
              <div className="flex space-x-2 mt-3">
                <button className="bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded text-sm transition-colors">
                  Approuver
                </button>
                <button className="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-sm transition-colors">
                  Refuser
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Actions RH
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <button className="p-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Users className="h-5 w-5" />
            <span>Nouvel Employé</span>
          </button>
          <button className="p-4 bg-green-600 hover:bg-green-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Calendar className="h-5 w-5" />
            <span>Gérer Congés</span>
          </button>
          <button className="p-4 bg-purple-600 hover:bg-purple-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Award className="h-5 w-5" />
            <span>Évaluations</span>
          </button>
          <button className="p-4 bg-orange-600 hover:bg-orange-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Clock className="h-5 w-5" />
            <span>Horaires</span>
          </button>
        </div>
      </div>
    </div>
  );
}