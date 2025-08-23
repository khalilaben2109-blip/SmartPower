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

function AppRoutes() {
  const { user } = useAuth();

  if (!user) {
    return <LoginPage />;
  }

  const getDashboardRoute = () => {
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

  return (
    <DashboardLayout>
      <Routes>
        <Route path="/" element={<Navigate to={getDashboardRoute()} />} />
        <Route path="/client" element={<ClientDashboard />} />
        <Route path="/admin" element={<AdminDashboard />} />
        <Route path="/supervisor" element={<SupervisorDashboard />} />
        <Route path="/technical" element={<TechnicalDashboard />} />
        <Route path="/hr" element={<HRDashboard />} />
        <Route path="/bills" element={<BillsPage />} />
        <Route path="/consumption" element={<ConsumptionPage />} />
        <Route path="/claims" element={<ClaimsPage />} />
        <Route path="/chatbot" element={<ChatbotPage />} />
        <Route path="/users" element={<UsersPage />} />
        <Route path="/meters" element={<MetersPage />} />
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