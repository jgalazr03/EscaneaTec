const express = require('express')
const router = express.Router()
const UserControllers = require('../controllers/users.js')

router.get('/', UserControllers.getAllUsers)
router.get('/:id', UserControllers.getUser)
router.post('/add', UserControllers.addUser)
router.put('/update/:id', UserControllers.updateUser)
router.delete('/delete/:id', UserControllers.deleteUser)


//Inicio/registrar
router.post('/register', UserControllers.registerUser)
router.post('/login', UserControllers.loginUser)

//Quiz
router.post('/quiz', UserControllers.addQuizPuntuation)
router.get('/lastscores/:id', UserControllers.lastScores);

//Cambiar contraseña
router.put('/changepw/:id', UserControllers.changePassword);

//Obtener datos de usuario
router.get('/userdata/:id', UserControllers.getUserInfo);

//Obtener datos de quizzes
router.get('/userquizzes/:id', UserControllers.getUserQuizzesInfo);

//Obtener la id en base al username
router.get('/getid/:username', UserControllers.getId);

//Obtener la info de Study
router.get('/getstudy/enfermedades', UserControllers.getStudy);

module.exports = router;