const express = require('express');
const appointmenstsControllers = require('../controllers/appointmensts_controllers');

const router = express.Router();

router.post('/', appointmenstsControllers.create);
router.get('/', appointmenstsControllers.list_shedule);

module.exports = router;