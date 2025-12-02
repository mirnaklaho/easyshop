// controllers/uploadImageController.js

const uploadImage = (req, res) => {
    try{
  if (!req.file) {
    return res.status(400).json({ message: 'No file uploaded' });
    }
    const  filename=req.file.filename;


 return res.status(200).json({messsage:'image upload successfully',filename});
   

}catch (error){
  console.error(error);
  return res.status(200).json({messsage:'Internal server error '});
}
};

module.exports = {uploadImage};
