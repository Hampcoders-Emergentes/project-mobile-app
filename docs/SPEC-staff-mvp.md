# Especificación: MVP Flutter para trabajadores del local

Estado: alcance aprobado por el usuario e implementado; validación nativa pendiente por falta de SDK Android. Fecha: 12 de noviembre de 2026.
Referencia: analisis-backend-staff.md. El resultado y sus límites están documentados en staff-mvp.md.

## Objetivo y supuestos

Entregar un recorrido pequeño para personal operativo y de limpieza: iniciar sesión, consultar un local, revisar equipos/alertas y consultar el estado del equipo antes de limpieza. El backend existente permanece intacto.

Se usarán cuentas existentes y un backend con locales y equipos ya registrados. La API actual autoriza por titularidad IAM; no existe delegación a un trabajador mediante su turno. La demo integrada requiere una cuenta de prueba con titularidad. Una cuenta de empleado sin locales debe recibir un estado vacío explícito. No se asumirán nuevos permisos ni se compartirán credenciales como solución de producción.

Se mantiene Flutter, Material y los paquetes presentes: flutter_bloc, Dio, equatable y flutter_secure_storage. No hace falta una plataforma adicional ni nuevas dependencias para este alcance. No se incluirán datos ficticios en el flujo conectado.

## Funcionalidad y aceptación

1. Login de correo y contraseña con validación visible, ocultación de contraseña, bloqueo de envío duplicado, carga y error comprensible. POST /api/v1/auth/sign-in. userId se conserva como String. No se ofrece registro como empresa en el acceso operativo.
2. Una sesión compartida guarda el token con almacenamiento seguro. Login y restauración desembocan en el mismo dashboard operativo. Token ausente/vencido o respuesta 401 limpia memoria y almacenamiento y vuelve al login. Fallo de red permite reintentar; no fuerza alta de perfil de empresa.
3. GET /api/v1/stores lista locales accesibles, respetando hasMore mediante carga de páginas. Se selecciona el primero si existe y se permite cambiarlo. Cero locales muestra un mensaje y la posibilidad de reintentar/cerrar sesión. No se solicita introducir un storeId ajeno.
4. Dashboard usa GET /api/v1/stores/{id}/dashboard-summary: nombre del local, hora de actualización, conteos de equipos y alertas y lista de equipos con área y estado en español. Estado textual además del color. Sin sensores/datos conserva estados desconocido o no monitorizado.
5. GET .../alerts/active muestra las alertas activas y sus conteos. Hasta 100 elementos según contrato; los conteos globales no se calculan contando esa lista truncada. El usuario puede reconocer una alerta OPEN mediante el POST de acknowledgement del equipo. El botón se bloquea mientras guarda y el resultado se confirma con el servidor/refresco. El texto deja claro que reconocer no resuelve la incidencia.
6. Desde un equipo se consulta GET .../safety-status y GET .../shutdown-protocol. Se muestran el estado, motivos, fecha y pasos devueltos por la API. No se calcula la seguridad a partir de NORMAL o de cero alertas. Error, datos antiguos o estado desconocido no muestran una confirmación favorable.
7. Actualización manual con indicador de carga. Al cambiar local no quedan datos del anterior ni se sobrescribe la selección nueva con una respuesta tardía. Al regresar desde segundo plano se invalida/refresca la consulta de limpieza; no se presenta una evaluación antigua como vigente.
8. Cierre de sesión desde dashboard limpia token y navegación; volver atrás no revela la sesión anterior.
9. Diseño en español, tamaños de toque cómodos, scroll en pantallas pequeñas, contraste legible y estados vacíos/errores con acción. Mantener identidad azul marino/amarillo de ElectroLink. Pantallas esenciales: login, dashboard y detalle del equipo; sin navegación de facturación/empresa para este segmento.

## Contrato y límites

Toda ruta humana usa Bearer; ninguna API key Edge va en Flutter. Identificadores se codifican al construir rutas. Se toma actor del servidor, nunca de un parámetro de propietario fabricado. Errores 401, 403, 404, 409, 429 y problemas de conexión deben producir mensajes y acciones adecuados sin mostrar trazas internas. Los DTO admiten campos opcionales del contrato y conservan estados desconocidos de forma conservadora.

Base URL configurable mediante --dart-define=API_BASE_URL; se documentarán emulador Android, simulador y dispositivo físico. El valor es la raíz del host, sin /api/v1 duplicado. HTTPS para backend desplegado; configuración local según plataforma. El proyecto solo trae android/ios: no se añadirá plataforma web como parte del MVP.

Fuera de alcance: registro, recuperación de contraseña, delegación IAM de empleados, configuración del local, cambios de backend, migraciones, altas/vínculos IoT, control remoto de relés, asignación/resolución de incidencias, reportes manuales, turnos, relevo, pagos, gráficas analíticas, SignalR, alarmas en segundo plano y operación offline. Son ampliaciones posibles, no requisitos de entrega.

## Organización prevista

- lib/core/auth y lib/core/network: sesión y configuración de red compartida.
- lib/features/staff/domain: modelos simples del contrato y repositorio.
- lib/features/staff/data: llamadas reales a locales, resumen, alertas y seguridad.
- lib/features/staff/presentation: estado y pantallas de este recorrido.
- lib/features/auth/presentation/screens y lib/main.dart: entrada y navegación coherentes.
- test/: pruebas de sesión, contratos y recorrido con dobles en el límite HTTP/almacenamiento.
- docs/: análisis, especificación y guía de ejecución/verificación.

No se reescriben las pantallas de los demás segmentos. Se elige un único propietario del estado de sesión para el recorrido operativo, con cambios mínimos sobre el código compartido. Dart con null safety, nombres por responsabilidad y dart format. Ejemplo del contrato de ruta: `String dashboard(String storeId) => '/api/v1/stores/${Uri.encodeComponent(storeId)}/dashboard-summary';`.

## Comandos y validación

Desde la raíz de la app y con Flutter en PATH:

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8088
```

Para simulador conectado al host se usa la dirección apropiada; para teléfono físico se requiere IP LAN alcanzable o HTTPS desplegado. Android SDK/Xcode y un dispositivo configurado son requisitos del build/runtime de cada plataforma. No se considera validado un APK si no llegó a construirse.

Pruebas prioritarias: token expirado/restauración/401; IDs string y rutas canónicas; paginación y lista vacía de locales; cambio de local con respuesta tardía; ausencia de datos frente a error; acknowledgement sin confirmar antes de respuesta; evaluación de limpieza desconocida/antigua; login→dashboard→logout con HTTP controlado. Antes de cambios conductuales, reproducir fallos con pruebas focalizadas. La prueba inicial existente falla por timeout y debe quedar corregida sin omitirla.

Criterio de calidad: analizador sin errores ni advertencias introducidas, suite sin pruebas omitidas, ausencia de secretos y verificación de interfaz en dispositivo o emulador cuando esté disponible. Verificar integración real con una cuenta de prueba autorizada y registrar por separado los checks que no se pudieron ejecutar. No rebajar checks para declarar éxito.

## Límites de modificación

Siempre: preservar archivos y datos existentes, documentar configuración y resultados reales, mantener reglas de negocio en la API, distinguir datos no disponibles de cero.

Consultar antes de ampliar: cambios de permisos/backend, dependencias nuevas, publicación, creación de usuarios o datos reales para probar operaciones.

Nunca: modificar backend, aplicar migraciones, incluir contraseñas/API keys, usar IDs de perfiles como usuarios, presentar una alerta reconocida como reparación completada, afirmar que la cuenta de staff tiene permisos que la API no concede.

## Aprobación y resultado

El usuario aprobó el alcance y autorizó crear una cuenta temporal. Implementación disponible en lib/features/staff y lib/main.dart. El backend original se conservó intacto; para la prueba HTTP se ejecutó una copia idéntica en Docker con una base aislada, cuenta y datos temporales. No se alteró una base existente. Trece pruebas locales y una prueba contra la API real pasan. El bundle compila; APK y ejecución en dispositivo quedan pendientes por ausencia de SDK Android/Xcode. Detalles en staff-mvp.md.
