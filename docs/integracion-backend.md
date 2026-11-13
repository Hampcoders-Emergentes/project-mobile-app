# Documentación: Integración con el Backend (capa de red)

> Análisis del flujo de datos entre la app Flutter y el backend, con foco en autenticación
> (`lib/features/auth/`) y la capa de red (`lib/core/network/`).
> Fecha de análisis: 2026-07-09 · Rama: `feat/iot-edge`

---

## 1. Arquitectura del flujo de datos

El flujo para autenticación sigue una arquitectura por capas (Clean Architecture parcial):

```
AuthScreen / RegisterScreen  (UI)
        │  dispara LoginSubmitted / RegisterSubmitted
        ▼
AuthBloc                     (lib/features/auth/presentation/bloc/auth_bloc.dart)
        │  llama signIn(email, password) / signUp(...)
        ▼
AuthRepositoryImpl           (lib/features/auth/data/repositories/auth_repository_impl.dart)
        │  construye SignInRequest / RegisterRequest, guarda el token al recibir respuesta
        ▼
AuthRemoteDataSource         (lib/features/auth/data/datasources/auth_remote_data_source.dart)
        │  _dio.post(ApiConstants.signIn, data: request.toJson())
        ▼
ApiClient (singleton) → Dio  (lib/core/network/api_client.dart)
        │  agrega headers + interceptores (Authorization: Bearer <token>)
        ▼
Backend HTTP
```

La serialización se hace manualmente: los modelos de request exponen `toJson()`
(`Map<String, dynamic>`) y los de response un `factory .fromJson(Map<String, dynamic>)`.
Dio serializa el `Map` a JSON con el header `Content-Type: application/json`.

---

## 2. URLs del backend

La app apunta a **dos backends distintos**, definidos en dos archivos de constantes diferentes:

| Archivo | Constante | Valor | Usado por |
|---|---|---|---|
| `lib/core/network/api_constants.dart` | `ApiConstants.baseUrl` | `http://10.0.2.2:5000` | Auth y Profile (vía `ApiClient.instance`) |
| `lib/core/network/api_endpoints.dart` | `ApiEndpoints.baseUrl` | `http://10.0.2.2:8088/api/v1` | Dashboard, Subscriptions, Onboarding, Thresholds, shells de UI |

`10.0.2.2` es el alias que el **emulador de Android** usa para llegar al `localhost` de la
máquina host. Es decir, la app está configurada para hablar con backends corriendo localmente
en los puertos `5000` y `8088`.

### Endpoints de autenticación (backend :5000)

| Operación | Método | URL completa |
|---|---|---|
| Sign-in | `POST` | `http://10.0.2.2:5000/api/v1/authentication/sign-in` |
| Sign-up | `POST` | `http://10.0.2.2:5000/api/v1/authentication/sign-up` |

### Endpoints de perfil (backend :5000, rutas hardcodeadas en el data source)

| Operación | Método | URL completa |
|---|---|---|
| Obtener mi perfil | `GET` | `http://10.0.2.2:5000/api/v1/profiles/me` |
| Completar perfil de empresa | `POST` | `http://10.0.2.2:5000/api/v1/profiles/me/complete/company` |

### Endpoints del segundo backend (:8088, definidos en `ApiEndpoints`)

| Constante | Ruta (sobre `http://10.0.2.2:8088/api/v1`) |
|---|---|
| `analyzeOnboarding` | `/profiles/me/device-onboarding/analyze` |
| `thresholds(profileId)` | `/profiles/{profileId}/thresholds` |
| `completeHomeowner` | `/profiles/me/complete/homeowner` |
| `myProfile` | `/profiles/me` |
| `mySubscription` | `/subscriptions/me` |
| `myPaymentHistory` | `/subscriptions/me/payment-history` |
| `checkout` | `/subscriptions/checkout` |
| `cancelSubscription` | `/subscriptions/me/cancel` |
| `customerPortal` | `/subscriptions/me/portal` |

---

## 3. Contratos JSON

### 3.1 Sign-in — `POST /api/v1/authentication/sign-in`

**Request** (`SignInRequest.toJson()`):

```json
{
  "email": "usuario@correo.com",
  "password": "secreto123"
}
```

**Response esperada** (`SignInResponse.fromJson()`):

```json
{
  "user_id": 1,
  "email": "usuario@correo.com",
  "token": "<JWT>",
  "role": "CLIENT"
}
```

- `role` se mapea en `AuthRepositoryImpl._mapRole()`: `CLIENT` → cliente, `COMPANY` → empresa,
  `TECHNICIAN` → técnico. **Cualquier valor desconocido cae silenciosamente en `client`.**
- Al recibir la respuesta, el token se persiste en `FlutterSecureStorage` bajo la clave
  `auth_token`.

### 3.2 Sign-up — `POST /api/v1/authentication/sign-up`

**Request** (`RegisterRequest.toJson()`):

```json
{
  "email": "usuario@correo.com",
  "password": "secreto123",
  "confirm_password": "secreto123"
}
```

**Response**: idéntica a la de sign-in (se reutiliza `SignInResponse`), es decir, el registro
inicia sesión automáticamente.

### 3.3 Completar perfil de empresa — `POST /api/v1/profiles/me/complete/company`

**Request** (`CompleteCompanyProfileRequest.toJson()`):

```json
{
  "companyName": "ACME S.A.C.",
  "taxId": "20123456789",
  "phoneNumber": "+51999999999",
  "email": "contacto@acme.com",
  "billingStreet": "Av. Principal 123",
  "billingNumber": "",
  "billingDistrict": "Miraflores",
  "billingCity": "Lima",
  "billingCountry": "PE",
  "billingPostalCode": "15074",
  "industry": "",
  "companySize": 2,
  "website": ""
}
```

Nota: `billingNumber` se envía **siempre como cadena vacía** (hardcodeado en `toJson()`),
`industry`/`website` tienen default `''` y `companySize` default `2`.

**Response** (`CompanyProfileResponse.fromJson()`, todos los campos opcionales con fallback `''`):

```json
{
  "profileId": "...",
  "userId": "...",
  "status": "...",
  "businessRole": "...",
  "firstName": "...",
  "lastName": "...",
  "phoneNumber": "...",
  "street": "...",
  "district": "...",
  "city": "...",
  "country": "...",
  "postalCode": "..."
}
```

⚠️ Nótese la **inconsistencia de convención**: auth usa `snake_case` (`user_id`,
`confirm_password`) mientras que profile usa `camelCase` (`profileId`, `companyName`).

---

## 4. Autenticación de las peticiones (headers)

`ApiClient` configura Dio con:

```
Content-Type: application/json
Accept: application/json
connectTimeout: 15 s
receiveTimeout: 30 s
```

y registra **dos interceptores que hacen casi lo mismo**:

1. **Interceptor inline** (`api_client.dart:32-43`): si `TokenService.instance.token`
   (token en memoria) no es nulo, agrega `Authorization: Bearer <token>`.
2. **`AuthInterceptor`** (`auth_interceptor.dart`): si la petición aún no tiene header
   `Authorization` y la ruta no contiene `/sign-in` ni `/sign-up`, lee el token desde
   `FlutterSecureStorage` (clave `auth_token`) y lo agrega. Ante un `401`, borra el token
   del storage (pero no del `TokenService` en memoria, ni redirige al login).

---

## 5. Manejo de errores

En `AuthBloc._extractErrorMessage()`:

- Si el backend responde con un body `{ "message": "..." }`, se muestra ese mensaje.
- `connectionTimeout` / `receiveTimeout` → "Tiempo de espera agotado…".
- `connectionError` → "No se puede conectar al servidor.".
- Cualquier otra excepción → mensaje genérico (el detalle se pierde, no hay logging).

---

## 6. Hardcoding detectado

| # | Qué | Dónde | Riesgo |
|---|---|---|---|
| 1 | `baseUrl = 'http://10.0.2.2:5000'` | `api_constants.dart:4` | Solo funciona en el **emulador Android**. En un dispositivo físico o en el simulador iOS la app no conecta. No hay configuración por entorno (`--dart-define`, flavors, `.env`). |
| 2 | `baseUrl = 'http://10.0.2.2:8088/api/v1'` | `api_endpoints.dart:2` | Igual que el anterior, y además duplica el concepto de "base URL" en otro archivo con otro puerto. |
| 3 | `http://` sin TLS | Ambas base URLs | Credenciales y JWT viajan en texto claro. En producción debe ser `https://`. |
| 4 | Rutas de perfil escritas inline (`'/api/v1/profiles/me'`, `'/api/v1/profiles/me/complete/company'`) | `profile_remote_data_source.dart:12,22` | No usan `ApiConstants`/`ApiEndpoints`; queda un tercer lugar donde viven rutas. |
| 5 | Clave `'auth_token'` repetida como string mágico | `auth_repository_impl.dart`, `auth_interceptor.dart:17,28` (existe `TokenService._tokenKey` pero no se reutiliza) | Un typo en cualquiera rompe la sesión silenciosamente. |
| 6 | `billingNumber: ''` fijo | `complete_company_profile_request.dart:38` | El backend nunca recibirá el número de dirección real. |
| 7 | `https://via.placeholder.com/150` | `services_screen.dart:171`, `technical_dashboard_screen.dart:65` | Imágenes placeholder de un dominio externo (el servicio via.placeholder.com además es inestable). |
| 8 | Timeouts duplicados: `ApiConstants` define 10 s pero `ApiClient` hardcodea 15 s / 30 s | `api_constants.dart:9-10` vs `api_client.dart:24-25` | Las constantes de timeout son **código muerto**; cambiar `ApiConstants` no tiene efecto. |

---

## 7. Otros problemas encontrados

### 7.1 El singleton `ApiClient.instance` está roto en la práctica
`ApiClient.instance` apunta al backend `:5000`, pero al menos **7 lugares** crean instancias
nuevas con `ApiClient(baseUrl: ApiEndpoints.baseUrl)` (`:8088`): `homeowner_shell.dart:44,84`,
`auth_bloc.dart` (core), `dashboard_bloc.dart:15`, `dashboard_page.dart:44`,
`subscription_bloc.dart:15`, `company_iot_page.dart:17`, `company_shell.dart:110`,
`complete_profile_screen.dart:92`. Cada instancia crea su propio `Dio`, sus interceptores y su
`FlutterSecureStorage`. No hay inyección de dependencias; es imposible mockear la red en tests
sin refactorizar.

### 7.2 Doble fuente de verdad para el token
- `AuthRepositoryImpl` guarda el token **directamente en storage** (`_apiClient.storage.write`),
  sin pasar por `TokenService.saveToken()`, por lo que `TokenService.instance.token` (memoria)
  queda desactualizado. El primer interceptor (que lee de memoria) puede no agregar el header
  y la petición termina dependiendo del segundo interceptor (que lee del storage). Funciona,
  pero por accidente.
- Ante un `401`, `AuthInterceptor` borra el token del storage pero **no** limpia la copia en
  memoria de `TokenService`, así que el interceptor inline seguiría enviando un token inválido
  hasta reiniciar la app. Tampoco se emite ningún evento para llevar al usuario al login.

### 7.3 Parsing frágil de la respuesta de sign-in
`SignInResponse.fromJson` usa casts estrictos (`json['user_id'] as int`,
`json['token'] as String`). Si el backend renombra un campo, devuelve `null` o cambia el tipo
(p. ej. `user_id` como string), la app lanza un `TypeError` que el Bloc reporta como
"Error de conexión. Intente nuevamente." — un mensaje engañoso para depurar.

### 7.4 Detección de rutas públicas por `contains`
`AuthInterceptor` decide no adjuntar token si `options.path.contains('/sign-in')`. Cualquier
ruta futura que contenga esas subcadenas quedaría sin autenticación. Mejor comparar contra una
lista explícita de rutas públicas.

### 7.5 Sin refresh token ni expiración
Solo existe un token de acceso; no hay flujo de renovación. Cuando expira, el usuario obtiene
errores 401 hasta que la app decida borrarlo.

### 7.6 `confirm_password` viaja al backend
La confirmación de contraseña es una validación de UI; enviarla al servidor acopla el contrato
al formulario. No es grave, pero conviene validarla en el cliente y enviar solo `email`/`password`
(si el backend actual la exige, documentarlo).

### 7.7 Roles desconocidos degradan a `client` en silencio
`_mapRole` devuelve `UserRole.client` para cualquier rol no reconocido. Si el backend agrega un
rol nuevo (p. ej. `ADMIN`), ese usuario entraría a la app con vistas de cliente sin ninguna
advertencia ni log.

---

## 8. Recomendaciones (resumen)

1. **Unificar la configuración de red**: una sola clase de constantes (o mejor, valores por
   entorno vía `--dart-define`/flavors) con las dos base URLs nombradas explícitamente
   (`identityBaseUrl`, `iotBaseUrl`), y eliminar la duplicación `ApiConstants`/`ApiEndpoints`.
2. **Inyección de dependencias** (get_it, riverpod o constructor injection) en lugar de
   `ApiClient.instance` + `new ApiClient(...)` dispersos.
3. **Un solo camino para el token**: todo pasa por `TokenService` (guardar, leer, limpiar) y un
   único interceptor; en `401`, limpiar memoria + storage y notificar al `AuthBloc`.
4. **Parsing defensivo** en `SignInResponse.fromJson` (o generar modelos con `json_serializable`).
5. **HTTPS** y URLs reales configurables antes de cualquier despliegue fuera del emulador.
6. Mover las rutas de `ProfileRemoteDataSource` a la clase de constantes y capturar el
   `billingNumber` real del formulario.
