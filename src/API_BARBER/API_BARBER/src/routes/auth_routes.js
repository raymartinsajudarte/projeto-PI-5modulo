const express = require('express');
const AuthControllers = require('../controllers/auth_controllers');

const router = express.Router();

router.post('/login', AuthControllers.login);
router.post('/forgot-password', AuthControllers.forgotPassword);
router.post('/reset-password', AuthControllers.resetPassword);

module.exports = router;