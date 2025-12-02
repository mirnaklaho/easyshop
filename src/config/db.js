const mysql = require('mysql2');

const conn = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'easyshop'
});

conn.connect((err) => {
  if (err) throw err;
  console.log('Connected to easyshop Database');
});

module.exports = conn;
