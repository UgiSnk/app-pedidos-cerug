const https = require('https');

const url = 'https://firestore.googleapis.com/v1/projects/pedidos-ropa-cerug/databases/(default)/documents/productos';

https.get(url, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    try {
      const json = JSON.parse(data);
      if (json.documents) {
        console.log("PRODUCTS IN FIRESTORE:");
        json.documents.forEach(doc => {
          const path = doc.name;
          const id = path.split('/').pop();
          const fields = doc.fields;
          const name = fields.nombre ? fields.nombre.stringValue : 'N/A';
          const stock = fields.stock ? fields.stock.integerValue || fields.stock.doubleValue : 'N/A';
          const control = fields.control_stock ? fields.control_stock.booleanValue : 'N/A';
          console.log(`- ID: "${id}" | Name: "${name}" | Stock: ${stock} | Control Stock: ${control}`);
        });
      } else {
        console.log("No documents found or error:", json);
      }
    } catch (e) {
      console.error("Parse/fetch error:", e, data);
    }
  });
}).on('error', (err) => {
  console.error("Error fetching products:", err);
});
