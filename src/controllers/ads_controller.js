const conn = require('../config/db');


  // جلب الاعلانات للمستخدم
const  getAllAds=(req,res)=>{
    const sql = 'select * from ads';
    conn.query(sql,(err,results)=>{

        if(err){
            return res.status(500).json({error:err.message});
        }
        else{
            return res.status(200).json(results);
        }
    });
};



 // اضافة اعلان مهمة الادمن 
const  insertAds=(req,res)=>{
    const 	image=req.body.	image;
    const product_id=req.body.product_id;
    const category_id=req.body.category_id;
    const sql = 'insert into Ads (	image,product_id,category_id) values(?,?,?)';
    conn.query(sql,[	image,product_id,category_id],(err,results)=>{
        if(err){
            return res.status(500).json({error:err.message});
        }
        else{
            return res.status(200).json({message:"inserted successfully"});
        }
    });
};


// حذف  اعلان مهمة الادمن
const deleteAds=(req,res)=>{
    const id=req.body.id;
   
    const sql = 'delete from ads where id = ?';
    conn.query(sql,[id],(err,results)=>{
        if(err){
            return res.status(500).json({error:err.message});
        }
        else{
            return res.status(200).json({message:"deleted successfully"});
        }
    });
};

 // تحديث الاعلان من مهمة الادمن
const updateAds=(req,res)=>{
    const id=req.body.id;
    const 	image=req.body.	image;
    const product_id=req.body.product_id;
    const category_id=req.body.category_id;
    const sql = 'update ads set 	image=? , product_id=? , category_id=?  id=?';
    conn.query(sql,[image,product_id,category_id,id],(err,results)=>{
        if(err){
            return res.status(500).json({error:err.message});
        }
        else{
            return res.status(200).json({message:"deleted successfully"});
        }
    });
};


module.exports={
  insertAds,
  deleteAds,
  updateAds,
  getAllAds
}