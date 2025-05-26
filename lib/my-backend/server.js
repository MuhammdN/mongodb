const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors()); // Allow requests from Flutter app
app.use(express.json());

// ✅ Replace with your MongoDB connection string
mongoose.connect('your_mongodb_connection_string_here')
  .then(() => console.log('✅ MongoDB Connected'))
  .catch(err => console.error('❌ MongoDB Error:', err));

// ✅ Schema
const userSchema = new mongoose.Schema({
  username: String,
  password: String,
}, { collection: 'data' });

const User = mongoose.model('User', userSchema);

// ✅ Root route
app.get('/', (req, res) => {
  res.send('🚀 Backend is working!');
});

// ✅ Add new user
app.post('/users', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: 'Username and password required' });
  }

  try {
    const newUser = new User({ username, password });
    await newUser.save();
    res.status(200).json({ message: 'User saved successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Error saving user', error: err });
  }
});

// ✅ Get all users
app.get('/users', async (req, res) => {
  try {
    const users = await User.find({});
    res.status(200).json(users);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching users', error: err });
  }
});

// ✅ Listen
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
