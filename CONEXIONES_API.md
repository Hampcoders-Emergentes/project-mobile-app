# Conexiones API — Mobile App → Backend (.NET)

Resumen de los endpoints conectados desde la app mobile al backend `http://10.0.2.2:8088/api/v1`.

---

## Endpoints Conectados

| Método | Endpoint | Desde | Propósito | Estado |
|--------|----------|-------|-----------|--------|
| `GET` | `/profiles/me` | `DashboardRepositoryImpl` | Obtener perfil del usuario (nombre, estado) | ✅ |
| `GET` | `/subscriptions/me` | `DashboardRepositoryImpl` + `SubscriptionRepositoryImpl` | Plan actual (tipo, estado, ciclo) | ✅ |
| `GET` | `/subscriptions/me/payment-history` | `SubscriptionRepositoryImpl` | Historial de pagos | ✅ |
| `POST` | `/subscriptions/checkout` | `SubscriptionRepositoryImpl` | Obtener URL de checkout Stripe ("Cambiar Plan") | ✅ |
| `POST` | `/subscriptions/me/cancel` | `SubscriptionRepositoryImpl` | Cancelar suscripción | ✅ |
| `POST` | `/subscriptions/me/portal` | `SubscriptionRepositoryImpl` | Obtener URL del portal de facturación Stripe ("Ir a Stripe") | ✅ |

---

## Mapeo de Respuestas

### `GET /subscriptions/me` → `MySubscriptionResource`

```
planType        → SubscriptionData.planName   ("Free", "PremiumIndividual", "Enterprise")
status          → SubscriptionData.status     ("Active", "Canceled", "PastDue", "Trial")
billingCycle    → SubscriptionData.billingCycle
cancelAtPeriodEnd → SubscriptionData.cancelAtPeriodEnd
periodEnd       → SubscriptionData.periodEnd
monthlyRequestsUsed  → SubscriptionData.monthlyRequestsUsed
monthlyRequestsLimit → SubscriptionData.monthlyRequestsLimit
gracePeriodEndsAt    → SubscriptionData.gracePeriodEndsAt
```

Las `features` se generan localmente según `planType` (no vienen en la API).

### `GET /subscriptions/me/payment-history` → `PaymentHistoryResource`

```
payments[].processedAt    → PaymentEntry.date
payments[].amountDecimal  → PaymentEntry.amount
payments[].status         → PaymentEntry.status
```

### `POST /subscriptions/checkout` → `CheckoutUrlResource`

Request:
```json
{ "planType": "PremiumIndividual", "billingCycle": "monthly", "successUrl": "...", "cancelUrl": "..." }
```
Response → se abre `checkoutUrl` en el navegador.

### `POST /subscriptions/me/cancel` → `MySubscriptionResource`

Request:
```json
{ "reason": "Solicitud del usuario" }
```
Response → se refresca la suscripción.

### `POST /subscriptions/me/portal` → `CustomerPortalUrlResource`

Request:
```json
{ "returnUrl": "electrolink://portal/back" }
```
Response → se abre `portalUrl` en el navegador.

### `GET /profiles/me` → `MyProfileResource`

Solo se usa en `DashboardRepositoryImpl` para obtener contexto del perfil (no se expone directamente en UI aún).

---

## Arquitectura de Datos

```
SubscriptionPage
  └── SubscriptionBloc
        ├── FetchSubscription        → GET  /subscriptions/me
        │                           └── GET  /subscriptions/me/payment-history
        ├── ChangePlanRequested      → POST /subscriptions/checkout → abre URL
        ├── CancelSubscriptionRequested → POST /subscriptions/me/cancel → refresca
        └── OpenPortalRequested      → POST /subscriptions/me/portal → abre URL

DashboardTab
  └── DashboardBloc
        └── FetchDashboard
              ├── GET /subscriptions/me  → PlanSummary
              └── GET /profiles/me       → contexto

DashboardDrawer
  └── AuthBloc (lectura directa)
        └── email, userId desde AuthAuthenticated state
```

---

## Archivos Modificados (13)

| Archivo | Rol |
|---------|-----|
| `core/network/api_endpoints.dart` | Constantes de endpoints |
| `subscription/domain/models/subscription_data.dart` | `fromJson`, `copyWith`, features por plan |
| `subscription/domain/repositories/subscription_repository.dart` | Interfaz abstracta (nueva) |
| `subscription/data/repositories/subscription_repository_impl.dart` | 5 llamadas reales vía `ApiClient` |
| `subscription/presentation/bloc/subscription_bloc.dart` | Handlers para los 4 eventos |
| `subscription/presentation/bloc/subscription_event.dart` | 3 eventos nuevos de acción |
| `subscription/presentation/bloc/subscription_state.dart` | `isActionLoading`, `actionUrl` |
| `subscription/presentation/pages/subscription_page.dart` | Botones conectados + `url_launcher` |
| `dashboard/domain/models/dashboard_data.dart` | `fromApi` factories |
| `dashboard/data/repositories/dashboard_repository_impl.dart` | Llamadas reales a API |
| `dashboard/presentation/bloc/dashboard_bloc.dart` | Acepta `ApiClient` |
| `dashboard/presentation/widgets/dashboard_drawer.dart` | Datos desde `AuthBloc` |
| `core/widgets/homeowner_shell.dart` | Pasa `ApiClient` al `DashboardBloc` |

---

## Lo que NO se conectó (sin endpoint público)

| Funcionalidad | Estado |
|---------------|--------|
| ActiveService (trabajo activo en dashboard) | Placeholder vacío |
| Properties (lista de propiedades) | Lista vacía |
| Analytics (consumo, circuitos, anomalías) | Hardcodeado |
| CompanyDrawer / TechnicalDrawer | Hardcodeado |

---

## Dependencias Agregadas

- `url_launcher: ^6.3.1` — para abrir URLs de Stripe en el navegador

## Android

- `INTERNET` permission
- `usesCleartextTraffic="true"` (API está en HTTP, no HTTPS)
- Queries para `ACTION_VIEW` (url_launcher en Android 11+)
