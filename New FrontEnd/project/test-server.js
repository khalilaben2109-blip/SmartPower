import express from 'express';
import cors from 'cors';
const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Test endpoint
app.get('/api/test/ping', (req, res) => {
  res.json({
    message: 'Backend Spring Boot is running!',
    timestamp: Date.now(),
    status: 'success'
  });
});

// Test clients endpoint
app.get('/api/v1/clients', (req, res) => {
  res.json([
    { id: 1, name: 'Jean Dupont', email: 'jean@example.com' },
    { id: 2, name: 'Marie Martin', email: 'marie@example.com' },
    { id: 3, name: 'Pierre Durand', email: 'pierre@example.com' }
  ]);
});

// Test auth endpoint
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  if (email === 'admin@example.com' && password === 'password') {
    res.json({
      token: 'test-jwt-token-12345',
      user: {
        id: '1',
        email: 'admin@example.com',
        role: 'admin',
        name: 'Admin User'
      }
    });
  } else {
    res.status(401).json({
      message: 'Identifiants incorrects'
    });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Test server running on http://localhost:${port}`);
  console.log('Available endpoints:');
  console.log('- GET /api/test/ping');
  console.log('- GET /api/v1/clients');
  console.log('- POST /api/auth/login');
});
