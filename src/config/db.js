const mysql = require('mysql2');

const conn = mysql.createConnection({
  host: process.env.MYSQLHOST,
  user: process.env.MYSQLUSER,
  password: process.env.MYSQLPASSWORD,
  database: process.env.MYSQLDATABASE,
  port: process.env.MYSQLPORT
});

conn.connect((err) => {
  if (err) {
    console.log("❌ Database connection error:", err);
    return;
  }
  console.log("✅ Connected to Railway MySQL!");
});

module.exports = conn;
