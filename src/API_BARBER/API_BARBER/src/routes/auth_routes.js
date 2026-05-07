const express = require('express');
const path = require('path');
const AuthControllers = require('../controllers/auth_controllers');

const router = express.Router();

router.post('/login', AuthControllers.login);
router.post('/forgot-password', AuthControllers.forgotPassword);
router.post('/reset-password', AuthControllers.resetPassword);
router.get('/reset', (req, res) => {
    res.sendFile(path.join(__dirname, '../templates/reset_password.html'));
});

module.exports = router;