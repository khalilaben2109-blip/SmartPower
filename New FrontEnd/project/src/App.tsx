import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider } from './contexts/ThemeContext';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import LoginPage from './pages/LoginPage';
import DashboardLayout from './components/layout/DashboardLayout';
import ClientDashboard from './pages/ClientDashboard';
import AdminDashboard from './pages/AdminDashboard';
import SupervisorDashboard from './pages/SupervisorDashboard';
import TechnicalDashboard from './pages/TechnicalDashboard';
import HRDashboard from './pages/HRDashboard';
import BillsPage from './pages/BillsPage';
import ConsumptionPage from './pages/ConsumptionPage';
import ClaimsPage from './pages/ClaimsPage';
import ChatbotPage from './pages/ChatbotPage';
import UsersPage from './pages/UsersPage';
import MetersPage from './pages/MetersPage';
import TechnicienCompteursPage from './pages/TechnicienCompteursPage';
import TechnicienReclamationsPage from './pages/TechnicienReclamationsPage';
import ProtectedRoute from './components/ProtectedRoute';

function AppRoutes() {
  const { user } = useAuth();

  if (!user) {
    return <LoginPage />;
  }

  // Debug: afficher le rôle de l'utilisateur
  console.log('User role in AppRoutes:', user.role);
  console.log('User object:', user);

  const getDashboardRoute = () => {
    console.log('Getting dashboard route for role:', user.role);
    
    switch (user.role) {
      case 'admin':
        console.log('Routing to /admin');
        return '/admin';
      case 'client':
        console.log('Routing to /client');
        return '/client';
      case 'supervisor':
        console.log('Routing to /supervisor');
        return '/supervisor';
      case 'technical':
        console.log('Routing to /technical');
        return '/technical';
      case 'hr':
        console.log('Routing to /hr');
        return '/hr';
      default:
        console.log('Default routing to /client');
        return '/client';
    }
  };

  // Vérifier si l'utilisateur est sur la bonne route
  const currentPath = window.location.pathname;
  const expectedPath = getDashboardRoute();
  
  console.log('Current path:', currentPath);
  console.log('Expected path:', expectedPath);
  
  // Si l'utilisateur n'est pas sur la bonne route, le rediriger
  // Mais permettre l'accès aux sous-routes (comme /technical/compteurs)
  const isOnSubRoute = currentPath.startsWith('/technical/') || 
                      currentPath.startsWith('/admin/') || 
                      currentPath.startsWith('/client/') ||
                      currentPath.startsWith('/supervisor/') ||
                      currentPath.startsWith('/hr/');
  
  if (currentPath !== expectedPath && currentPath !== '/' && !isOnSubRoute) {
    console.log('Redirecting user to correct route');
    return <Navigate to={expectedPath} replace />;
  }

  return (
    <DashboardLayout>
      <Routes>
        <Route path="/" element={<Navigate to={getDashboardRoute()} />} />
        
        {/* Routes protégées par rôle */}
        <Route path="/client" element={
          <ProtectedRoute allowedRoles={['client']} fallbackPath="/">
            <ClientDashboard />
          </ProtectedRoute>
        } />
        
        <Route path="/admin" element={
          <ProtectedRoute allowedRoles={['admin']} fallbackPath="/">
            <AdminDashboard />
          </ProtectedRoute>
        } />
        
        <Route path="/supervisor" element={
          <ProtectedRoute allowedRoles={['supervisor']} fallbackPath="/">
            <SupervisorDashboard />
          </ProtectedRoute>
        } />
        
        <Route path="/technical" element={
          <ProtectedRoute allowedRoles={['technical']} fallbackPath="/">
            <TechnicalDashboard />
          </ProtectedRoute>
        } />
        
        <Route path="/hr" element={
          <ProtectedRoute allowedRoles={['hr']} fallbackPath="/">
            <HRDashboard />
          </ProtectedRoute>
        } />
        
        {/* Routes partagées selon les rôles */}
        <Route path="/bills" element={
          <ProtectedRoute allowedRoles={['admin', 'client', 'hr']} fallbackPath="/">
            <BillsPage />
          </ProtectedRoute>
        } />
        
        <Route path="/consumption" element={
          <ProtectedRoute allowedRoles={['admin', 'client', 'technical']} fallbackPath="/">
            <ConsumptionPage />
          </ProtectedRoute>
        } />
        
        <Route path="/claims" element={
          <ProtectedRoute allowedRoles={['admin', 'client', 'hr', 'technical']} fallbackPath="/">
            <ClaimsPage />
          </ProtectedRoute>
        } />
        
        <Route path="/chatbot" element={
          <ProtectedRoute allowedRoles={['admin', 'client', 'hr', 'technical', 'supervisor']} fallbackPath="/">
            <ChatbotPage />
          </ProtectedRoute>
        } />
        
        <Route path="/users" element={
          <ProtectedRoute allowedRoles={['admin']} fallbackPath="/">
            <UsersPage />
          </ProtectedRoute>
        } />
        
        <Route path="/meters" element={
          <ProtectedRoute allowedRoles={['admin', 'technical']} fallbackPath="/">
            <MetersPage />
          </ProtectedRoute>
        } />
        
        <Route path="/technical/compteurs" element={
          <ProtectedRoute allowedRoles={['technical']} fallbackPath="/">
            <TechnicienCompteursPage />
          </ProtectedRoute>
        } />
        <Route path="/technical/reclamations" element={
          <ProtectedRoute allowedRoles={['technical']} fallbackPath="/">
            <TechnicienReclamationsPage />
          </ProtectedRoute>
        } />
      </Routes>
    </DashboardLayout>
  );
}

function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <Router>
          <div className="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-300">
            <AppRoutes />
          </div>
        </Router>
      </AuthProvider>
    </ThemeProvider>
  );
}

export default App;