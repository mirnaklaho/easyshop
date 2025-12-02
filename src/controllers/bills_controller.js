const conn = require('../config/db');

// إدخال فاتورة جديدة
const insertBill = (req, res) => {
    const email = req.body.email;   // الإيميل
    const total = req.body.total;   // المجموع الكلي للفاتورة

    const sql = 'INSERT INTO bills (email, total) VALUES (?, ?)';
    conn.query(sql, [email, total], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        } else {
            const insertedId = results.insertId; // الحصول على id الفاتورة الجديدة
            return res.status(200).json({ 
                message: 'done', 
                id: insertedId 
            });
        }
    });
};

const getAllBills = (req, res) => {
  const { email } = req.body;

  let sql = 'SELECT * FROM bills';
  const params = [];

  if (email) {
    sql += ' WHERE email = ?';
    params.push(email);
  }

  conn.query(sql, params, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    return res.status(200).json(results);
  });
};



// تأكيد الفاتورة (تحديث الحالة)
const confirmBill = (req, res) => {
    const billId = req.body.billId; // رقم الفاتورة المطلوب تأكيدها

    if (!billId) {
        return res.status(400).json({ error: "billId مطلوب" });
    }

    const sql = 'UPDATE bills SET state = ? WHERE id = ?';
    conn.query(sql, ['paid', billId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: "الفاتورة غير موجودة" });
        }

        return res.status(200).json({ message: "تم تأكيد الفاتورة بنجاح" });
    });
};

//  رفض الفاتورة (تحديث الحالة)
const rejectBill = (req, res) => {
    const billId = req.body.billId; // رقم الفاتورة المطلوب رفضها

    if (!billId) {
        return res.status(400).json({ error: "billId مطلوب" });
    }

    const sql = 'UPDATE bills SET state = ? WHERE id = ?';
    conn.query(sql, ['rejected', billId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: "الفاتورة غير موجودة" });
        }

        return res.status(200).json({ message: "تم رفض الفاتورة بنجاح" });
    });
};

module.exports = {
    insertBill,
    getAllBills,
    confirmBill,
    rejectBill, 
};
