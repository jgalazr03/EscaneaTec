const dbService = require('../config/db.js')

module.exports = {
    /*
    getAllUsers: () => {
        sql = 'SELECT id, email FROM usuarios'
        return dbService.querypromise(sql)
    },

    getUser: (id) => {
        sql = `SELECT id, email
               FROM usuarios
               WHERE id = ${id}`

        return dbService.querypromise(sql)
    },

    addUser: (body) => {
        const {email} = body
        sql = `INSERT INTO usuarios(email)
               VALUES('${email}')
               RETURNING *
               `
        return dbService.querypromise(sql)
    },

    updateUser: (id, body) => {
        const {email} = body
        sql = `UPDATE usuarios
               SET email = ('${email}')
               WHERE id = ${id}
               RETURNING *
               `
        return dbService.querypromise(sql)
    },

    deleteUser: (id) => {
        sql = `DELETE FROM usuarios 
               WHERE id = ${id} 
               RETURNING *
               `
        return dbService.querypromise(sql)
    },
    */

    registerUser: (body) => {
        const { username, email, password } = body;
        sql = `INSERT INTO usuarios(username, email, password)
               VALUES('${username}', '${email}', '${password}')
               RETURNING *`;

        return dbService.querypromise(sql);
    },

    loginUser: async (login, password) => {
        const sql = `SELECT id, username, email, password
                     FROM usuarios
                     WHERE username = '${login}' OR email = '${login}'`;
        try {
            const user = await dbService.querypromise(sql);
            if (user.length > 0 && user[0].password === password) {
                return { id: user[0].id, username: user[0].username, email: user[0].email };

            } else {
                return null;
            }
        } catch (err) {
            throw new Error(err);
        }
    },


    //Quiz

    addQuizPuntuation: (usuario_id, puntuacion, fecha) => {
        const sql = `INSERT INTO quizzes (usuario_id, puntuacion, fecha)
                     VALUES (${usuario_id}, ${puntuacion}, '${fecha}')
                     RETURNING *;`;

        return dbService.querypromise(sql);
    },

    getLastFourScoresByUserId: (usuarioId) => {
        const sql = `
            SELECT puntuacion, fecha
            FROM quizzes
            WHERE usuario_id = ${usuarioId}
            ORDER BY fecha DESC
            LIMIT 4;
        `;
        return dbService.querypromise(sql, [usuarioId]);
    },

    changeUserPassword: (userId, password) => {
        // Asume que 'newPassword' ya ha sido encriptada adecuadamente antes de llamar a este servicio
        const sql = `UPDATE usuarios SET password = '${password}' WHERE id = ${userId} RETURNING *`;
        return dbService.querypromise(sql);
    },
    
    getUserInfoById: async (userId) => {
        // Asegurarse de que userId es un número para prevenir inyecciones SQL
        const userIdNum = parseInt(userId, 10);
        if (isNaN(userIdNum)) {
            throw new Error("El ID del usuario debe ser un número");
        }
        
        const sql = `SELECT username, email FROM usuarios WHERE id = ${userIdNum}`;
        try {
            const result = await dbService.querypromise(sql);
            if (result.length > 0) {
                return result[0];
            } else {
                return null;
            }
        } catch (err) {
            throw err;
        }
    },

    getUserQuizzesInfo: async (userId) => {
        const userIdNum = parseInt(userId, 10);
        if (isNaN(userIdNum)) {
            throw new Error("El ID del usuario debe ser un número");
        }
    
        const sqlTotal = `
            SELECT COUNT(id) AS total_quizzes, 
                   ROUND(AVG(puntuacion)::numeric, 2) AS promedio_calificaciones,
                   MAX(puntuacion) AS puntuacion_maxima,
                   MIN(puntuacion) AS puntuacion_minima
            FROM quizzes
            WHERE usuario_id = ${userIdNum};
        `;
    
        try {
            const result = await dbService.querypromise(sqlTotal);
            if (result.length > 0) {
                // Convertir los valores numéricos a tipos adecuados en JavaScript
                const data = result[0];
                return {
                    total_quizzes: parseInt(data.total_quizzes, 10),
                    promedio_calificaciones: parseFloat(data.promedio_calificaciones),
                    puntuacion_maxima: parseInt(data.puntuacion_maxima, 10),
                    puntuacion_minima: parseInt(data.puntuacion_minima, 10)
                };
            } else {
                return null;
            }
        } catch (err) {
            throw err;
        }
    },
       
    getId: (name) => {
        sql = `SELECT id
               FROM usuarios
               WHERE username = '${name}'`

        return dbService.querypromise(sql)
    },
    
}