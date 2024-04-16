const pg = require('pg')
const dotenv = require('dotenv')
dotenv.config();

const Pool = pg.Pool;

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB,
    password: process.env.DB_PASSWORD,
    port: 5432
})

const querypromise = (sql) => {
    return new Promise((resolve, reject) => {
        pool.query(sql, (error, results) => { 
            if (error){
                return reject(error);
            }
            return resolve(results.rows);
        });
    });
}

module.exports = {
    pool,
    querypromise
}