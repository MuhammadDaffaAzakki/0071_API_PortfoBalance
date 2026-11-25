const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

pool.connect()
  .then(() => console.log('Terhubung ke database PostgreSQL (portfobalance_db)'))
  .catch((err) => console.error('Gagal terhubung ke PostgreSQL:', err.message));

module.exports = pool;