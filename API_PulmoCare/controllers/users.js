const UserServices = require('../services/users.js')
const forge = require('node-forge');

function generateRSAKeyPair() {
    const keypair = forge.pki.rsa.generateKeyPair({ bits: 2048 });
    const privateKeyPEM = forge.pki.privateKeyToPem(keypair.privateKey);
    const publicKeyPEM = forge.pki.publicKeyToPem(keypair.publicKey);
    console.log("KEYS CREADAS");
    return { privateKeyPEM, publicKeyPEM };
}

let { privateKeyPEM, publicKeyPEM } = generateRSAKeyPair();



module.exports = {
    getAllUsers: async (req, res, next) => {
        try {
            const users = await UserServices.getAllUsers();
            res.json({users})
        } catch (err) {
            res.json({"message": `Error al obtener los usuarios. Err: ${err} `})
        }
    },

    getUser: async (req, res) => {
        const id = req.params.id
        try {
            const user = await UserServices.getUser(id);
            res.json({user})
        } catch (err) {
            res.json({"message": `Error al obtener los usuarios. Err: ${err} `})
        }
    },

    addUser: async (req, res) => {
        try {
            const user = await UserServices.addUser(req.body);
            res.json({user})
        } catch (err) {
            res.json({"message": `Error al obtener los usuarios. Err: ${err} `})
        }
    },

    updateUser: async (req, res) => {
        const id = req.params.id
        try {
            const user = await UserServices.updateUser(id, req.body);
            res.json({user})
        } catch (err) {
            res.json({"message": `Error al obtener los usuarios. Err: ${err} `})
        }
    },


    deleteUser: async (req, res) => {
        const id = req.params.id; 
        try {
            await UserServices.deleteUser(id);
            res.status(200).json({"message": "Usuario eliminado con éxito."});
        } catch (err) {
            res.status(500).json({"message": `Error al eliminar el usuario. Err: ${err}`});
        }
    },

    registerUser: async (req, res) => {
        try {
            const { username, email, encryptedPassword } = req.body;

            const privateKey = forge.pki.privateKeyFromPem(privateKeyPEM);
            // console.log("CONTRA ENCRIPTADA", encryptedPassword);
            const encryptedData = forge.util.decode64(encryptedPassword);
            const decryptedPassword = privateKey.decrypt(encryptedData, 'RSA-OAEP');
            // console.log("CONTRA DESENCRIPTADA", decryptedPassword);

            // Validar los parámetros y realizar el registro del usuario
            const user = await UserServices.registerUser({ username, email, decryptedPassword});
            res.json({user})
        } catch (err) {
            res.json({"message": `Error al registrar el usuario. Err: ${err} `})
        }
    },

    loginUser: async (req, res) => {
        try {
            const { login, encryptedPassword } = req.body; // 'login' puede ser tanto username como email
            const privateKey = forge.pki.privateKeyFromPem(privateKeyPEM);
            // console.log("CONTRA ENCRIPTADA", encryptedPassword);
            const encryptedData = forge.util.decode64(encryptedPassword);
            const decryptedPassword = privateKey.decrypt(encryptedData, 'RSA-OAEP');
            // console.log("CONTRA DESENCRIPTADA", decryptedPassword);

            const user = await UserServices.loginUser(login, decryptedPassword);
            if (user) {
                res.json({ user });
            } else {
                res.status(401).json({"message": "Credenciales inválidos."});
            }
        } catch (err) {
            res.status(500).json({"message": `Error en el servidor. Err: ${err} `});
        }
    },
//QUIZ
    addQuizPuntuation: async (req, res) => {
        try {
            // Asumiendo que el cuerpo de la petición contiene 'usuario_id', 'puntuacion', y 'fecha'
            const { usuario_id, puntuacion, fecha } = req.body;

            // Aquí llamarías a un método del servicio, suponiendo que tienes uno preparado para añadir una puntuación de quiz
            const quizPuntuation = await UserServices.addQuizPuntuation(usuario_id, puntuacion, fecha);

            res.status(201).json({ quizPuntuation });
        } catch (err) {
            console.error(err);
            res.status(500).json({"message": `Error al añadir la puntuación del quiz. Err: ${err}`});
        }
    },

    lastScores: async (req, res) => {
        // Ahora se obtiene el ID del usuario desde el parámetro de ruta
        const usuarioId = req.params.id;
    
        if (!usuarioId) {
            return res.status(400).json({"message": "Es necesario proporcionar el ID del usuario."});
        }
    
        try {
            const scores = await UserServices.getLastFourScoresByUserId(usuarioId);
            if (scores.length > 0) {
                res.json({scores});
            } else {
                res.status(404).json({"message": "No se encontraron puntuaciones para el usuario proporcionado."});
            }
        } catch (err) {
            console.error(err);
            res.status(500).json({"message": `Error al obtener las últimas puntuaciones. Err: ${err}`});
        }
    },
   
    changePassword: async (req, res) => {
        const userId = req.params.id;
        const { encryptedPassword } = req.body; 
    
        if (!encryptedPassword) {
            return res.status(400).json({"message": "Es necesario proporcionar la nueva contraseña cifrada."});
        }
        // console.log("CONTRA ENCRIPTADA", encryptedPassword);
    
        try {
            const privateKey = forge.pki.privateKeyFromPem(privateKeyPEM);
            const encryptedData = forge.util.decode64(encryptedPassword); // Decodificar desde Base64
            const decryptedPassword = privateKey.decrypt(encryptedData, 'RSA-OAEP');
            // console.log("CONTRA DESENCRIPTADA", decryptedPassword);

            await UserServices.changeUserPassword(userId, decryptedPassword);
            res.status(200).json({"message": "Contraseña actualizada con éxito."});
        } catch (err) {
            console.error(err);
            res.status(500).json({"message": `Error al actualizar la contraseña. Err: ${err}`});
        }
    },

    getUserInfo: async (req, res) => {
        const userId = req.params.id;
    
        try {
            const userInfo = await UserServices.getUserInfoById(userId);
            if (!userInfo) {
                return res.status(404).json({"message": "Usuario no encontrado."});
            }
            res.status(200).json(userInfo);
        } catch (err) {
            console.error(err);
            res.status(500).json({"message": `Error al recuperar la información del usuario. Err: ${err}`});
        }
    },
    
    getUserQuizzesInfo: async (req, res) => {
        const userId = req.params.id;
    
        try {
            const quizzesInfo = await UserServices.getUserQuizzesInfo(userId);
            if (quizzesInfo) {
                res.status(200).json(quizzesInfo);
            } else {
                res.status(404).json({"message": "Información de quizes no encontrada para el usuario proporcionado."});
            }
        } catch (err) {
            console.error(err);
            res.status(500).json({"message": `Error al recuperar la información de quizes. Err: ${err}`});
        }
    },

    getId: async (req, res) => {
        const name = req.params.username
        try {
            const userID = await UserServices.getId(name);
            res.json({userID})
        } catch (err) {
            res.json({"message": `Error al obtener los usuarios. Err: ${err} `})
        }
    },

    getStudy: async (req, res) => {
        try {
            const studyTable = await UserServices.getStudy();
            if (studyTable) {
                res.status(200).json(studyTable);
            } else {
                res.status(404).json({"message": "Información de la tabla Study no encontrada"});
            }
        } catch (err) {
            console.error(err);
            res.status(500).json({"message": `Error al recuperar la información de Study. Err: ${err}`});
        }
    },

    getPublicKey: (req, res) => {
        try {
            const { privateKeyPEM: newPrivateKey, publicKeyPEM: newPublicKey } = generateRSAKeyPair(); // Regenerar claves
            privateKeyPEM = newPrivateKey;
            publicKeyPEM = newPublicKey;
            res.status(200).json({ publicKey: publicKeyPEM });
        } catch (err) {
            res.status(500).json({ "message": `Error al obtener la clave pública. Err: ${err}` });
        }
    },

}