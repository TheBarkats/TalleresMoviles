# Talleres Electiva Profesional I - Desarrollo Móvil

Aplicación Flutter que contiene múltiples talleres de desarrollo móvil, demostrando el consumo de APIs REST y gestión de datos con Firebase Firestore.

## Información Académica

**Estudiante:** Cristopher Arias Contreras  
**Código:** 230222032  
**Asignatura:** Electiva profesional I - Desarrollo Móvil  
**Semestre:** VII Semestre  
**Universidad:** Unidad Central del Valle  

## Descripción del Proyecto

Esta aplicación está desarrollada como parte de la **Electiva profesional I - Desarrollo Móvil** y contiene dos talleres principales que demuestran las mejores prácticas en desarrollo móvil con Flutter:

### Taller 1: Consumo de API REST - Star Wars
Implementa una aplicación que consulta la **Star Wars API (SWAPI)** para mostrar información de personajes del universo de Star Wars.

### Taller 2: Firebase Firestore - Gestión de Universidades
Implementa un sistema CRUD completo para gestionar información de universidades colombianas con sincronización en tiempo real usando Firestore.

## Características Implementadas

### Taller HTTP - Star Wars API
- ✅ **Consumo de API pública:** Star Wars API (swapi.dev)
- ✅ **Manejo de estados:** Loading, success, error con UI responsiva
- ✅ **Navegación:** go_router con paso de parámetros y rutas tipadas
- ✅ **Scroll infinito:** Paginación automática al llegar al final
- ✅ **Búsqueda en tiempo real:** Filtrado de personajes por nombre con debounce
- ✅ **Arquitectura limpia:** Separación por capas (models, services, views)
- ✅ **Manejo de errores:** HTTP, de red y de parsing JSON
- ✅ **Tema Star Wars:** Diseño visual inmersivo con efectos de neón

### Taller Firebase - Universidades CRUD
- ✅ **Cloud Firestore:** Base de datos NoSQL en tiempo real
- ✅ **CRUD completo:** Create, Read, Update, Delete de universidades
- ✅ **Sincronización en tiempo real:** StreamBuilder con actualizaciones instantáneas
- ✅ **Búsqueda avanzada:** Filtrado por nombre y NIT
- ✅ **Validaciones:** Formularios con validación de campos y NIT único
- ✅ **Arquitectura limpia:** Separación por capas (models, services, presentation)
- ✅ **Manejo de errores:** Firebase exceptions con UI apropiada
- ✅ **Firebase Integration:** Analytics y App Distribution configurados
- ✅ **Documentación:** Código completamente documentado

## Arquitectura del Proyecto

El proyecto sigue una arquitectura limpia (Clean Architecture) con separación por features, donde cada taller está completamente aislado y puede funcionar de manera independiente.

```
lib/
├── main.dart                          # Punto de entrada + Firebase init
├── core/
│   └── routing/
│       └── app_router.dart           # Configuración centralizada de rutas
└── features/
    ├── taller_http/                  # Feature: Taller HTTP - Star Wars
    │   ├── data/
    │   │   ├── models/              # Modelos de datos
    │   │   │   ├── character.dart   # Modelo de personaje
    │   │   │   ├── planet.dart      # Modelo de planeta
    │   │   │   └── api_response.dart # Modelo de respuesta
    │   │   └── services/            # Servicios de datos
    │   │       └── starwars_api_service.dart # Servicio de API REST
    │   └── presentation/
    │       └── pages/               # Páginas de la interfaz
    │           ├── home_page.dart   # Página principal
    │           ├── starwars_characters_page.dart # Lista
    │           └── character_detail_page.dart    # Detalle
    │
    └── taller_firebase/              # Feature: Taller Firebase
        ├── data/
        │   ├── models/              # Modelos de datos
        │   │   └── universidad.dart # Modelo de universidad
        │   └── services/            # Servicios de datos
        │       └── universidades_service.dart # Servicio CRUD Firestore
        └── presentation/
            └── pages/               # Páginas de la interfaz
                ├── universidades_list_page.dart  # Lista con StreamBuilder
                └── universidad_form_page.dart    # Formulario Create/Update
```

### Arquitectura por Capas

#### 1. Capa de Datos (Data Layer)
- **Models:** Clases que representan entidades de negocio
  - Serialización/deserialización JSON (API REST)
  - Conversión Firestore (toFirestore/fromFirestore)
- **Services:** Lógica de acceso a datos
  - Comunicación con APIs externas (HTTP)
  - Operaciones CRUD con Firestore
  - Manejo de errores y excepciones

#### 2. Capa de Presentación (Presentation Layer)
- **Pages:** Pantallas completas de la aplicación
  - Stateful widgets para manejo de estado local
  - StreamBuilder para datos en tiempo real
  - Formularios con validación
- **Widgets:** Componentes reutilizables (cuando aplica)

#### 3. Capa Core (Core Layer)
- **Routing:** Configuración centralizada de navegación
  - Definición de todas las rutas de la app
  - Paso de parámetros entre pantallas
  - Manejo de errores de navegación

## Tecnologías Utilizadas

- **Flutter SDK:** ^3.9.0
- **Dart:** ^3.0.0
- **Dependencias principales:**
  - `http: ^1.1.0` - Para consumo de API REST
  - `go_router: ^14.2.7` - Para navegación y rutas
  - `firebase_core: ^3.6.0` - Core de Firebase para inicialización
  - `cloud_firestore: ^5.4.4` - Base de datos NoSQL en tiempo real
  - `cupertino_icons: ^1.0.8` - Iconos iOS
- **Firebase (Android):**
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

## 🔥 Taller Firebase - Universidades CRUD

### Descripción Técnica

Sistema completo de gestión de universidades colombianas implementado con **Cloud Firestore** como base de datos en tiempo real. El módulo demuestra operaciones CRUD (Create, Read, Update, Delete) con sincronización instantánea entre dispositivos.

### Arquitectura del Módulo Firebase

#### Modelo de Datos - Universidad

```dart
class Universidad {
  final String? id;           // ID del documento en Firestore
  final String nit;          // Número de Identificación Tributaria
  final String nombre;       // Nombre de la universidad
  final String direccion;    // Dirección física
  final String telefono;     // Número de contacto
  final String paginaWeb;    // URL del sitio web

  // Métodos de serialización
  Map<String, dynamic> toFirestore()
  factory Universidad.fromFirestore(Map<String, dynamic> data, String id)
  Universidad copyWith({...})
}
```

**Campo en Firestore:** `pagina_web` (snake_case según convenciones NoSQL)

#### Servicio - UniversidadesService

Servicio centralizado que encapsula toda la lógica de negocio y comunicación con Firestore.

**Operaciones CRUD Implementadas:**

```dart
class UniversidadesService {
  final FirebaseFirestore _firestore;
  final CollectionReference _universidadesCollection;

  // CREATE
  Future<String> crearUniversidad(Universidad universidad)
  
  // READ
  Stream<List<Universidad>> obtenerUniversidades()
  Future<Universidad?> obtenerUniversidadPorId(String id)
  Stream<List<Universidad>> buscarUniversidades(String query)
  
  // UPDATE
  Future<void> actualizarUniversidad(Universidad universidad)
  
  // DELETE
  Future<void> eliminarUniversidad(String id)
  
  // UTILIDADES
  Future<bool> existeNit(String nit, {String? excludeId})
  Future<int> contarUniversidades()
}
```

#### Gestión de Estado

**StreamBuilder para Tiempo Real:**
```dart
StreamBuilder<List<Universidad>>(
  stream: _service.obtenerUniversidades(),
  builder: (context, snapshot) {
    // Maneja estados: loading, error, empty, success
  }
)
```

**Estados Manejados:**
- ✅ `ConnectionState.waiting` → CircularProgressIndicator
- ✅ `snapshot.hasError` → Pantalla de error con mensaje
- ✅ `!snapshot.hasData || empty` → Estado vacío con mensaje
- ✅ `snapshot.hasData` → ListView con datos

### Validaciones Implementadas

#### 1. Validación de Formularios

**Campo NIT:**
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'El NIT es requerido';
  }
  return null;
}
```

**Campo Nombre:**
```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre es requerido';
  }
  if (value.trim().length < 3) {
    return 'El nombre debe tener al menos 3 caracteres';
  }
  return null;
}
```

**Campo Página Web:**
```dart
validator: (value) {
  final urlPattern = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
  );
  if (!urlPattern.hasMatch(value.trim())) {
    return 'Ingresa una URL válida (debe comenzar con http:// o https://)';
  }
  return null;
}
```

#### 2. Validación de NIT Único

Antes de crear o actualizar, se verifica que el NIT no exista:

```dart
Future<bool> existeNit(String nit, {String? excludeId}) async {
  final query = await _universidadesCollection
    .where('nit', isEqualTo: nit)
    .get();
  
  if (excludeId != null) {
    // Excluir el documento actual al editar
    final docs = query.docs.where((doc) => doc.id != excludeId).toList();
    return docs.isNotEmpty;
  }
  
  return query.docs.isNotEmpty;
}
```

#### 3. Validación de Campos Obligatorios

Todos los campos son requeridos y validados antes de guardar:
- ✅ NIT no vacío
- ✅ Nombre con mínimo 3 caracteres
- ✅ Dirección no vacía
- ✅ Teléfono no vacío
- ✅ Página web con formato URL válido

### Funcionalidades de Búsqueda

**Búsqueda en Tiempo Real:**
```dart
Stream<List<Universidad>> buscarUniversidades(String query) {
  return _universidadesCollection
    .orderBy('nombre')
    .snapshots()
    .map((snapshot) {
      final universidades = snapshot.docs.map(...)toList();
      
      // Filtrado local (Firestore no soporta LIKE nativo)
      return universidades.where((uni) {
        return uni.nombre.toLowerCase().contains(query.toLowerCase()) ||
               uni.nit.contains(query);
      }).toList();
    });
}
```

**Criterios de Búsqueda:**
- Por nombre (case-insensitive, substring matching)
- Por NIT (coincidencia exacta o parcial)

### Manejo de Errores Firebase

```dart
try {
  await _service.crearUniversidad(universidad);
  // Mostrar SnackBar de éxito
} on FirebaseException catch (e) {
  // Error específico de Firebase
  showSnackBar('Error de Firebase: ${e.message}');
} catch (e) {
  // Error general
  showSnackBar('Error al guardar: $e');
}
```

**Errores Manejados:**
- ❌ Errores de permisos de Firestore
- ❌ Errores de red (sin conexión)
- ❌ Errores de validación de datos
- ❌ Errores de serialización

### Pantallas del Módulo

#### 1. UniversidadesListPage
- **Funcionalidad:** Lista de todas las universidades con búsqueda
- **Estado:** StreamBuilder para actualizaciones en tiempo real
- **Acciones:**
  - Ver detalle (Dialog con toda la información)
  - Editar universidad (navega a formulario)
  - Eliminar universidad (con confirmación)
  - Búsqueda en tiempo real
  - Agregar nueva universidad (FAB)

#### 2. UniversidadFormPage
- **Funcionalidad:** Crear o editar universidades
- **Modos:** Create (nuevo) / Update (editar)
- **Validaciones:** Formulario completo con validadores
- **Características:**
  - Carga de datos existentes en modo edición
  - Validación de NIT único
  - Indicador de carga durante operaciones
  - Botones de Cancelar/Guardar

### Colección Firestore

**Nombre:** `universidades`

**Estructura del Documento:**
```json
{
  "nit": "890123456-7",
  "nombre": "Unidad Central del Valle",
  "direccion": "Cra 27A #48-144, Tuluá - Valle",
  "telefono": "+57 602 2242202",
  "pagina_web": "https://www.uceva.edu.co"
}
```

**Índices:**
- Campo `nombre` (ordenamiento alfabético)
- Campo `nit` (búsqueda de unicidad)

### Sincronización en Tiempo Real

La aplicación se actualiza automáticamente cuando:
- ✅ Otro usuario crea una universidad
- ✅ Otro usuario actualiza datos
- ✅ Otro usuario elimina una universidad
- ✅ Se restaura la conexión a internet

Todo gracias a **Firestore Snapshots** que emiten eventos de cambio instantáneamente.

---

## Funcionalidades Principales

### Taller HTTP - Star Wars

#### 1. Lista de Personajes
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

### Taller HTTP - Star Wars
- [ ] Implementar cache local con SQLite
- [ ] Añadir modo offline
- [ ] Implementar favoritos de personajes
- [ ] Añadir animaciones de transición
- [ ] Filtros avanzados (por especie, género, etc.)

### Taller Firebase - Universidades
- [ ] Paginación en lista de universidades
- [ ] Filtros avanzados (por ciudad, región)
- [ ] Búsqueda con Algolia para mejor rendimiento
- [ ] Importación/Exportación de datos en CSV
- [ ] Estadísticas con gráficos
- [ ] Autenticación de usuarios con Firebase Auth
- [ ] Roles y permisos (admin/viewer)

### General
- [ ] Soporte para temas claro/oscuro
- [ ] Internacionalización (i18n)
- [ ] Tests unitarios y de integración completos
- [ ] CI/CD con GitHub Actions
- [ ] Versión iOS completa

## 📱 Publicación y Distribución

### Firebase App Distribution

Esta aplicación se distribuye usando **Firebase App Distribution** para testing con usuarios internos y QA.

#### Proceso de Distribución

```
Desarrollo → Build APK → Firebase App Distribution → Grupo QA → Testing → Actualización
```

#### Versiones Publicadas

| Versión | Build | Fecha | Contenido | Grupo | Estado |
|---------|-------|-------|-----------|-------|--------|
| 1.0.0 | 1 | Octubre 2025 | Taller HTTP - Star Wars API | QA_Clase | ✅ Distribuido |
| 1.0.1 | 2 | Noviembre 2025 | + Taller Firebase - Universidades CRUD | QA_Clase | 🚀 Listo para distribución |

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

Este proyecto de talleres demuestra con éxito:

### Taller HTTP - Star Wars API
1. **Consumo efectivo de APIs REST** en Flutter usando el paquete `http`
2. **Arquitectura escalable** con separación de responsabilidades
3. **Navegación moderna** con go_router y paso de parámetros
4. **Manejo robusto de estados y errores** HTTP
5. **UI/UX optimizada** con Material Design 3 y tema Star Wars inmersivo

### Taller Firebase - Universidades CRUD
1. **Integración completa con Firebase** (Core + Firestore)
2. **Operaciones CRUD en tiempo real** con sincronización instantánea
3. **Validaciones robustas** en formularios y datos únicos
4. **Manejo de StreamBuilder** para datos en tiempo real
5. **Arquitectura limpia** con separación de capas
6. **Manejo de errores Firebase** con UI apropiada

### Integración y Distribución
1. **Firebase App Distribution** para testing y distribución
2. **Firebase Analytics** para métricas de uso
3. **Git Flow** profesional con ramas feature, develop y main
4. **Código mantenible** con documentación completa
5. **Arquitectura modular** con features independientes

El proyecto sirve como base sólida para aplicaciones Flutter que requieren:
- ✅ Consumo de APIs REST externas
- ✅ Gestión de datos en tiempo real con Firebase
- ✅ Navegación compleja entre múltiples módulos
- ✅ Validaciones de formularios y datos
- ✅ Distribución con Firebase App Distribution

Demuestra las **mejores prácticas del desarrollo móvil moderno** con Flutter y Firebase.

## Contacto

**Cristopher Arias Contreras**  
Estudiante de Ingeniería de Sistemas  
 cristopher.arias01@uceva.edu.co