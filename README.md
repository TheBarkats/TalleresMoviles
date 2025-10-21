# Taller HTTP - Star Wars API

Aplicación Flutter que demuestra el consumo de APIs REST utilizando el paquete `http`, implementando arquitectura limpia y navegación con parámetros.

## Información Académica

**Estudiante:** Cristopher Arias Contreras  
**Código:** 230222032  
**Asignatura:** Electiva profesional I - Desarrollo Móvil  
**Semestre:** VII Semestre  
**Universidad:** Unidad Central del Valle  

## Descripción del Proyecto

Este taller está desarrollado como parte de la **Electiva profesional I - Desarrollo Móvil** y demuestra las mejores prácticas para el consumo de APIs REST en Flutter, implementando una aplicación que consulta la **Star Wars API (SWAPI)** para mostrar información de personajes del universo de Star Wars.

## Características Implementadas

- ✅ **Consumo de API pública:** Star Wars API (swapi.dev)
- ✅ **Manejo de estados:** Loading, success, error con UI responsiva
- ✅ **Navegación:** go_router con paso de parámetros y rutas tipadas
- ✅ **Scroll infinito:** Paginación automática al llegar al final
- ✅ **Búsqueda en tiempo real:** Filtrado de personajes por nombre con debounce
- ✅ **Arquitectura limpia:** Separación por capas (models, services, views)
- ✅ **Manejo de errores:** HTTP, de red y de parsing JSON
- ✅ **Tema Star Wars:** Diseño visual inmersivo con efectos de neón
- ✅ **Firebase Integration:** Analytics y App Distribution configurados
- ✅ **Documentación:** Código completamente documentado

## Arquitectura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
├── core/
│   └── routing/
│       └── app_router.dart           # Configuración de rutas con go_router
└── features/
    ├── taller2/
    │   └── presentation/pages/
    │       └── home_page.dart        # Página principal del taller
    └── taller_http/                  # Feature del taller HTTP
        ├── data/
        │   ├── models/              # Modelos de datos
        │   │   ├── character.dart   # Modelo de personaje
        │   │   ├── planet.dart      # Modelo de planeta
        │   │   └── api_response.dart # Modelo de respuesta de API
        │   └── services/            # Servicios de datos
        │       └── star_wars_api_service.dart # Servicio de API
        └── presentation/
            └── pages/               # Páginas de la interfaz
                ├── star_wars_characters_page.dart # Lista de personajes
                └── character_detail_page.dart     # Detalle del personaje
```

## Tecnologías Utilizadas

- **Flutter SDK:** ^3.9.0
- **Dart:** ^3.0.0
- **Dependencias principales:**
  - `http: ^1.1.0` - Para consumo de API REST
  - `go_router: ^14.2.7` - Para navegación y rutas
  - `cupertino_icons: ^1.0.8` - Iconos iOS
- **Firebase:**
  - Firebase BoM 34.4.0
  - Firebase Analytics
  - Firebase App Distribution
  - Google Services Plugin 4.4.4

## API Utilizada

**Star Wars API (SWAPI)**
- **Base URL:** https://swapi.dev/api/
- **Endpoint principal:** `/people/` (personajes)
- **Documentación:** [swapi.dev](https://swapi.dev)

### Estructura de respuesta de la API:

```json
{
  "name": "Luke Skywalker",
  "height": "172",
  "mass": "77",
  "hair_color": "blond",
  "skin_color": "fair",
  "eye_color": "blue",
  "birth_year": "19BBY",
  "gender": "male",
  "homeworld": "https://swapi.info/api/planets/1/",
  "films": ["https://swapi.info/api/films/1/"],
  "species": [],
  "vehicles": ["https://swapi.info/api/vehicles/14/"],
  "starships": ["https://swapi.info/api/starships/12/"],
  "created": "2014-12-09T13:50:51.644000Z",
  "edited": "2014-12-20T21:17:56.891000Z",
  "url": "https://swapi.info/api/people/1/"
}
```

## Funcionalidades Principales

### 1. Lista de Personajes
- **Pantalla:** `StarWarsCharactersPage`
- **Funcionalidades:**
  - Carga inicial de 82 personajes
  - Barra de búsqueda en tiempo real
  - Scroll infinito con indicador de carga
  - Manejo de estados (loading/success/error)
  - Navegación a detalle por tap

### 2. Detalle del Personaje
- **Pantalla:** `CharacterDetailPage`
- **Funcionalidades:**
  - Información completa del personaje
  - Carga de información del planeta natal
  - UI responsiva con Cards y Material 3
  - Navegación de regreso

### 3. Manejo de Estados
- **Loading:** Indicadores de carga durante peticiones HTTP
- **Success:** Muestra de datos con UI optimizada
- **Error:** Manejo de errores de red, HTTP y parsing

## Instalación y Ejecución

### Prerrequisitos
- Flutter SDK ^3.9.0
- Dart ^3.0.0
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos de instalación:

1. **Clonar el repositorio:**
```bash
git clone <repository-url>
cd talleresmoviles
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Verificar configuración de Flutter:**
```bash
flutter doctor
```

4. **Ejecutar la aplicación:**
```bash
flutter run
```

## Capturas de Pantalla

### Pantalla Principal
- Interfaz limpia con información del taller
- Botón principal para acceder a los personajes
- FAB con información del proyecto y estudiante

### Lista de Personajes
- Grid view con tarjetas de personajes
- Barra de búsqueda integrada
- Scroll infinito con paginación

### Detalle del Personaje
- Información completa del personaje
- Datos del planeta natal
- Navegación fluida de regreso

## Patrones de Diseño Implementados

### 1. Arquitectura Limpia (Clean Architecture)
- **Separación por capas:** data, domain (implícito), presentation
- **Inversión de dependencias:** Services → Models → Views
- **Responsabilidad única:** Cada clase tiene una función específica

### 2. Repository Pattern (Simplificado)
- **StarWarsApiService:** Encapsula la lógica de acceso a datos
- **Abstracción:** Separación entre fuente de datos y presentación

### 3. Model-View Pattern
- **Models:** Representación de datos con JSON serialization
- **Views:** Widgets de presentación sin lógica de negocio

## Manejo de Errores

### Tipos de errores manejados:
1. **Errores de red:** Sin conexión a internet
2. **Errores HTTP:** 404, 500, timeout
3. **Errores de parsing:** JSON malformado
4. **Errores de aplicación:** Estados inválidos

### Implementación:
```dart
try {
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    // Procesar datos exitosamente
  } else {
    throw Exception('Error HTTP: ${response.statusCode}');
  }
} catch (e) {
  // Manejo de errores con UI apropiada
}
```

## Testing

El proyecto incluye:
- **Widget tests:** Verificación de UI components
- **Unit tests:** Validación de models y services
- **Integration tests:** Flujos completos de usuario

Para ejecutar los tests:
```bash
flutter test
```

## Mejoras Futuras

- [ ] Implementar cache local con SQLite
- [ ] Añadir modo offline
- [ ] Implementar favoritos
- [ ] Añadir animaciones de transición
- [ ] Soporte para temas claro/oscuro
- [ ] Internacionalización (i18n)

## 📱 Publicación y Distribución

### Firebase App Distribution

Esta aplicación se distribuye usando **Firebase App Distribution** para testing con usuarios internos y QA.

#### Proceso de Distribución

```
Desarrollo → Build APK → Firebase App Distribution → Grupo QA → Testing → Actualización
```

#### Versiones Publicadas

| Versión | Build | Fecha | Grupo | Estado |
|---------|-------|-------|-------|--------|
| 1.0.0 | 1 | Octubre 2025 | QA_Clase | 🚀 Listo para distribución |
| 1.0.1 | 2 | Pendiente | QA_Clase | ⏳ Próxima actualización |

#### Información de Distribución

- **Application ID:** `com.example.talleresmoviles`
- **Grupo de Testers:** QA_Clase
- **Tester Principal:** dduran@uceva.edu.co
- **Plataforma:** Firebase App Distribution
- **Tamaño APK:** ~46.1 MB
- **Firebase Integrado:** ✅ Analytics + App Distribution

#### Generar APK para Distribución

```bash
# Limpiar builds anteriores
flutter clean

# Generar APK de release
flutter build apk --release

# El APK se genera en:
# build/app/outputs/flutter-apk/app-release.apk
```

#### Documentación Completa

Para más detalles sobre el proceso de distribución, consultar:
- 📄 [FIREBASE_APP_DISTRIBUTION.md](./FIREBASE_APP_DISTRIBUTION.md) - Guía completa de distribución

## Conclusiones

Este taller demuestra con éxito:

1. **Consumo efectivo de APIs REST** en Flutter usando el paquete `http`
2. **Arquitectura escalable** con separación de responsabilidades
3. **Navegación moderna** con go_router y paso de parámetros
4. **Manejo robusto de estados y errores**
5. **UI/UX optimizada** con Material Design 3 y tema Star Wars inmersivo
6. **Integración Firebase** para distribución y analytics
7. **Código mantenible** con documentación completa

El proyecto sirve como base sólida para aplicaciones Flutter que requieren consumo de APIs REST, distribución con Firebase App Distribution, y demuestra las mejores prácticas del desarrollo móvil moderno.

## Contacto

**Cristopher Arias Contreras**  
Estudiante de Ingeniería de Sistemas  
 cristopher.arias01@uceva.edu.co