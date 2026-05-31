const http = require('http');

http.get('http://localhost:8080/app.js?v=1.2', (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    const lines = data.split('\n');
    console.log("Lines 140-160:");
    for (let i = 139; i < 160; i++) {
      console.log(`${i+1}: ${lines[i]}`);
    }
  });
}).on('error', (err) => {
  console.error("HTTP Fetch Error:", err.message);
});
