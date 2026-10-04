# FixGeo

Arquitectura base de la aplicación móvil FixGeo, preparada para desarrollar las
interfaces de onboarding, autenticación y los perfiles de cliente, prestador y
empresa.

## Capas

- `core`: configuración transversal (tema, constantes, rutas y utilidades).
- `features`: módulos aislados por funcionalidad.
- `shared`: widgets reutilizables sin lógica de negocio.
- `services`: contratos e implementaciones de proveedores externos.
- `repositories`: interfaz de acceso usada por la lógica de la aplicación.
- `screens`: composición de UI; no accede directamente a servicios remotos.

## Puesta en marcha

El proyecto incluye la arquitectura Dart/Flutter y los runners nativos de
Android e iOS. Con el SDK de Flutter instalado:

```sh
flutter pub get
flutter analyze
flutter run
```

## Integración futura con Supabase

La futura implementación `SupabaseAuthService` implementará `AuthService` y
encapsulará el SDK. `AuthRepository` seguirá siendo el punto de acceso para la
lógica de presentación, por lo que ninguna pantalla dependerá directamente de
Supabase. El mismo patrón se aplicará a base de datos y Storage dentro de cada
feature cuando sus casos de uso estén definidos.
