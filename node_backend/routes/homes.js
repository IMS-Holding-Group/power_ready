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
    CREATE TABLE IF NOT EXISTS homes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      location TEXT NOT NULL,
      roof_area REAL NOT NULL,
      direction TEXT NOT NULL,
      shadow TEXT NOT NULL,
      monthly_consumption REAL NOT NULL,
      structural_quality TEXT,
      simulation_data TEXT,
      readiness_score REAL,
      created_at TEXT
    )
  `);
};

createTableIfNotExists().catch(console.error);

router.get('/', async (req, res) => {
  try {
    const homes = await dbAll('SELECT * FROM homes ORDER BY created_at DESC');
    res.json(homes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const home = await dbGet('SELECT * FROM homes WHERE id = ?', [id]);
    if (home) {
      res.json(home);
    } else {
      res.status(404).json({ error: 'Home not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const { name, location, roof_area, direction, shadow, monthly_consumption, structural_quality, simulation_data, readiness_score } = req.body;
    const created_at = new Date().toISOString();

    const result = await dbRun(`
      INSERT INTO homes (name, location, roof_area, direction, shadow, monthly_consumption, structural_quality, simulation_data, readiness_score, created_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [name, location, roof_area, direction, shadow, monthly_consumption, structural_quality || null, simulation_data || null, readiness_score || null, created_at]);

    const home = await dbGet('SELECT * FROM homes WHERE id = ?', [result.lastID]);
    res.status(201).json(home);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const { name, location, roof_area, direction, shadow, monthly_consumption, structural_quality, simulation_data, readiness_score } = req.body;

    const result = await dbRun(`
      UPDATE homes
      SET name = ?, location = ?, roof_area = ?, direction = ?, shadow = ?,
          monthly_consumption = ?, structural_quality = ?, simulation_data = ?, readiness_score = ?
      WHERE id = ?
    `, [name, location, roof_area, direction, shadow, monthly_consumption, structural_quality || null, simulation_data || null, readiness_score || null, id]);

    if (result.changes > 0) {
      const home = await dbGet('SELECT * FROM homes WHERE id = ?', [id]);
      res.json(home);
    } else {
      res.status(404).json({ error: 'Home not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const result = await dbRun('DELETE FROM homes WHERE id = ?', [id]);

    if (result.changes > 0) {
      res.json({ message: 'Home deleted successfully' });
    } else {
      res.status(404).json({ error: 'Home not found' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
