const conn = require('../config/db');
const bcrypt = require('bcryptjs');
require('dotenv').config();
const jwt = require('jsonwebtoken');

// ✅ تسجيل الدخول
const login = (req, res) => {
  const { email, password } = req.body;

  const sql = 'SELECT * FROM users WHERE email = ?';
  conn.query(sql, [email], async (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: "Invalid email" });
    }

    const user = results[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({ message: "Invalid password" });
    }

    // إنشاء التوكن مع تضمين الدور
    const token = jwt.sign(
      { id: user.id, username: user.username, email: user.email, role: user.role },
      process.env.JWT_SECRET,
    );

    //  إرسال الدور للـ frontend
    res.status(200).json({
      message: "Login successful",
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role, // هذا مهم جدًا للتطبيق
      },
    });
  });
};





// ✅ تسجيل حساب جديد
const register = async (req, res) => {
  const { username, email, password, role } = req.body; // 🔹 استقبال الدور من body

  if (!username || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  const hashPassword = await bcrypt.hash(password, 10);

  // إذا لم يُرسل الدور، افتراضيًا 'user'
  const userRole = role || 'user';

  const sql = 'INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)';
  conn.query(sql, [username, email, hashPassword, userRole], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    return res.status(201).json({ message: "User registered successfully", role: userRole });
  });
};


module.exports = {
  login,
  register,
};
