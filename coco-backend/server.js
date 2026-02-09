
// server.js - COCO Backend Server
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
require('dotenv').config(); // ADD THIS LINE

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'your-secret-key-change-this-in-production';
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY; // ADD THIS LINE

// Middleware
app.use(cors());
app.use(express.json());

// In-memory database (for demo - replace with real DB later)
const users = [];
const onboardingData = {};

// ============= AUTH ENDPOINTS =============

// Sign up
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    // Check if user exists
    if (users.find(u => u.email === email)) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user = {
      id: users.length + 1,
      username,
      email,
      password: hashedPassword,
      createdAt: new Date()
    };

    users.push(user);

    // Create JWT token
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET);

    res.status(201).json({
      message: 'User created successfully',
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const user = users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Create JWT token
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET);

    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// ============= ONBOARDING ENDPOINTS =============

// Save onboarding data
app.post('/api/onboarding', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;
    const data = req.body;

    onboardingData[userId] = {
      ...data,
      userId,
      completedAt: new Date()
    };

    res.json({
      message: 'Onboarding data saved successfully',
      data: onboardingData[userId]
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// Get onboarding data
app.get('/api/onboarding', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;
    const data = onboardingData[userId];

    if (!data) {
      return res.status(404).json({ error: 'No onboarding data found' });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// ============= USER ENDPOINTS =============

// Get user profile
app.get('/api/user/profile', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;
    const user = users.find(u => u.id === userId);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const userOnboarding = onboardingData[userId];

    res.json({
      id: user.id,
      username: user.username,
      email: user.email,
      onboarding: userOnboarding || null
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// ============= RECOMMENDATIONS ENDPOINT =============

// Get recommendations based on onboarding
app.get('/api/recommendations', authenticateToken, (req, res) => {
  try {
    const userId = req.user.id;
    const data = onboardingData[userId];

    if (!data) {
      return res.status(404).json({ error: 'Complete onboarding first' });
    }

    // Recommendation logic
    const recommendations = [];

    // Based on target audience
    if (data.targetAudience === 'Local customers') {
      recommendations.push('Facebook', 'Instagram');
    } else if (data.targetAudience === 'Professionals / B2B') {
      recommendations.push('LinkedIn');
    } else if (data.targetAudience === 'Students / young adults') {
      recommendations.push('TikTok', 'Instagram');
    } else if (data.targetAudience === 'Parents / families') {
      recommendations.push('Facebook', 'Instagram');
    } else if (data.targetAudience === 'Niche community') {
      recommendations.push('Instagram', 'YouTube');
    }

    // Based on business type
    if (data.businessType === 'Local business') {
      recommendations.push('Facebook', 'Instagram');
    } else if (data.businessType === 'Online store') {
      recommendations.push('Instagram', 'TikTok', 'Facebook');
    } else if (data.businessType === 'Service-based business') {
      recommendations.push('LinkedIn', 'Facebook');
    } else if (data.businessType === 'Personal brand') {
      recommendations.push('Instagram', 'TikTok', 'YouTube');
    } else if (data.businessType === 'Startup / tech') {
      recommendations.push('LinkedIn', 'Twitter');
    }

    // Remove duplicates
    const uniqueRecommendations = [...new Set(recommendations)];

    res.json({
      recommendations: uniqueRecommendations,
      basedOn: {
        targetAudience: data.targetAudience,
        businessType: data.businessType
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});
// ============= CLAUDE AI CHATBOT ENDPOINT =============

app.post('/api/claude', authenticateToken, async (req, res) => {
  try {
    const { model, max_tokens, messages, system } = req.body;

    if (!ANTHROPIC_API_KEY) {
      return res.status(500).json({ error: 'API key not configured' });
    }

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model: model || 'claude-sonnet-4-20250514',
        max_tokens: max_tokens || 4096,
        messages: messages,
        system: system || 'You are a helpful marketing assistant for COCO app.',
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json(data);
    }

    res.json(data);
  } catch (error) {
    console.error('Claude API Error:', error);
    res.status(500).json({ error: 'Error calling Claude API: ' + error.message });
  }
});

// ============= MIDDLEWARE =============

// Authenticate JWT token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; 

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
}

// ============= START SERVER =============

app.listen(PORT, () => {
  console.log(`🚀 COCO Backend running on http://localhost:${PORT}`);
  console.log(`📝 API Endpoints:`);
  console.log(`   POST /api/auth/signup`);
  console.log(`   POST /api/auth/login`);
  console.log(`   POST /api/onboarding`);
  console.log(`   GET  /api/onboarding`);
  console.log(`   GET  /api/user/profile`);
  console.log(`   GET  /api/recommendations`);
  console.log(`   POST /api/claude`); // ADD THIS LINE
  console.log(`   GET  /api/users`);
});

// get users
app.get('/api/users', (req, res) => {
  res.json(users.map(u => ({
    id: u.id,
    username: u.username,
    email: u.email,
    createdAt: u.createdAt
  })));
});