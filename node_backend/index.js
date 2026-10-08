const express = require('express');
const cors = require('cors');
const path = require('path');
const homesRouter = require('./routes/homes');
const requestsRouter = require('./routes/requests');
const providersRouter = require('./routes/providers');

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

app.use('/api/homes', homesRouter);
app.use('/api/requests', requestsRouter);
app.use('/api/providers', providersRouter);

app.get('/', (req, res) => {
  res.json({ message: 'PowerReady API Server' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
