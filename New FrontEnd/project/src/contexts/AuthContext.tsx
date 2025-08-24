import React, { createContext, useContext, useState, useEffect } from 'react';
import { authService, LoginRequest } from '../services/api';

export interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'client' | 'supervisor' | 'technical' | 'hr';
  avatar?: string;
  meterId?: string;
}

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
  loading: boolean;
  error: string | null;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    // Check for stored user session and token
    const storedUser = localStorage.getItem('user');
    const token = localStorage.getItem('token');
    
    if (storedUser && token) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (error) {
        // Invalid stored data, clear it
        localStorage.removeItem('user');
        localStorage.removeItem('token');
      }
    }
    setLoading(false);
  }, []);

  const login = async (email: string, password: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    
    try {
      const credentials: LoginRequest = { email, password };
      const response = await authService.login(credentials);
      
      if (response.success && response.data) {
        const { token, user: apiUser } = response.data;
        
        // Convert API user to our User interface
        const user: User = {
          id: apiUser.id,
          name: apiUser.name || email,
          email: apiUser.email,
          role: apiUser.role as User['role'],
        };
        
        console.log('User role after conversion:', user.role); // Debug
        console.log('Full user object:', user); // Debug
        
        setUser(user);
        localStorage.setItem('user', JSON.stringify(user));
        localStorage.setItem('token', token);
        setLoading(false);
        return true;
      } else {
        setError(response.error || 'Erreur de connexion');
        setLoading(false);
        return false;
      }
    } catch (error) {
      setError('Erreur de connexion au serveur');
      setLoading(false);
      return false;
    }
  };

  const logout = async () => {
    try {
      await authService.logout();
    } catch (error) {
      // Continue with logout even if API call fails
      console.error('Erreur lors de la déconnexion:', error);
    }
    
    setUser(null);
    setError(null);
    localStorage.removeItem('user');
    localStorage.removeItem('token');
    
    // Rediriger vers la page de login et nettoyer l'URL
    window.location.href = '/';
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading, error }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}