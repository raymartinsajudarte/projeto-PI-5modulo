const express = require('express');
const userRoutes = require('./routes/user_routes');
const authRoutes = require('./routes/auth_routes');
const servicesRoutes = require('./routes/services_routes');
const paymentsRoutes = require('./routes/payments_routes');
const appointmensRoutes = require('./routes/appointments_routes');

const cors = require('cors')
const app = express();

app.use(cors());
app.use(express.json());
app.use('/users',userRoutes);
app.use('/auth',authRoutes);
app.use('/services',servicesRoutes);
app.use('/payments',paymentsRoutes);
app.use('/uploads', express.static('uploads'));
app.use('/appointments',appointmensRoutes);

module.exports = app;