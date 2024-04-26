const express = require('express');
const app = express();
const PORT = 3000;

app.get('/pong', (req, res) => {
  // Comment out the line below
  res.send('pong');
  // Uncomment the line below
  // res.send('foobar');
});

app.get('/health', (req, res) => {
  res.sendStatus(200);
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
