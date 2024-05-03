const express = require('express')
const dotenv = require('dotenv')
dotenv.config();

const app = express()
const port = process.env.PORT || 3000

app.use(express.json())
app.use(express.urlencoded({extended: true}))

app.get('/', (req, res) => {
  res.send('Página inicial Web Api!')
})

// Aquí están todas las rutas
app.use(require('./routes/routes.js'))

app.listen(port, () => {
  console.log(`Escuchando en el puerto ${port}`)
})

// Revisar error de cambio de contraseña.