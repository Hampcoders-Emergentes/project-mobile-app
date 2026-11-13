# ElectroLink móvil · Personal del local

MVP Flutter para personal operativo y de limpieza: login, selección de local, alertas, resumen de equipos, reconocimiento de alertas y consulta de seguridad/protocolo del equipo.

```sh
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8088
```

La raíz de API se configura sin /api/v1. Android usa 10.0.2.2 por defecto; otras plataformas usan 127.0.0.1. Para una API desplegada, indicar su raíz HTTPS. La API autoriza por titularidad IAM; un turno registrado no concede acceso al local.

Cuenta temporal y servicios de prueba: [Guía del MVP](docs/staff-mvp.md). Las credenciales están únicamente en `.local/staff-trial.json`, excluido de Git. Nunca incluir ese archivo en una entrega pública.

```sh
flutter analyze
flutter test
flutter build apk --debug
```

Se verificaron 13 pruebas locales, una prueba HTTP contra una API temporal real y la compilación del bundle. Este Mac no tiene Android SDK ni Xcode: no se generó APK ni se validó ejecución nativa en dispositivo.

El recorrido previo se conserva en `lib/legacy_app.dart` y puede abrirse con `flutter run -t lib/legacy_app.dart`; sus pantallas no se reescribieron.

- [Arquitectura y contratos del backend](docs/analisis-backend-staff.md)
- [Alcance aprobado](docs/SPEC-staff-mvp.md)
- [Ejecución, prueba real y límites](docs/staff-mvp.md)

## Ejecutar en Chrome sin error CORS

La API permite el origen `http://localhost:4200`. Flutter asigna un puerto aleatorio al ejecutar solo `flutter run -d chrome`, por lo que el navegador bloquea el login aunque las credenciales sean correctas. Usar:

```sh
flutter run -d chrome --web-port=4200 --dart-define=API_BASE_URL=http://127.0.0.1:8088
```

Abrir `http://localhost:4200` (con localhost, no 127.0.0.1). En VS Code se puede elegir **ElectroLink · Chrome trial** desde Ejecutar y depurar. No se modificó CORS ni ningún archivo del backend.
