const express = require('express')
const servicesControllers = require('../controllers/services_controllers')
const router = express.Router()

router.get('/', servicesControllers.list)
router.get('/list', servicesControllers.list_light)

module.exports = router;