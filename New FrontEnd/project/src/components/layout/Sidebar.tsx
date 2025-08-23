import React from 'react';
import { NavLink } from 'react-router-dom';
import {
  Home,
  Users,
  Zap,
  FileText,
  BarChart3,
  MessageCircle,
  AlertCircle,
  Settings,
  UserCheck,
  Wrench
} from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

interface NavItem {
  to: string;
  icon: React.ComponentType<any>;
  label: string;
  roles: string[];
}

const navigation: NavItem[] = [
  { to: '/client', icon: Home, label: 'Dashboard', roles: ['client'] },
  { to: '/admin', icon: Home, label: 'Dashboard', roles: ['admin'] },
  { to: '/supervisor', icon: Home, label: 'Dashboard', roles: ['supervisor'] },
  { to: '/technical', icon: Home, label: 'Dashboard', roles: ['technical'] },
  { to: '/hr', icon: Home, label: 'Dashboard', roles: ['hr'] },
  
  { to: '/bills', icon: FileText, label: 'Factures', roles: ['client', 'supervisor', 'admin'] },
  { to: '/consumption', icon: BarChart3, label: 'Consommation', roles: ['client', 'supervisor', 'admin'] },
  { to: '/claims', icon: AlertCircle, label: 'Réclamations', roles: ['client', 'admin', 'technical'] },
  { to: '/chatbot', icon: MessageCircle, label: 'Assistance', roles: ['client'] },
  
  { to: '/users', icon: Users, label: 'Utilisateurs', roles: ['admin', 'technical', 'hr'] },
  { to: '/meters', icon: Zap, label: 'Compteurs', roles: ['admin', 'supervisor', 'technical'] },
];

export default function Sidebar() {
  const { user } = useAuth();

  const filteredNavigation = navigation.filter(item => 
    user && item.roles.includes(user.role)
  );

  return (
    <div className="bg-white dark:bg-gray-800 w-64 min-h-screen shadow-lg border-r border-gray-200 dark:border-gray-700">
      <div className="flex items-center justify-center h-16 border-b border-gray-200 dark:border-gray-700">
        <div className="flex items-center space-x-2">
          <div className="p-2 bg-blue-600 rounded-lg">
            <Zap className="h-6 w-6 text-white" />
          </div>
          <span className="text-xl font-bold text-gray-800 dark:text-white">SmartMeter</span>
        </div>
      </div>

      <nav className="mt-8">
        <div className="px-4 space-y-2">
          {filteredNavigation.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${
                  isActive
                    ? 'bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 border-r-2 border-blue-600'
                    : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
                }`
              }
            >
              <item.icon className="mr-3 h-5 w-5" />
              {item.label}
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  );
}