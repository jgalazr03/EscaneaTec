# PulmoCare ReadMe

**Importante:**
El código fuente correcto y actualizado se encuentra en la rama `ramaFinal`. La rama `main` está vacía debido a problemas con el historial y GitGuardian.

## Cómo Ejecutar la Aplicación

### 1. API PulmoCare
La API de PulmoCare ya está desplegada y operativa en una instancia de Oracle Cloud, por lo que no es necesario ejecutarla localmente. El código de la aplicación envía peticiones directamente a esta instancia.

### 2. API del Servicio Chat GPT
Para utilizar la API de Chat GPT, asegúrate de que la clave API esté configurada correctamente en el esquema de la aplicación:
- Abre la aplicación **PulmoCare** en Xcode.
- Haz clic en el nombre del proyecto en la parte superior central de la pantalla, al lado de 'Apple Vision Pro', y selecciona **'Edit Scheme'**.
- En la ventana que aparece, verifica que la clave API figure como sigue:
  - Name: `OPENAI_API_KEY`
  - Value: `<API KEY DEL DOCUMENTO SPRINT 3>` (Nota: La clave API es un dato sensible y no se incluye en este README).

Una vez configurada la clave API, la aplicación estará lista para usar todas las funcionalidades del servicio de Chat GPT.

## Stack Tecnológico

- **Aplicación:** PulmoCare para Vision Pro (Proyecto de Xcode)
- **API:** Escrita en JavaScript
- **Base de Datos:** PostgreSQL
- **Lenguajes de Programación:** Swift y JavaScript
- **API Externa:** ChatGPT de OpenAI

## Librerías de Seguridad
Las siguientes librerías de seguridad están preinstaladas y configuradas:
- **En la Aplicación Cliente:** SwiftyRSA
- **En la API:** node-forge, bcrypt

Estas librerías ya están incluidas en el proyecto, por lo que no es necesario instalarlas manualmente.
