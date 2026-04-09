const express = require('express')
const paymentsControllers = require('../controllers/payments_controllers')
const router = express.Router()

router.get('/', paymentsControllers.list);

module.exports = router