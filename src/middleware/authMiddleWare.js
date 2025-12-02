const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  let token = req.headers['authorization'];

  if (!token) return res.status(401).json({ message: "Token not found" });

  // لو الهيدر يبدأ بـ "Bearer " نأخذ الجزء الثاني
  if (token.startsWith("Bearer ")) {
    token = token.split(" ")[1];
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: "Invalid token" });

    req.user = user; // يحتوي على id, username, email, role
    next();
  });
};

module.exports = authenticateToken;
