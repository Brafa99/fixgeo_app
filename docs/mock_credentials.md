# Credenciales de usuarios mock

> Estas credenciales son completamente ficticias y deben utilizarse únicamente
> durante el desarrollo y las pruebas locales. No deben copiarse a producción ni
> almacenarse como contraseñas reales cuando se conecte Supabase.

Para iniciar sesión, se utiliza el correo electrónico como nombre de usuario.

## Clientes

| ID | Nombre | Usuario / correo | Contraseña |
|---|---|---|---|
| `client_001` | Lucía Fernández | `lucia.fernandez@clientes.fixgeo.example` | `FixGeo.Cliente01!` |
| `client_002` | Diego Vargas | `diego.vargas@clientes.fixgeo.example` | `FixGeo.Cliente02!` |
| `client_003` | Mariana Quiroga | `mariana.quiroga@clientes.fixgeo.example` | `FixGeo.Cliente03!` |
| `client_004` | Andrés Salvatierra | `andres.salvatierra@clientes.fixgeo.example` | `FixGeo.Cliente04!` |
| `client_005` | Valeria Paredes | `valeria.paredes@clientes.fixgeo.example` | `FixGeo.Cliente05!` |

## Trabajadores

| ID | Nombre | Usuario / correo | Contraseña |
|---|---|---|---|
| `worker_001` | Carlos Mendoza | `carlos.mendoza@trabajadores.fixgeo.example` | `FixGeo.Trabajador01!` |
| `worker_002` | Miguel Rojas | `miguel.rojas@trabajadores.fixgeo.example` | `FixGeo.Trabajador02!` |
| `worker_003` | Rocío Alarcón | `rocio.alarcon@trabajadores.fixgeo.example` | `FixGeo.Trabajador03!` |
| `worker_004` | Javier Condori | `javier.condori@trabajadores.fixgeo.example` | `FixGeo.Trabajador04!` |
| `worker_005` | Elena Flores | `elena.flores@trabajadores.fixgeo.example` | `FixGeo.Trabajador05!` |

## Empresas

| ID | Nombre comercial | Usuario / correo | Contraseña |
|---|---|---|---|
| `company_001` | Andina Hogar | `contacto@andinahogar.fixgeo.example` | `FixGeo.Empresa01!` |
| `company_002` | Illimani Clean | `reservas@illimaniclean.fixgeo.example` | `FixGeo.Empresa02!` |
| `company_003` | Metro Obras | `proyectos@metroobras.fixgeo.example` | `FixGeo.Empresa03!` |

## Consideraciones para Supabase

- Las contraseñas no deben agregarse a `UserModel` ni guardarse en tablas de
  perfiles.
- Supabase Auth debe encargarse de almacenar y validar las contraseñas.
- Los registros de perfiles deben relacionarse con el identificador generado por
  Supabase Auth.
- Al crear un entorno compartido de pruebas, estas contraseñas deben sustituirse
  por secretos administrados fuera del repositorio.
