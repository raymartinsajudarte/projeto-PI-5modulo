const express = require('express');
const appointmenstsControllers = require('../controllers/appointmensts_controllers');
const app = require('../app');

const router = express.Router();

router.post('/', appointmenstsControllers.create);
router.get('/', appointmenstsControllers.list_shedule);
router.get('/history', appointmenstsControllers.list_history)
router.get('/history/:id', appointmenstsControllers.list_id_history)
router.patch('/:id/cancel', appointmenstsControllers.cancel);

module.exports = router;