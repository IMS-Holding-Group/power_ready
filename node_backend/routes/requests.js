const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const router = express.Router();
const dbDir = path.join(__dirname, '..', 'db');
const dbPath = path.join(dbDir, 'powerready.db');

// إنشاء مجلد db إذا لم يكن موجوداً
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
}

const db = new sqlite3.Database(dbPath);

db.run('PRAGMA journal_mode = WAL');

const dbRun = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) {
        reject(err);
      } else {
        resolve({ lastID: this.lastID, changes: this.changes });
      }
    });
  });
};

const dbGet = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) {
        reject(err);
      } else {
        resolve(row);
      }
    });
  });
};

const dbAll = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) {
        reject(err);
      } else {
        resolve(rows);
      }
    });
  });
};

const createTableIfNotExists = () => {
  return dbRun(`
    CREATE TABLE IF NOT EXISTS requests (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      city TEXT NOT NULL,
      phone TEXT NOT NULL,
      created_at TEXT
    )
  `);
};

createTableIfNotExists().catch(console.error);

router.get('/', async (req, res) => {
  try {
    const requests = await dbAll('SELECT * FROM requests ORDER BY created_at DESC');
    res.json(requests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const { name, city, phone } = req.body;
    const created_at = new Date().toISOString();

    const result = await dbRun(`
      INSERT INTO requests (name, city, phone, created_at)
      VALUES (?, ?, ?, ?)
    `, [name, city, phone, created_at]);

    const request = await dbGet('SELECT * FROM requests WHERE id = ?', [result.lastID]);
    res.status(201).json(request);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

