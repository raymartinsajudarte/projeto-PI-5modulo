const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
    destination: (req, file, cb) => {cb(null, 'uploads/')},
    filename: (req, file, cb) => {
        const ext = path.extname(file.originalname);
        cb(null, `user_${req.params.id}_${Date.now()}${ext}`)
    }
});

const upload = multer({
    storage, 
    limits: {fileSize: 2 * 1024 * 1024}, //2mb
    filefilter: (req, file, cb) => {
        if (file.mimetype.startsWith('image/')) {
            cb(null, true)
        } else {
            cb(new Error('Apenas imagens são permitidas'), false)
        }
    },
});

module.exports = upload