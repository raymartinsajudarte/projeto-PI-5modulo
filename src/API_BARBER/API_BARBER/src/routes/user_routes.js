const express = require('express');
const upload = require('../config/upload')
const UserControllers = require('../controllers/user_controllers');


const router = express.Router();

router.get('/', UserControllers.list);
router.post('/', UserControllers.create);
router.post('/:id/foto', upload.single('foto'), UserControllers.uploadFoto)

module.exports = router;
