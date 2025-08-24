import React, { useState, useEffect } from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRoles: string[];
  fallbackPath: string;
}

export default function ProtectedRoute({ children, allowedRoles, fallbackPath }: ProtectedRouteProps) {
  const { user } = useAuth();
  const [showAccessDenied, setShowAccessDenied] = useState(false);

  // Si pas d'utilisateur connecté, rediriger vers login
  if (!user) {
    return <Navigate to="/" replace />;
  }

  // Vérifier si l'utilisateur a le rôle autorisé
  const hasAllowedRole = allowedRoles.includes(user.role);
  
  if (!hasAllowedRole) {
    console.log(`Accès refusé: ${user.role} n'a pas accès à cette route. Rôles autorisés: ${allowedRoles.join(', ')}`);
    
    // Déterminer la route de fallback appropriée selon le rôle
    const getFallbackRoute = () => {
      switch (user.role) {
        case 'admin':
          return '/admin';
        case 'client':
          return '/client';
        case 'supervisor':
          return '/supervisor';
        case 'technical':
          return '/technical';
        case 'hr':
          return '/hr';
        default:
          return '/client';
      }
    };

    const appropriateFallback = getFallbackRoute();
    
    // Afficher un message d'erreur temporaire avant la redirection
    useEffect(() => {
      setShowAccessDenied(true);
      const timer = setTimeout(() => {
        setShowAccessDenied(false);
      }, 3000);
      return () => clearTimeout(timer);
    }, []);

    if (showAccessDenied) {
      return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white dark:bg-gray-800 rounded-lg p-6 max-w-md mx-4">
            <div className="text-center">
              <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 dark:bg-red-900/20 mb-4">
                <svg className="h-6 w-6 text-red-600 dark:text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
                </svg>
              </div>
              <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
                Accès Refusé
              </h3>
              <p className="text-sm text-gray-600 dark:text-gray-400">
                Votre rôle ({user.role}) n'a pas les permissions nécessaires pour accéder à cette page.
              </p>
              <p className="text-xs text-gray-500 dark:text-gray-400 mt-2">
                Redirection vers votre interface dans 3 secondes...
              </p>
            </div>
          </div>
        </div>
      );
    }

    return <Navigate to={appropriateFallback} replace />;
  }

  return <>{children}</>;
}
