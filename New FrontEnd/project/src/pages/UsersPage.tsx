import React, { useState } from 'react';
import { Plus, Search, Edit, Trash2, UserCheck } from 'lucide-react';

export default function UsersPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedRole, setSelectedRole] = useState('all');
  
  const users = [
    {
      id: '1',
      name: 'Jean Dupont',
      email: 'jean.dupont@email.com',
      role: 'client',
      status: 'active',
      meterId: 'MTR001',
      joinDate: '2024-01-15'
    },
    {
      id: '2',
      name: 'Marie Martin',
      email: 'marie.martin@email.com',
      role: 'supervisor',
      status: 'active',
      meterId: null,
      joinDate: '2024-02-20'
    },
    {
      id: '3',
      name: 'Pierre Durand',
      email: 'pierre.durand@email.com',
      role: 'technical',
      status: 'active',
      meterId: null,
      joinDate: '2024-03-10'
    },
    {
      id: '4',
      name: 'Sophie Bernard',
      email: 'sophie.bernard@email.com',
      role: 'client',
      status: 'inactive',
      meterId: 'MTR002',
      joinDate: '2024-01-25'
    }
  ];

  const getRoleBadge = (role: string) => {
    const roleMap = {
      admin: { label: 'Admin', color: 'bg-purple-100 dark:bg-purple-900/20 text-purple-800 dark:text-purple-300' },
      client: { label: 'Client', color: 'bg-blue-100 dark:bg-blue-900/20 text-blue-800 dark:text-blue-300' },
      supervisor: { label: 'Superviseur', color: 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300' },
      technical: { label: 'Technique', color: 'bg-orange-100 dark:bg-orange-900/20 text-orange-800 dark:text-orange-300' },
      hr: { label: 'RH', color: 'bg-pink-100 dark:bg-pink-900/20 text-pink-800 dark:text-pink-300' }
    };
    
    const roleInfo = roleMap[role as keyof typeof roleMap] || roleMap.client;
    return (
      <span className={`px-2 py-1 text-xs font-medium rounded-full ${roleInfo.color}`}>
        {roleInfo.label}
      </span>
    );
  };

  const getStatusBadge = (status: string) => {
    return (
      <span className={`px-2 py-1 text-xs font-medium rounded-full ${
        status === 'active' 
          ? 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300'
          : 'bg-gray-100 dark:bg-gray-900/20 text-gray-800 dark:text-gray-300'
      }`}>
        {status === 'active' ? 'Actif' : 'Inactif'}
      </span>
    );
  };

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRole = selectedRole === 'all' || user.role === selectedRole;
    return matchesSearch && matchesRole;
  });

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Gestion des Utilisateurs
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Gérez les comptes clients et employés
          </p>
        </div>
        
        <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2">
          <Plus className="h-4 w-4" />
          <span>Nouvel Utilisateur</span>
        </button>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-4 sm:space-y-0 mb-6">
          <div className="flex items-center space-x-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <input
                type="text"
                placeholder="Rechercher un utilisateur..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white w-64"
              />
            </div>
            <select
              value={selectedRole}
              onChange={(e) => setSelectedRole(e.target.value)}
              className="px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
            >
              <option value="all">Tous les rôles</option>
              <option value="admin">Admin</option>
              <option value="client">Client</option>
              <option value="supervisor">Superviseur</option>
              <option value="technical">Technique</option>
              <option value="hr">RH</option>
            </select>
          </div>
          <div className="text-sm text-gray-600 dark:text-gray-400">
            {filteredUsers.length} utilisateur{filteredUsers.length > 1 ? 's' : ''}
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Utilisateur
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Rôle
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Statut
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Compteur
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Date d'inscription
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
              {filteredUsers.map((user) => (
                <tr key={user.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                  <td className="px-6 py-4">
                    <div>
                      <p className="font-medium text-gray-900 dark:text-white">{user.name}</p>
                      <p className="text-sm text-gray-600 dark:text-gray-400">{user.email}</p>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    {getRoleBadge(user.role)}
                  </td>
                  <td className="px-6 py-4">
                    {getStatusBadge(user.status)}
                  </td>
                  <td className="px-6 py-4">
                    {user.meterId ? (
                      <span className="text-gray-900 dark:text-white font-mono text-sm">
                        {user.meterId}
                      </span>
                    ) : (
                      <span className="text-gray-400 text-sm">-</span>
                    )}
                  </td>
                  <td className="px-6 py-4 text-gray-900 dark:text-white">
                    {new Date(user.joinDate).toLocaleDateString('fr-FR')}
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center space-x-2">
                      <button className="p-2 text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg transition-colors">
                        <Edit className="h-4 w-4" />
                      </button>
                      <button className="p-2 text-green-600 hover:bg-green-50 dark:hover:bg-green-900/20 rounded-lg transition-colors">
                        <UserCheck className="h-4 w-4" />
                      </button>
                      <button className="p-2 text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}