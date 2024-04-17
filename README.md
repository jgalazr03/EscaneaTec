Pasos necesarios para ejecutar la API

1. API PulmoCare
  La API que hace posible la conexión a la base de datos se encuentra como 'API_PulmoCare' en este repositorio. Para ejecutarla es necesario descargar la carpeta y abrirla en el editor de código de su preferencia.
A su vez es importante tener en cuenta que la API está configurada para operar con una base de datos en PostgreSQL, por lo que es necesario usar este administrador de base de datos si se desea ejecutarla sin la necesidad de realizar modificaciones.
Una vez que ya se haya considerado todo lo anterior, basta con ejecutar en la terminal el comando 'node api.js' para ejecutar la API.

2. API Servicio Chat GPT
   Para hacer uso de la API del servicio Chat GPT el usuario solamente se debe asegurar de que la API Key esté correctamente definida en el scheme de la aplicación. Para confirmar esto abra la app PulmoCare en Xcode y haga click en la parte superior central de la pantalla en donde se muestra el nombre del proyecto (justo al lado de 'Apple Vision Pro'). Esto abrirá una lista de opciones, seleccione 'Edit Scheme'. Se abrirá una pequeña ventana en donde se visualiza la API Key, la cual debe ser la especificada en el documento de Sprint 2. En caso de que la API Key no se encuentre o sea otra a la especificada en el documento, deberá cambiarla asegurandose de que tenga como nombre 'OPENAI_API_KEY'. Por lo tanto, se debería tener lo siguiente:
- Name: OPENAI_API_KEY
- Value: <API KEY DEL DOCUMENTO SPRINT 2 (NO ES POSIBLE COLOCARLA EN ESTE README YA QUE ES UN DATO SECRETO)>
Una vez que se tenga correctamente la definida esta API Key, ya se podrá hacer uso de la aplicación y todas sus funcionalidades relacionadas al servicio de Chat GPT.
