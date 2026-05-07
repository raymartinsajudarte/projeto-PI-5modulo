const express = require('express');
const iaController = require('../controllers/ia_controllers');

const router = express.Router();

router.post('/chat', iaController.chatAtendimento);

module.exports = router;