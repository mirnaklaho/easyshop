const conn = require('../config/db');

const getAllCategories = (req, res) => {
    const sql = 'SELECT * FROM categories';
    conn.query(sql, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        return res.status(200).json(results);
    });
};

const insertCategory = (req, res) => {
    const { name, icon } = req.body;
    const sql = 'INSERT INTO categories (name, icon) VALUES (?, ?)';
    conn.query(sql, [name, icon], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        return res.status(200).json({ message: 'Category inserted successfully' });
    });
};

const deleteCategory = (req, res) => {
    const { id } = req.body;
    const sql = 'DELETE FROM categories WHERE id = ?';
    conn.query(sql, [id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        return res.status(200).json({ message: 'Category deleted successfully' });
    });
};

const updateCategory = (req, res) => {
    const { id, name, icon } = req.body;
    const sql = 'UPDATE categories SET name = ?, icon = ? WHERE id = ?';
    conn.query(sql, [name, icon, id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        return res.status(200).json({ message: 'Category updated successfully' });
    });
};




const getProductsByCategory = (req, res) => {
    const { categoryId } = req.params; // id الفئة
    const sqlProducts = 'SELECT * FROM products WHERE categoryId = ?';
    
    conn.query(sqlProducts, [categoryId], (err, products) => {
        if (err) return res.status(500).json({ error: err.message });
        
        const productIds = products.map(p => p.id);
        if (productIds.length === 0) return res.status(200).json(products);
        
        const sqlImages = 'SELECT * FROM images WHERE productId IN (?)';
        conn.query(sqlImages, [productIds], (err2, images) => {
            if (err2) return res.status(500).json({ error: err2.message });

            const productsWithImages = products.map(p => {
                const imgs = images
                    .filter(i => i.productId === p.id)
                    .map(i => i.image);
                return { ...p, images: imgs }; // أضفنا حقل images
            });

            return res.status(200).json(productsWithImages);
        });
    });
};

module.exports = {
    getAllCategories,
    insertCategory,
    deleteCategory,
    updateCategory,
    getProductsByCategory
};
