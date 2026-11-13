# Análisis del backend e integración del segmento 1

Fecha de revisión: 12 de noviembre de 2026. Fuente: código del disco externo.
Estado: revisión estática del backend y diagnóstico inicial de Flutter. No se modificaron archivos del backend, no se arrancó la API ni se ejecutaron migraciones o escrituras contra sus datos. Las operaciones reales con credenciales no se han verificado.

## 1. Estructura y responsabilidades

La carpeta backend-api reúne tres aplicaciones. electrolink-backend-api es un monolito modular ASP.NET Core con bounded contexts y persistencia PostgreSQL/EF Core. electrolink-edge-api es un gateway FastAPI con SQLite y sincronización mediante requests. ElectrolinkIot contiene el firmware Arduino/ESP32 y sus sensores y actuadores. Flutter debe consumir la API principal con identidad humana; no necesita una API key Edge.

| Contexto | Responsabilidad observada | Integración relevante |
|---|---|---|
| IAM | Cuentas, contraseñas, access tokens, refresh tokens, roles de acceso y auditoría | Consulta claims en Profiles, publica eventos de registro y carga el usuario real en cada petición |
| Profiles | Perfil personal, empresa, propietario, técnico y StaffMember | Resuelve IDs y claims para IAM; expone certificación y disponibilidad a otros contextos |
| Assets | Propiedades, portfolios, dispositivos, componentes e inventarios | Verifica pertenencia y dispositivos; reserva y consume stock para servicios |
| Planning | Catálogos, recetas, solicitudes, matching y asignación | Consulta Profiles, Assets y Subscriptions; crea ejecuciones mediante Monitoring |
| Monitoring | Ejecución de trabajos técnicos, fotos, informes, componentes, finalización y evaluación | Consulta Planning/Assets y coordina operaciones IoT con Processing |
| Processing | Streams de lecturas, anomalías y comandos de relé; entrada Edge | Intenta primero la ruta de equipos vinculados en StoreManagement y conserva una ruta previa para streams no vinculados |
| StoreManagement | Locales, áreas, equipos, vínculo IoT, telemetría, umbrales, dashboard, seguridad, turnos y cumplimiento | Publica fachadas de acceso, mediciones, turnos y rutas de notificación; consume conteos de AlertManagement |
| AlertManagement | Materialización, historial, reconocimiento, reportes manuales, asignación, resolución y despacho de alertas | Recibe detecciones, consulta turnos y acceso al local, publica eventos y planifica notificaciones |
| Analytics | Consumo, costos, proyecciones, reportes y métricas de técnicos | Usa un puerto de mediciones adaptado a StoreManagement para analítica por local |
| Subscriptions | Planes, elegibilidad, cuotas, facturación e integración Stripe | Expone elegibilidad a Planning y consulta dispositivos de Assets |
| Shared | IDs tipados, errores, persistencia común, eventos y proveedores | Infraestructura transversal; no es una pantalla o segmento |

Evidencia principal: Program.cs y los archivos Infrastructure/.../WebApplicationBuilderExtensions.cs de cada contexto. Los contextos se registran en el mismo contenedor DI y proceso. Una clase llamada ExternalProfilesService o ExternalMonitoringService no implica por sí sola una llamada HTTP: hay adaptadores que invocan fachadas dentro del monolito.

## 2. Cómo viaja una petición y dónde vive la lógica

El recorrido habitual es: ruta REST → middleware de identidad/autorización → resource/assembler y command/query → servicio de aplicación → agregado o política de dominio → repositorio → EF Core/PostgreSQL → resource JSON.

Los controllers adaptan HTTP, obtienen el actor y traducen resultados y excepciones. Los servicios de aplicación coordinan consultas, reglas y guardados. Los agregados y políticas contienen invariantes y transiciones. Los repositorios implementan filtros y persistencia. Flutter debe representar las respuestas de esos contratos y no reimplementar las reglas eléctricas o la autorización.

En StoreManagement los records de commands, queries y resources suelen estar junto al servicio de aplicación. Otros módulos usan carpetas Domain/Model/Commands, Domain/Services, Application/Internal y Interfaces/REST/Transform. La organización no es uniforme: conviene buscar el tipo y su implementación, no asumir una única estructura.

Program.cs establece JSON con nombres camelCase y enums por nombre, configura errores unificados, idempotencia para endpoints marcados y límites de peticiones. El cliente debe admitir errores estructurados y respuestas sin cuerpo cuando corresponda. Las rutas canónicas de autenticación están en /api/v1/auth; /api/v1/authentication se conserva como alias legado.

## 3. Conexiones entre bounded contexts

Hay tres mecanismos distintos:

1. **Consultas y comandos síncronos mediante fachadas/puertos.** Interfaces/ACL publica contratos. Application/Internal/OutboundServices y adaptadores Infrastructure/ACL traducen al contrato del otro módulo. Por ejemplo, Planning consulta stock/propiedad en IAssetsContextFacade y cuotas en ISubscriptionContextFacade. Monitoring expone CreateServiceExecutionAsync. Profiles expone GetProfileClaimsAsync(userId). Analytics recibe mediciones mediante IStoreMeasurementPort y StoreManagementMeasurementAdapter.
2. **Eventos en proceso.** MediatR distribuye eventos a handlers. UserRegisteredEvent activa creación de perfil. ServiceAutomaticallyAssignedEventHandler consulta la solicitud y pide crear la ejecución a Monitoring; registra un error si falla esa creación. Hay handlers que solo escriben logs y otros que ejecutan efectos reales: no se puede deducir un efecto solo por el nombre del evento.
3. **Outbox persistente.** IntegrationEventPublisher añade un OutboxMessage y el worker consulta mensajes pendientes, publica con MediatR, aplica reintentos y marca procesados o dead letter. No todos los eventos usan outbox. Además, aunque el comentario del publisher dice que no guarda, su implementación llama a SaveChangesAsync. Por tanto, no se puede afirmar atomicidad global de todos los contextos basándose en ese comentario.

AppDbContext contiene persistencia compartida de los módulos tradicionales. StoreManagementDbContext gestiona el modelo de locales y también las alertas y su despacho. En la ingesta de equipos vinculados se preparan medición, alerta y despachos y luego se guardan mediante el contexto compartido; la publicación de alertas ocurre después del guardado. Esta operación concreta no equivale a una transacción distribuida entre todos los bounded contexts.

Evidencia: Shared/Application/Internal/EventPublisher/IntegrationEventPublisher.cs, Shared/Infrastructure/BackgroundServices/OutboxProcessorBackgroundService.cs, StoreManagement/Infrastructure/Configuration/WebApplicationBuilderExtensions.cs, StoreManagement/Application/EquipmentTelemetryService.cs y AlertManagement/Application/AlertService.cs.

## 4. Autenticación, identificadores y limitación de staff

POST /api/v1/auth/sign-in recibe email y password. UserCommandService busca el usuario, verifica el hash y estado activo, consulta claims de Profiles, emite access token y refresh token y persiste la sesión. AuthenticatedUserResource contiene userId, email, token y refreshToken: **no contiene role**.

El JWT incorpora la identidad IAM y, cuando existe, profileId, profileStatus, businessRole, roleSubjectId y subscriptionTier. El rol de acceso y el rol de negocio son dimensiones distintas. AccessRole contiene User, Admin, SuperAdmin, Maker y FieldManager; ninguno significa automáticamente trabajador operativo de un local. No se deben confundir us-..., prof-..., el identificador de empresa, un código de trabajador y store-.... La lectura local de claims sirve para navegación; la autoridad sigue siendo el backend.

RequestAuthorizationMiddleware valida el token, vuelve a obtener la cuenta y rechaza cuentas inexistentes o inactivas. Guarda el User resuelto en HttpContext.Items. Los controllers de locales usan actor.Id de ese usuario, sin aceptar un ownerId impuesto por la app. El acceso Edge solo se admite en endpoints expresamente habilitados, con su key; no autoriza las pantallas humanas.

**Limitación confirmada:** StoreHierarchyRepository filtra locales mediante s.OwnerUserId == actor. StoreHierarchyService exige esa misma pertenencia para equipos y áreas. Los turnos contienen WorkerCode, WorkerName y Role; la fachada IStaffRosterFacade devuelve quién estaba de turno, pero no concede permisos IAM al local. Profiles.StaffMember tampoco participa en ese filtro de pertenencia.

Consecuencia: puede construirse una interfaz para el segmento operativo con los endpoints existentes, pero una cuenta individual de trabajador sin titularidad verá una lista vacía o 404. Crear un rol Flutter staff, elegir un local por ID o completar un perfil no resuelve esa restricción. Para una demostración integrada se necesita una cuenta de prueba autorizada que ya tenga local y equipos. Un esquema de acceso individual de empleados exige una decisión y trabajo de backend posterior, fuera de esta entrega. No se propone compartir credenciales del titular en producción.

## 5. Flujo IoT y alertas

ESP32 lee ACS712/INA219, evalúa umbrales y controla indicadores/relé localmente. HttpEdgeGatewayClient envía JSON al gateway y lee umbrales de la respuesta. El código observado de envío procesa umbrales; no demuestra por sí solo que se ejecute cualquier comando remoto que el gateway pueda devolver.

FastAPI recibe POST /api/electrolink/readings, genera readingId y fecha UTC del gateway y guarda una lectura pendiente en SQLite. SyncWorker envía lecturas al backend en /api/v1/iot/edge/readings con X-Api-Key, sincroniza acknowledgements de relé y consulta comandos y umbrales. El timestamp original del firmware usa milisegundos desde arranque; el gateway genera la fecha de captura enviada al backend. La existencia de estas rutas no demuestra que el hardware se haya probado durante esta revisión.

EdgeIngestionController intenta EquipmentTelemetryService.TryIngest. Con vínculo válido verifica identidad, allowlist, dispositivo, pertenencia y duplicados. El equipo pertenece a un área y esta a un local. Se evalúan anomalías con las políticas eléctricas y de humedad; AlertMaterializer prepara la alerta y atribuye el trabajador de turno cuando corresponde. La notificación combina eventos en proceso/SignalR y una cola persistida de canales externos. /hubs/alerts y GET .../alerts/changes permiten una integración en tiempo real posterior.

Si el dispositivo no tiene vínculo y cumple las condiciones del flujo anterior, se usa DeviceReadingStreamCommandService. Un dispositivo vinculado no debe saltarse su validación usando esa alternativa. No conviene mezclar el dashboard previo por ownerId con la nueva jerarquía de locales.

## 6. Endpoints útiles para el MVP

En esta tabla S = /api/v1/stores/{storeId}; E = S/areas/{areaId}/equipment/{equipmentId}. Los identificadores se obtienen del backend.

| Método | Ruta | Uso y contrato relevante |
|---|---|---|
| POST | /api/v1/auth/sign-in | Inicio de sesión; userId, email, token, refreshToken |
| GET | /api/v1/stores?page=1&pageSize=20 | Locales visibles; items, page, pageSize, hasMore |
| GET | S/dashboard-summary | TotalEquipment, monitored/offline/unmonitored, conteos de alertas y equipment con areaId y nombres |
| GET | S/alerts/active | OpenCritical, OpenNonCritical, HasCriticalLeakage, items y LatestSequence; máximo 100 elementos |
| GET | S/alerts | Historial paginado; filtros por estado, severidad, equipo y fechas |
| POST | E/alerts/{alertId}/acknowledgement | Registra reconocimiento; devuelve alerta actualizada, no acredita resolución física |
| GET | E/safety-status | Status, isDeEnergized, isSafeToClean, reasons, última lectura y evaluatedAtUtc |
| GET | E/shutdown-protocol | Instrucciones y regla del equipo, con isDefault |
| POST | E/anomalies | Reporte manual por categoría y descripción; fuera del núcleo inicial propuesto |
| GET | S/shifts/on-duty | Personal de turno; no prueba que el usuario autenticado sea ese trabajador |
| POST | S/shifts/handover | Relevo con workerId y notas; posible ampliación |

El DTO actual de alertas tiene más campos que la descripción histórica de 12 campos de AlertManagement/README.md: fuente, descripción, reportante, responsable de turno, asignación, resolución y secuencia. El código actual es la referencia para modelar Flutter. Alertas asignadas/reconocidas/resueltas deben conservar su estado, sin tratar todos los valores como OPEN.

El dashboard devuelve NORMAL, ANOMALY, STALE, UNKNOWN y UNMONITORED. UNKNOWN y STALE cuentan como offline. NORMAL no significa autorizado para limpieza. Esa decisión viene del endpoint safety-status: SAFE_TO_CLEAN, ENERGIZED, HAZARD o UNVERIFIED. Un error de red, una lectura antigua o un estado desconocido nunca debe transformarse en un resultado favorable.

Para reconocer una alerta de la lista del local hace falta areaId: la alerta lleva equipmentId, mientras que el resumen del dashboard permite resolver equipmentId → areaId. Si falta el equipo correspondiente, se debe refrescar o consultar la jerarquía, sin inventar una ruta.

## 7. Diagnóstico de Flutter existente

- Hay dos AuthBloc: core/auth/auth_bloc.dart y features/auth/presentation/bloc/auth_bloc.dart. main.dart provee ambos; AuthScreen utiliza el de core. Se propone concentrar el camino de staff en un solo estado de sesión.
- El AuthBloc de core llama /Authentication/sign-in contra baseUrl http://127.0.0.1:8088. Falta /api/v1; no coincide con el controller observado. La otra fuente remota sí usa /api/v1/authentication/sign-in. El MVP debe usar la ruta canónica /api/v1/auth/sign-in.
- SignInResponse modela userId como int y convierte un us-... en 0. La identidad debe conservarse como String.
- AuthScreen decide navegación con state.role, pero el response de login no lleva ese campo. Los roles de acceso y de negocio no se pueden usar indistintamente para asignar el segmento.
- AuthGate sustituye su propia ruta tras arrancar; ProfileGate lleva cualquier perfil completo a CompanyShell. La restauración de sesión y el login no siguen la misma decisión de pantalla.
- TokenService usa almacenamiento seguro, pero el arranque no comprueba expiración local. AuthInterceptor elimina la copia persistida ante 401; no limpia el token en memoria ni avisa al AuthBloc. Esto puede dejar una sesión visualmente activa.
- ApiConstants y ApiEndpoints duplican baseUrl. Se propone una sola configuración por --dart-define=API_BASE_URL, con host de emulador Android o dirección LAN según dispositivo.
- UserRole solo contiene homeowner, company y technician. El segmento operativo requiere una entrada de producto propia; no debe fingir que existe un nuevo rol autorizado por el servidor.
- El repositorio IoT existente consulta rutas por ownerId y captura errores convirtiéndolos en null o listas vacías. Para staff se necesita una carga explícita por local que distinga sin datos de fallo al consultar.
- Android ya tiene permiso INTERNET y permite HTTP. La configuración de iOS debe verificarse si se elige un backend HTTP local; no se probó ejecución en iOS en esta revisión.

## 8. Verificación realizada y límites

Se copió Flutter a /private/tmp/electrolink-staff-work para resolver dependencias y ejecutar diagnóstico sin editar la app original. El SDK localizado está en /Users/leoleos/Documents/Documents - Leandro’s MacBook Air/flutter. pub get resolvió dependencias y ajustó cinco dependencias transitivas en la copia temporal; ese lockfile no se copió al original.

- flutter analyze --no-pub, después de pub get: No issues found.
- flutter test --no-pub: la prueba existente App renders auth screen smoke test falla con pumpAndSettle timed out (test/widget_test.dart:8). Esto reproduce el fallo inicial; no se ha aplicado una corrección. La causa exacta del bloqueo necesita investigación con una sesión/almacenamiento controlados.
- No se hizo login real, no se reconocieron alertas, no se generaron usuarios, no se arrancaron PostgreSQL/Edge/firmware y no se construyó un APK.
- El proyecto móvil del disco externo no contiene .git. No se inicializó un repositorio ni se crearon commits.

El backend arranca con EnsureCreated y migraciones salvo configuración contraria. Evitar arrancarlo por simple inspección preserva el estado de sus datos. La instrucción AGENTS.md del backend exige build/runtime y un flujo homeowner después de modificar código; no aplica aquí porque no hubo cambios en ese código.

## 9. Alcance propuesto

Login con cuenta existente → locales accesibles → dashboard de equipos y alertas → reconocimiento explícito de alerta → consulta del estado para limpieza y protocolo → cerrar sesión. Estados claros de carga, error, vacío y token vencido. Datos reales del servidor; sin inventar métricas o asignación de empleados. Se excluyen facturación, marketplace, altas de dispositivos, edición de umbrales, control de relés, reportes complejos y notificaciones en segundo plano.

La especificación SPEC-staff-mvp.md concreta aceptación y comandos. Todavía no se implementó este alcance.
