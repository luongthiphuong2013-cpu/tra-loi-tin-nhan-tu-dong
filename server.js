const express = require('express');
const path = require('path');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

if (!process.env.DATABASE_URL) {
  console.warn('CẢNH BÁO: chưa thiết lập biến môi trường DATABASE_URL — API sẽ báo lỗi khi gọi vào database.');
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_SSL === 'true' ? { rejectUnauthorized: false } : false
});

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Lấy toàn bộ mẫu tin, sắp theo nhóm và thứ tự
app.get('/api/templates', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM templates ORDER BY category_id ASC, sort_order ASC'
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Thêm mẫu tin mới
app.post('/api/templates', async (req, res) => {
  const { category_id, category_label, scenario_label, message_text, sort_order } = req.body;
  if (!category_id || !category_label || !scenario_label || !message_text) {
    return res.status(400).json({ error: 'Thiếu thông tin bắt buộc' });
  }
  try {
    const result = await pool.query(
      `INSERT INTO templates (category_id, category_label, scenario_label, message_text, sort_order)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [category_id, category_label, scenario_label, message_text, sort_order || 0]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Sửa nội dung mẫu tin
app.put('/api/templates/:id', async (req, res) => {
  const { message_text } = req.body;
  if (!message_text) {
    return res.status(400).json({ error: 'Thiếu nội dung mẫu' });
  }
  try {
    const result = await pool.query(
      `UPDATE templates SET message_text = $1, updated_at = now() WHERE id = $2 RETURNING *`,
      [message_text, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Không tìm thấy mẫu tin' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Xóa mẫu tin
app.delete('/api/templates/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM templates WHERE id = $1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Kiểm tra tình trạng kết nối database (hữu ích khi debug trên Vibe Host)
app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ database: 'ok' });
  } catch (err) {
    res.status(500).json({ database: 'error', message: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server đang chạy tại cổng ${port}`);
});
