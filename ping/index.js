const express = require('express');
const http = require('http');
const app = express();
const PORT = 3000;
const PONG_SERVICE_URL = 'http://pong.default.svc.cluster.local:3000/pong';

app.get('/ping', (req, res) => {
  const request = http.request(PONG_SERVICE_URL, (response) => {
    response.on('error', (err) => {
      console.error('Error while reading from response:', err);
      res.sendStatus(502);
    });
    response.pipe(res);
  });

  request.on('error', (err) => {
    console.error('Error while making HTTP request:', err);
    res.status(500).send('Failed to connect to pong service');
  });

  request.end();
});

app.get('/health', (req, res) => {
  res.sendStatus(200);
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
