const express = require('express');
const AuthControllers = require('../controllers/auth_controllers');

const router = express.Router();

router.post('/', AuthControllers.login);

module.exports = router;