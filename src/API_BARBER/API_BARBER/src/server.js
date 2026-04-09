const app = require('./app')
const pool = require('./config/database')
require('dotenv').config()

const PORT = process.env.PORT || 3000


async function startServer() {
    try {
        const connection = await pool.getConnection()
        console.log('Banco de dados conectado com sucesso')
        connection.release()

        app.listen(PORT, () => {
            console.log(`API rodando na porta ${PORT}`)
        })

    } catch (error) {
        console.error('Erro ao conectar no banco:', error)
    }
}

startServer()