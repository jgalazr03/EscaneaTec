const dbService = require('../config/db.js')
const bcrypt = require('bcrypt');
const saltRounds = 10; // Puedes ajustar según tus necesidades de seguridad

module.exports = {
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

    registerUser: async ({ username, email, password }) => {
        try {
            const hashedPassword = await bcrypt.hash(password, saltRounds);
            const sql = `INSERT INTO usuarios(username, email, password)
                         VALUES('${username}', '${email}', '${hashedPassword}')
                         RETURNING *`;
            return await dbService.querypromise(sql);
        } catch (err) {
            throw new Error(`Error al registrar el usuario: ${err}`);
        }
    },

    loginUser: async (login, password) => {
        try {
            const sql = `SELECT id, username, email, password
                         FROM usuarios
                         WHERE username = '${login}' OR email = '${login}'`;
            const users = await dbService.querypromise(sql);
            if (users.length > 0) {
                const user = users[0];
                const match = await bcrypt.compare(password, user.password);
                if (match) {
                    return { id: user.id, username: user.username, email: user.email };
                }
            }
            return null;
        } catch (err) {
            throw new Error(`Error al iniciar sesión: ${err}`);
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

    changeUserPassword: async (userId, newPassword) => {
        try {
            const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
            const sql = `UPDATE usuarios SET password = '${hashedPassword}' WHERE id = ${userId} RETURNING *`;
            return await dbService.querypromise(sql);
        } catch (err) {
            throw new Error(`Error al actualizar la contraseña: ${err}`);
        }
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

    getStudy: async () => {
    
        const sqlTotal = `
            SELECT *
            FROM study
        `;
    
        try {
            const result = await dbService.querypromise(sqlTotal);
            if (result.length > 0) {
                const data = result.map(row => ({
                    id_enfermedad: parseInt(row.id_enfermedad, 10),
                    nombre_enfermedad: row.nombre_enfermedad,
                    informacion: row.informacion
                }));
                return data;
            } else {
                return null;
            }
        } catch (err) {
            throw err;
        }
    },
    
}