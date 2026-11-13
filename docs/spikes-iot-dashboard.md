# 🔍 Spikes de Investigación: Dashboard IoT

> Validaciones técnicas pendientes contra el backend en ejecución, definidas en
> el task de refactor del Dashboard IoT. Requieren backend levantado en `:8088`
> y tokens de cuentas reales. Fecha: 2026-07-10 · Rama: `feat/iot-edge`

Para obtener un token, hacer sign-in y copiar el JWT de la respuesta:

```bash
curl -s -X POST http://localhost:8088/api/v1/authentication/sign-in \
  -H 'Content-Type: application/json' \
  -d '{"email":"<email>","password":"<password>"}'
```

---

## Spike 1 — Validación de guard de roles (prioridad alta)

**Riesgo:** los endpoints usan `{homeownerId}` en el path; si el backend valida
el rol en sus policies, una cuenta *company* recibiría 403 y el dashboard
unificado no funcionaría para empresas.

Con un token de cuenta **company** (y su `profileId` de `/api/v1/profiles/me`):

```bash
TOKEN='<jwt-company>'
OWNER='<profileId-company>'

curl -s -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $TOKEN" \
  http://localhost:8088/api/v1/alert-log/$OWNER

curl -s -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $TOKEN" \
  http://localhost:8088/api/v1/consumption-dashboard/$OWNER
```

- **200** → el ownerId neutral funciona; no se requiere cambio de backend.
- **403/404** → hay guard de rol; pedir al equipo de backend relajarlo
  (cambio mínimo, no requiere rediseño del contrato).

## Spike 2 — Bloqueo de multi-propiedad (prioridad alta)

**Riesgo:** `GET /consumption-dashboard/{ownerId}` retorna **un solo**
`propertyId`. Las companies manejan portafolios multi-propiedad
(`/api/v1/companies/{ownerId}/property-portfolios`); no está definido si el
dashboard consolida datos agregados o si soportará filtro por propiedad.

Verificar con una company que tenga ≥2 propiedades en su portafolio:

1. `GET /api/v1/companies/$OWNER/property-portfolios` → confirmar ≥2 `entries`.
2. `GET /api/v1/consumption-dashboard/$OWNER` → inspeccionar `propertyId` y si
   `deviceIds`/`circuitSummaries` incluyen dispositivos de todas las propiedades
   o solo de la primaria.

**Pregunta para backend:** ¿el dashboard consolida todas las propiedades o se
necesita un parámetro de filtro (`?propertyId=`)? De la respuesta depende si la
UI de company necesita un selector de propiedad.

## Spike 3 — Fuente de verdad del plan (prioridad alta)

**Riesgo:** el plan del usuario existe en dos lugares: `planTier` dentro del
payload del consumption-dashboard y `GET /api/v1/subscriptions/me` (flujo de
checkout/cancelación ya implementado en la app). Si divergen, la UI mostraría
planes contradictorios.

```bash
curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:8088/api/v1/consumption-dashboard/$OWNER | jq .planTier

curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:8088/api/v1/subscriptions/me | jq .
```

Hacer un upgrade vía el flujo de suscripciones y verificar si `planTier` del
dashboard se actualiza. **Decisión actual del frontend:** la UI de suscripción
lee de `/subscriptions/me`; el nuevo dashboard IoT **no** muestra `planTier`
hasta resolver este spike. `PUT /consumption-dashboard/{id}/upgrade-tier` no se
consume desde la app para no crear una segunda vía de mutación del plan.

---

## Nota: prefijo `/api/v1` en `ApiEndpoints`

Durante el refactor se detectó que `ApiEndpoints.baseUrl` perdió el prefijo
`/api/v1` (el doc de integración lo documenta como parte de la URL base) y las
rutas tampoco lo incluían. Se normalizó: **todas** las rutas de `ApiEndpoints`
llevan ahora el prefijo `/api/v1` explícito, igual que `ApiConstants`. Al
levantar el backend, verificar que onboarding/suscripciones sigan respondiendo;
si el backend sirviera esas rutas sin prefijo, ajustar en un solo lugar
(`ApiEndpoints._v1`).

## Descopado a Fase 2 (sin endpoint hoy)

- **Relay Control / Safety Override** — no hay endpoints de actuación. Cuando
  existan: confirmación obligatoria antes de conmutar (nunca one-tap).
- **Power Factor** — `circuitSummaries` no expone potencia activa/aparente.
  Reemplazado por Voltaje Pico + Dispositivos Activos.
- **Service requests en "Actividad Reciente"** — no hay endpoint de listado de
  solicitudes; el feed hoy combina alert-log + consumption-report
  (`IotDashboardData.activity`).
