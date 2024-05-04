# ReadMe PulmoCare

## IMPORTANTE
EL PROYECTO CORRECTO ES EL QUE SE ENCUENTRA EN ramaFinal. EL MAIN SE ENCUENTRA VACÍO POR ERRORES CON EL HISTORIAL Y EL GIT GUARDIAN.

### Pasos necesarios para ejecutar la aplicación

### 1. API PulmoCare
  La API de PulmoCare se encuentra en este repositorio pero no es necesario ejecutarla, ya que esta está subida en la instancia de Oracle. El código de la app envía los mensajes a esta instancia.

### 2. API Servicio Chat GPT
   Para hacer uso de la API del servicio Chat GPT el usuario solamente se debe asegurar de que la API Key esté correctamente definida en el scheme de la aplicación. Para confirmar esto abra la app **PulmoCare** en Xcode y haga click en la parte superior central de la pantalla en donde se muestra el nombre del proyecto (justo al lado de 'Apple Vision Pro'). Esto abrirá una lista de opciones, seleccione **'Edit Scheme'**. Se abrirá una pequeña ventana en donde se visualiza la API Key, la cual debe ser la especificada en el documento de Sprint 2. En caso de que la API Key no se encuentre o sea otra a la especificada en el documento, deberá cambiarla asegurandose de que tenga como nombre **'OPENAI_API_KEY'**. Por lo tanto, se debería tener lo siguiente: 
- Name: `OPENAI_API_KEY`
- Value: `<API KEY DEL DOCUMENTO SPRINT 2 (NO ES POSIBLE COLOCARLA EN ESTE README YA QUE ES UN DATO SECRETO)>`
Una vez que se tenga correctamente la definida esta API Key, ya se podrá hacer uso de la aplicación y todas sus funcionalidades relacionadas al servicio de Chat GPT.

### Stack de PulmoCare
- Aplicación **'PulmoCare'** para Vision Pro como proyecto de Xcode
- API con la base de datos en `JavaScript`
- Base de Datos en `PostgreSQL`
- Lenguajes de Programación: `Swift` y `JavaScript`
- API del servicio ChatGPT OpenAI

### Librerías usadas para seguridad
Esta es información adicional, ya que las librerías ya están incluidas y por lo tanto no es necesario importarlas.
En App Cliente: SwiftyRSA
En API: node-forge y bcrypt
