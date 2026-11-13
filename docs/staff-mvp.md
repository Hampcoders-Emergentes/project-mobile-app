# MVP operativo de ElectroLink

Implementado sobre el alcance aprobado el 12 de noviembre de 2026. El código del backend original y su configuración no se modificaron.

## Recorrido disponible

- Inicio de sesión de una cuenta existente con validación, contraseña ocultable, bloqueo de envío duplicado y almacenamiento seguro del access token.
- Restauración de identidad, descarte de token vencido y cierre de sesión ante 401. Logout elimina la navegación del detalle y de los diálogos abiertos. Un error de almacenamiento se informa y permite reintentar su eliminación.
- Locales visibles para la cuenta, incluyendo paginación. Cambio de local con protección contra respuestas tardías.
- Alertas activas primero, conteos del servidor, resumen de equipos y detalle con área/estado. Se distinguen error, lista vacía y falta de lecturas.
- Reconocimiento de alerta OPEN con confirmación y respuesta del servidor; luego se actualizan los datos. Reconocer no equivale a resolver.
- Consulta de estado para limpieza y protocolo devuelto por la API. Nunca se interpreta NORMAL como apto para limpieza. La evaluación se invalida al salir de la app y se vuelve a consultar al regresar; la confirmación favorable vence tras un minuto. UNKNOWN/UNVERIFIED/errores no muestran un resultado favorable.

Las instrucciones y motivos provenientes del servidor se muestran tal como los devuelve. Algunos textos del backend están en inglés; las etiquetas y acciones de la app están en español.

## Ejecutar Flutter

Desde la raíz de electrolink-mobile-app, con Flutter en PATH:

```sh
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8088
```

El SDK localizado en este Mac es `/Users/leoleos/Documents/Documents - Leandro’s MacBook Air/flutter/bin/flutter`. Puede usarse esa ruta completa si flutter no está en PATH. Hace falta instalar/configurar Android SDK y un emulador o teléfono antes de ejecutar Android; para iOS se necesita Xcode.

API_BASE_URL es la raíz del host: sin sufijo /api/v1. Android Emulator llega al Mac con 10.0.2.2. Un simulador que comparte el host puede usar http://127.0.0.1:8088. Para un teléfono físico se necesita una API alcanzable por red, preferiblemente HTTPS: el entorno trial actual escucha solo en loopback y no se expuso a la LAN.

## Cuenta trial y entorno aislado

Las API keys de proveedores no son una cuenta de login. Por autorización del usuario se creó una cuenta temporal con rol IAM User y titularidad de un local de demostración. No se contrató un plan de pago ni una suscripción trial de Stripe.

Credenciales: `../.local/staff-trial.json` desde esta carpeta. Ese archivo incluye URL, correo, contraseña e IDs de prueba; está excluido por .gitignore. No se incorporó ninguna credencial real al código, las pruebas, README o capturas.

El entorno local permanece disponible en http://127.0.0.1:8088. Contenedores creados únicamente para esta prueba:

| Contenedor | Función |
|---|---|
| electrolink-staff-trial-db | PostgreSQL/PostGIS independiente, publicado solo en 127.0.0.1:15433 |
| electrolink-staff-trial-api | Copia del backend con .NET 11, publicada solo en 127.0.0.1:8088 |
| electrolink-staff-trial-mqtt | Broker de prueba dentro de la red del contenedor de API, sin puerto público |

Se copió el backend a `/private/tmp/electrolink-staff-backend-trial`, excluyendo .env, bin y obj; no se editaron sus fuentes. Su esquema inicial se creó exclusivamente en la base nueva `electrolink_staff_trial`. Las claves de proveedores originales no se cargaron y los proveedores externos se deshabilitaron mediante variables del contenedor. Se usaron credenciales nuevas generadas para esta base y JWT. No se arrancó ni migró una base de datos original.

La cuenta tiene Local de prueba ElectroLink → Cocina de prueba → Refrigeradora de prueba. El equipo no tiene sensor: UNMONITORED y seguridad UNVERIFIED son respuestas correctas. Una alerta dedicada fue reconocida por la verificación HTTP; se dejó otra pendiente para probar desde la interfaz. Todo es dato temporal, no un incidente real.

Salud comprobada: GET /health devuelve 200. Los archivos y credenciales internos del entorno están en `/private/tmp/electrolink-staff-trial`; el código de la app no depende de esos archivos. La copia temporal puede perderse si el sistema limpia /private/tmp.

Para detener los servicios cuando termines:

```sh
docker stop electrolink-staff-trial-mqtt electrolink-staff-trial-api electrolink-staff-trial-db
```

Para volver a iniciar mientras existan los contenedores y la copia temporal:

```sh
docker start electrolink-staff-trial-db
# Esperar a que PostgreSQL esté listo antes de iniciar la API.
docker start electrolink-staff-trial-api
docker start electrolink-staff-trial-mqtt
```

## Arquitectura de la app

`main.dart` utiliza un StaffSession (Cubit) como único estado del recorrido operativo. La navegación autenticada tiene su propio Navigator, desechado al cerrar sesión. StaffApi mantiene el transporte, identidad local y manejo de 401. StaffRepository adapta contratos reales de locales, resumen, alertas, seguridad y protocolos. StaffDashboardController protege selección/cargas. Las pantallas y widgets están en lib/features/staff/presentation.

Se mantuvo el punto de entrada anterior en lib/legacy_app.dart y el resto de segmentos. No se modificaron los dos AuthBloc anteriores: el recorrido operativo no los utiliza. No se añadieron paquetes directos. pubspec.lock refleja los cinco paquetes transitivos ajustados por el SDK instalado al resolver dependencias; no se editó manualmente.

## Verificación y evidencia

| Comprobación | Resultado |
|---|---|
| flutter analyze --no-pub | Sin incidencias |
| flutter test --no-pub | 13 pruebas aprobadas |
| flutter build bundle --debug --no-pub | Compilación correcta |
| Prueba HTTP de StaffSession/StaffRepository contra la API Docker real | Aprobada |
| GET /health del entorno temporal | 200 |
| flutter build apk --debug --no-pub | No se pudo generar: Android SDK no instalado/configurado |
| Ejecución nativa en dispositivo o emulador | Pendiente: no hay Android SDK/Xcode ni dispositivo compatible disponible |

La prueba original de arranque se conservó con el mismo propósito, inyectando almacenamiento de sesión controlado. Ahora pasa sin esperar indefinidamente un plugin nativo. Las pruebas cubren token vencido, 401, IDs string, restauración/logout, envíos duplicados, respuesta de login tardía, errores sin filtrar detalles internos, fallo de eliminación del token, paginación, selección concurrente, error frente a vacío, consulta segura, reconocimiento y limpieza de rutas. La interfaz se comprobó a 320px con texto ampliado. Una mutación de la condición favorable para limpieza hizo fallar la prueba correspondiente y se restauró el código correcto.

Prueba real opcional, fuera de la suite offline, usando únicamente la cuenta trial:

```sh
STAFF_TRIAL_CREDENTIALS_FILE="$PWD/.local/staff-trial.json" flutter test test_live/staff_api_test.dart
```

Este comando consulta datos y reconoce solo la alerta dedicada cuyo ID figura en el archivo trial. Puede repetirse si esa alerta ya está reconocida. No reconoce la segunda alerta pendiente reservada para probar manualmente.

Las capturas [login](previews/staff-login.png) y [dashboard](previews/staff-dashboard.png) son vistas Flutter renderizadas con datos controlados para inspección visual; no son capturas de un emulador ni evidencia de hardware conectado.

## Límites de producto

La API autoriza locales por OwnerUserId, no por pertenencia a un turno. La cuenta trial es titular del local temporal y por eso puede consultar estas operaciones. El acceso delegado individual de empleados sigue fuera de alcance. Tampoco se incorporaron control de relés, registro, facturación, notificaciones en segundo plano o funcionamiento offline.

## Ejecutar en Chrome sin error CORS

La API permite el origen `http://localhost:4200`. Flutter asigna un puerto aleatorio al ejecutar solo `flutter run -d chrome`, por lo que el navegador bloquea el login aunque las credenciales sean correctas. Usar:

```sh
flutter run -d chrome --web-port=4200 --dart-define=API_BASE_URL=http://127.0.0.1:8088
```

Abrir `http://localhost:4200` (con localhost, no 127.0.0.1). En VS Code se puede elegir **ElectroLink · Chrome trial** desde Ejecutar y depurar. No se modificó CORS ni ningún archivo del backend.

Verificación posterior del error de conexión: login desde Chrome real en localhost:4200 aprobado. La API respondió 200 a sign-in, locales, dashboard-summary y alerts/active. El dashboard quedó visible y no se registraron excepciones de ejecución. El puerto aleatorio anterior no recibía Access-Control-Allow-Origin; 4200 sí está permitido por la configuración existente. No se modificó el backend.
