const express = require('express');
const authenticateToken = require('../middleware/authMiddleWare.js');
const Router =require('express');
const router=Router();
const {login , register}=require('../controllers/user_controller.js');





router.post('/login',login);
router.post('/register',register);

module.exports=router;