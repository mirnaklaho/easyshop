const conn = require('../config/db');




// Get all offers
const getAllOffers = (req, res) => {
    const sql = `
      SELECT *, 
             ROUND(((oldPrice - price) / oldPrice) * 100) AS discountPercent
      FROM products
      WHERE isOffer = 1 AND oldPrice IS NOT NULL AND price < oldPrice
      ORDER BY discountPercent DESC
    `;

    conn.query(sql, (err, offers) => {
        if (err) return res.status(500).json({ error: err.message });
        return res.status(200).json(offers);
    });
};


// Get all products with their images
const getAllProducts = (req, res) => {
    const sql = 'SELECT * FROM products';
    conn.query(sql, (err, products) => {
        if (err) return res.status(500).json({ error: err.message });

        // جلب الصور لكل منتج من جدول images
        const productIds = products.map(p => p.id);
        if (productIds.length === 0) return res.status(200).json(products);

        const sqlImages = 'SELECT * FROM images WHERE productId IN (?)';
        conn.query(sqlImages, [productIds], (err2, images) => {
            if (err2) return res.status(500).json({ error: err2.message });

            // ربط الصور مع المنتج المناسب
  const productsWithImages = products.map(p => {
    // المنتج الأساسي بدون تعديل
    const mainProduct = { ...p };

    // الصور الفرعية مع بياناتها الخاصة
    const subImages = images
        .filter(img => img.productId === p.id)
        .map(i => ({
            image: i.image,
            name: i.name,
            price: i.price,
            description: i.description
        }));

    return { ...mainProduct, subImages }; // استخدم حقل مختلف للصور الفرعية
});



            return res.status(200).json(productsWithImages);
        });
    });
};

// Insert a new product with optional images
const insertProduct = (req, res) => {
    const { name, price, image, categoryId, description, numberOfSeen, images } = req.body;
    const sql = 'INSERT INTO products (name, price, image, categoryId, description, numberOfSeen) VALUES (?, ?, ?, ?, ?, ?)';
    conn.query(sql, [name, price, image, categoryId, description, numberOfSeen], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });

        const productId = result.insertId;

        if (images && images.length > 0) {
            const sqlImages = 'INSERT INTO images (productId, image) VALUES ?';
            const data = images.map(img => [productId, img]);
            conn.query(sqlImages, [data], (err2) => {
                if (err2) return res.status(500).json({ error: err2.message });
                return res.status(200).json({ message: "Product inserted successfully with images" });
            });
        } else {
            return res.status(200).json({ message: "Product inserted successfully" });
        }
    });
};

// Delete product and its images
const deleteProduct = (req, res) => {
    const { id } = req.body;
    const sqlDeleteImages = 'DELETE FROM images WHERE productId = ?';
    const sqlDeleteProduct = 'DELETE FROM products WHERE id = ?';

    conn.query(sqlDeleteImages, [id], (err) => {
        if (err) return res.status(500).json({ error: err.message });

        conn.query(sqlDeleteProduct, [id], (err2) => {
            if (err2) return res.status(500).json({ error: err2.message });
            return res.status(200).json({ message: "Product and its images deleted successfully" });
        });
    });
};

// Update product and optionally its images
const updateProduct = (req, res) => {
    const { id, name, price, image, categoryId, description, numberOfSeen, images } = req.body;
    const sql = 'UPDATE products SET name = ?, price = ?, image = ?, categoryId = ?, description = ?, numberOfSeen = ? WHERE id = ?';
    conn.query(sql, [name, price, image, categoryId, description, numberOfSeen, id], (err) => {
        if (err) return res.status(500).json({ error: err.message });

        if (images && images.length > 0) {
            const sqlDeleteOldImages = 'DELETE FROM images WHERE productId = ?';
            conn.query(sqlDeleteOldImages, [id], (err2) => {
                if (err2) return res.status(500).json({ error: err2.message });

                const sqlInsertImages = 'INSERT INTO images (productId, image) VALUES ?';
                const data = images.map(img => [id, img]);
                conn.query(sqlInsertImages, [data], (err3) => {
                    if (err3) return res.status(500).json({ error: err3.message });
                    return res.status(200).json({ message: "Product updated successfully with new images" });
                });
            });
        } else {
            return res.status(200).json({ message: "Product updated successfully (images unchanged)" });
        }
    });
};

module.exports = {
    getAllProducts,
    insertProduct,
    deleteProduct,
    updateProduct,
    getAllOffers
};
