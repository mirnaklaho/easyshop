const conn = require('../config/db');

// Get all offers
const getAllOffers = (req, res) => {
  const sql = 'SELECT * FROM offers';
  conn.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    return res.status(200).json(result);
  });
};

// Insert new offer
const insertOffer = (req, res) => {
  const { productId, name, image, description, oldPrice, newPrice, discount } = req.body;
  const sql = 'INSERT INTO offers (productId, name, image, description, oldPrice, newPrice, discount) VALUES (?, ?, ?, ?, ?, ?, ?)';
  conn.query(sql, [productId, name, image, description, oldPrice, newPrice, discount], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    return res.status(200).json({ message: 'Offer added successfully' });
  });
};

// Delete offer
const deleteOffer = (req, res) => {
  const { offerId } = req.body;
  const sql = 'DELETE FROM offers WHERE offerId = ?';
  conn.query(sql, [offerId], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    return res.status(200).json({ message: 'Offer deleted successfully' });
  });
};

module.exports = {
  getAllOffers,
  insertOffer,
  deleteOffer,
};
