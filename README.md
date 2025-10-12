# Taller HTTP - Star Wars API# Taller HTTP - Star Wars API



Aplicación Flutter que demuestra el consumo de APIs REST utilizando el paquete `http`, implementando arquitectura limpia y navegación con parámetros.Aplicación Flutter que demuestra el consumo de APIs REST utilizando el paquete `http`, implementando arquitectura limpia y navegación con parámetros.



## Información Académica## Información Académica



**Estudiante:** Cristopher Arias Contreras  **Estudiante:** Cristopher Arias Contreras  

**Código:** 230222032  **Código:** 230222032  

**Asignatura:** Electiva profesional I - Desarrollo Móvil  **Asignatura:** Electiva profesional I - Desarrollo Móvil  

**Semestre:** VII Semestre  **Semestre:** VII Semestre  

**Universidad:** Unidad Central del Valle  **Universidad:** Unidad Central del Valle  



## Descripción del Proyecto## Descripción del Proyecto



Este taller está desarrollado como parte de la **Electiva profesional I - Desarrollo Móvil** y demuestra las mejores prácticas para el consumo de APIs REST en Flutter, implementando una aplicación que consulta la **Star Wars API (SWAPI)** para mostrar información de personajes del universo de Star Wars.Este taller está desarrollado como parte de la **Electiva profesional I - Desarrollo Móvil** y demuestra las mejores prácticas para el consumo de APIs REST en Flutter, implementando una aplicación que consulta la **Star Wars API (SWAPI)** para mostrar información de personajes del universo de Star Wars.



## Características Implementadas## Características Implementadas



- ✅ **Consumo de API pública:** Star Wars API (swapi.dev)- ✅ **Consumo de API pública:** Star Wars API (swapi.dev)

- ✅ **Manejo de estados:** Loading, success, error con UI responsiva- ✅ **Manejo de estados:** Loading, success, error con UI responsiva

- ✅ **Navegación:** go_router con paso de parámetros y rutas tipadas- ✅ **Navegación:** go_router con paso de parámetros y rutas tipadas

- ✅ **Scroll infinito:** Paginación automática al llegar al final- ✅ **Scroll infinito:** Paginación automática al llegar al final

- ✅ **Búsqueda en tiempo real:** Filtrado de personajes por nombre con debounce- ✅ **Búsqueda en tiempo real:** Filtrado de personajes por nombre con debounce

- ✅ **Arquitectura limpia:** Separación por capas (models, services, views)- ✅ **Arquitectura limpia:** Separación por capas (models, services, views)

- ✅ **Manejo de errores:** HTTP, de red y de parsing JSON- ✅ **Manejo de errores:** HTTP, de red y de parsing JSON

- ✅ **Tema Star Wars:** Diseño visual inmersivo con efectos de neón- ✅ **Tema Star Wars:** Diseño visual inmersivo con efectos de neón

- ✅ **Documentación:** Código completamente documentado- ✅ **Documentación:** Código completamente documentado

##### Rutas Definidas:

## Arquitectura del Proyecto- **`/`** - Página principal con catálogo de productos (GridView)

- **`/product/:id`** - Página de detalle del producto (recibe ID como parámetro de ruta y nombre como query parameter)

```- **`/navigation-demo`** - Página de demostración de tipos de navegación

lib/- **`/navigation-demo/result/:method`** - Página de resultado para demostrar diferencias de navegación

├── main.dart                          # Punto de entrada de la aplicación

├── core/##### Paso de Parámetros:

│   └── routing/```dart

│       └── app_router.dart           # Configuración de rutas con go_router// Ejemplo de navegación con parámetros

└── features/context.go('/product/${product.id}?name=${Uri.encodeComponent(product.name)}');

    ├── taller2/

    │   └── presentation/pages/// En la página de destino se reciben así:

    │       └── home_page.dart        # Página principal del tallerfinal productId = state.pathParameters['id']!;

    └── taller_http/                  # Feature del taller HTTPfinal productName = state.uri.queryParameters['name'] ?? 'Producto sin nombre';

        ├── data/```

        │   ├── models/              # Modelos de datos

        │   │   ├── character.dart   # Modelo de personaje##### Diferencias entre Métodos de Navegación:

        │   │   ├── planet.dart      # Modelo de planeta

        │   │   └── api_response.dart # Modelo de respuesta de API| Método | Comportamiento | Uso Recomendado |

        │   └── services/            # Servicios de datos|--------|---------------|-----------------|

        │       └── star_wars_api_service.dart # Servicio de API| `context.go()` | Reemplaza toda la pila de navegación | Cambios de flujo completos, autenticación |

        └── presentation/| `context.push()` | Añade nueva pantalla a la pila | Detalles, formularios, pantallas temporales |

            └── pages/               # Páginas de la interfaz| `context.replace()` | Reemplaza la pantalla actual | Flujos paso a paso, confirmaciones |

                ├── star_wars_characters_page.dart # Lista de personajes

                └── character_detail_page.dart     # Detalle del personaje#### 2. Widgets Implementados

```

##### 2.1 GridView (Página Principal)

## Tecnologías Utilizadas- **Ubicación**: `lib/features/taller2/presentation/pages/home_page.dart`

- **Propósito**: Mostrar un catálogo de productos en formato de cuadrícula

- **Flutter SDK:** ^3.9.0- **Configuración**: 

- **Dart:** ^3.0.0  - 2 columnas

- **Dependencias principales:**  - Relación aspecto 0.75

  - `http: ^1.1.0` - Para consumo de API REST  - Espaciado de 8px

  - `go_router: ^14.2.7` - Para navegación y rutas- **Razón de elección**: GridView es ideal para mostrar elementos en formato de galería/catálogo, permitiendo al usuario ver múltiples productos a la vez de manera organizada.

  - `cupertino_icons: ^1.0.8` - Iconos iOS

##### 2.2 TabBar (Página de Detalles)

## API Utilizada- **Ubicación**: `lib/features/taller2/presentation/pages/product_detail_page.dart`

- **Propósito**: Organizar información del producto en secciones

**Star Wars API (SWAPI)**- **Pestañas**:

- **Base URL:** https://swapi.dev/api/  - **Detalles**: Descripción y características

- **Endpoint principal:** `/people/` (personajes)  - **Specs**: Especificaciones técnicas

- **Documentación:** [swapi.dev](https://swapi.dev)  - **Galería**: Carrusel de imágenes

- **Razón de elección**: TabBar permite organizar gran cantidad de información de manera estructurada, mejorando la experiencia del usuario al evitar scroll excesivo.

### Estructura de respuesta de la API:

##### 2.3 ImageCarouselWidget (Widget Personalizado)

```json- **Ubicación**: `lib/features/taller2/presentation/widgets/image_carousel_widget.dart`

{- **Propósito**: Carrusel de imágenes con auto-play y controles manuales

  "name": "Luke Skywalker",- **Características**:

  "height": "172",  - Auto-play configurable

  "mass": "77",  - Indicadores de página

  "hair_color": "blond",  - Controles de navegación

  "skin_color": "fair",  - Gestos táctiles para pausar/reanudar

  "eye_color": "blue",- **Razón de elección**: Un carrusel de imágenes es fundamental en aplicaciones de e-commerce para mostrar múltiples vistas de un producto de manera atractiva e interactiva.

  "birth_year": "19BBY",

  "gender": "male",#### 3. Ciclo de Vida de Widgets

  "homeworld": "https://swapi.dev/api/planets/1/",

  "films": ["https://swapi.dev/api/films/1/"],Todos los widgets implementados incluyen logging completo del ciclo de vida con comentarios explicativos:

  "species": [],

  "vehicles": ["https://swapi.dev/api/vehicles/14/"],##### Métodos del Ciclo de Vida Monitoreados:

  "starships": ["https://swapi.dev/api/starships/12/"],

  "created": "2014-12-09T13:50:51.644000Z",```dart

  "edited": "2014-12-20T21:17:56.891000Z",@override

  "url": "https://swapi.dev/api/people/1/"void initState() {

}  super.initState();

```  // 🟢 LIFECYCLE: Se ejecuta una sola vez al crear el widget

  // Uso: Inicialización que no depende del contexto

## Funcionalidades Principales  print('🟢 Widget - initState(): Inicializando...');

}

### 1. Lista de Personajes

- **Pantalla:** `StarWarsCharactersPage`@override

- **Funcionalidades:**void didChangeDependencies() {

  - Carga inicial de 82 personajes  super.didChangeDependencies();

  - Barra de búsqueda en tiempo real  // 🟡 LIFECYCLE: Se ejecuta después de initState y cuando cambian las dependencias

  - Scroll infinito con indicador de carga  // Uso: Operaciones que dependen del contexto (Theme, MediaQuery, etc.)

  - Manejo de estados (loading/success/error)  print('🟡 Widget - didChangeDependencies(): Configurando dependencias...');

  - Navegación a detalle por tap}

  - Tema visual Star Wars con efectos de neón

@override

### 2. Detalle del PersonajeWidget build(BuildContext context) {

- **Pantalla:** `CharacterDetailPage`  // 🔵 LIFECYCLE: Se ejecuta cada vez que se necesita reconstruir

- **Funcionalidades:**  // Uso: Construcción de la interfaz de usuario

  - Información completa del personaje  print('🔵 Widget - build(): Construyendo UI...');

  - Carga de información del planeta natal  return Scaffold(...);

  - UI responsiva con tema Star Wars}

  - Navegación de regreso

  - Imágenes de personajes integradasvoid _someAction() {

  setState(() {

### 3. Manejo de Estados    // 🔄 LIFECYCLE: Marca el widget como "dirty" y programa reconstrucción

- **Loading:** Indicadores de carga durante peticiones HTTP    // Uso: Actualizar UI después de cambiar el estado

- **Success:** Muestra de datos con UI optimizada    print('🔄 Widget - setState(): Actualizando estado...');

- **Error:** Manejo de errores de red, HTTP y parsing  });

}

## Instalación y Ejecución

@override

### Prerrequisitosvoid dispose() {

- Flutter SDK ^3.9.0  // 🔴 LIFECYCLE: Se ejecuta cuando el widget se elimina permanentemente

- Dart ^3.0.0  // Uso: Limpiar recursos, cancelar suscripciones, etc.

- Android Studio / VS Code  print('🔴 Widget - dispose(): Limpiando recursos...');

- Dispositivo Android/iOS o emulador  super.dispose();

}

### Pasos de instalación:```



1. **Clonar el repositorio:**##### Cuándo y Por Qué de Cada Método:

```bash

git clone <repository-url>| Método | Cuándo se ejecuta | Por qué es importante |

cd talleresmoviles|--------|-------------------|----------------------|

```| `initState()` | Una vez al crear el widget | Inicializar controladores, variables, suscripciones |

| `didChangeDependencies()` | Después de initState y cuando cambian dependencias | Configurar elementos que dependen del contexto |

2. **Instalar dependencias:**| `build()` | En cada reconstrucción | Definir la estructura de la UI |

```bash| `setState()` | Cuando se llama manualmente | Notificar cambios de estado y reconstruir |

flutter pub get| `dispose()` | Al eliminar el widget | Evitar memory leaks liberando recursos |

```

### Arquitectura del Proyecto

3. **Verificar configuración de Flutter:**=======

```bash## Arquitectura del Proyecto

flutter doctor>>>>>>> develop

```

```

4. **Ejecutar la aplicación:**lib/

```bash├── main.dart                          # Punto de entrada de la aplicación

flutter run├── core/

```│   └── routing/

│       └── app_router.dart           # Configuración de rutas con go_router

## Capturas de Pantalla└── features/

    ├── taller2/

### Pantalla Principal    │   └── presentation/pages/

- Interfaz limpia con información del taller    │       └── home_page.dart        # Página principal del taller

- Botón principal para acceder a los personajes    └── taller_http/                  # Feature del taller HTTP

- FAB con información del proyecto y estudiante        ├── data/

        │   ├── models/              # Modelos de datos

### Lista de Personajes        │   │   ├── character.dart   # Modelo de personaje

- Grid view con tarjetas de personajes temáticas        │   │   ├── planet.dart      # Modelo de planeta

- Barra de búsqueda con efectos visuales Star Wars        │   │   └── api_response.dart # Modelo de respuesta de API

- Scroll infinito con paginación        │   └── services/            # Servicios de datos

- Imágenes de personajes integradas        │       └── star_wars_api_service.dart # Servicio de API

        └── presentation/

### Detalle del Personaje            └── pages/               # Páginas de la interfaz

- Información completa del personaje con tema visual                ├── star_wars_characters_page.dart # Lista de personajes

- Datos del planeta natal                └── character_detail_page.dart     # Detalle del personaje

- Navegación fluida de regreso```

- Diseño inmersivo Star Wars

<<<<<<< HEAD

## Patrones de Diseño Implementados### Dependencias

=======

### 1. Arquitectura Limpia (Clean Architecture)## Tecnologías Utilizadas

- **Separación por capas:** data, domain (implícito), presentation>>>>>>> develop

- **Inversión de dependencias:** Services → Models → Views

- **Responsabilidad única:** Cada clase tiene una función específica- **Flutter SDK:** ^3.9.0

- **Dart:** ^3.0.0

### 2. Repository Pattern (Simplificado)- **Dependencias principales:**

- **StarWarsApiService:** Encapsula la lógica de acceso a datos  - `http: ^1.1.0` - Para consumo de API REST

- **Abstracción:** Separación entre fuente de datos y presentación  - `go_router: ^14.2.7` - Para navegación y rutas

  - `cupertino_icons: ^1.0.8` - Iconos iOS

### 3. Model-View Pattern

- **Models:** Representación de datos con JSON serialization## API Utilizada

- **Views:** Widgets de presentación sin lógica de negocio

**Star Wars API (SWAPI)**

## Manejo de Errores- **Base URL:** https://swapi.info/api/

- **Endpoint principal:** `/people/` (personajes)

### Tipos de errores manejados:- **Documentación:** [swapi.info](https://swapi.info)

1. **Errores de red:** Sin conexión a internet

2. **Errores HTTP:** 404, 500, timeout### Estructura de respuesta de la API:

3. **Errores de parsing:** JSON malformado

4. **Errores de aplicación:** Estados inválidos```json

{

### Implementación:  "name": "Luke Skywalker",

```dart  "height": "172",

try {  "mass": "77",

  final response = await http.get(uri);  "hair_color": "blond",

  if (response.statusCode == 200) {  "skin_color": "fair",

    // Procesar datos exitosamente  "eye_color": "blue",

  } else {  "birth_year": "19BBY",

    throw Exception('Error HTTP: ${response.statusCode}');  "gender": "male",

  }  "homeworld": "https://swapi.info/api/planets/1/",

} catch (e) {  "films": ["https://swapi.info/api/films/1/"],

  // Manejo de errores con UI apropiada  "species": [],

}  "vehicles": ["https://swapi.info/api/vehicles/14/"],

```  "starships": ["https://swapi.info/api/starships/12/"],

  "created": "2014-12-09T13:50:51.644000Z",

## Testing  "edited": "2014-12-20T21:17:56.891000Z",

  "url": "https://swapi.info/api/people/1/"

El proyecto incluye:}

- **Widget tests:** Verificación de UI components```

- **Unit tests:** Validación de models y services

- **Integration tests:** Flujos completos de usuario<<<<<<< HEAD

### Observación del Ciclo de Vida

Para ejecutar los tests:=======

```bash## Funcionalidades Principales

flutter test>>>>>>> develop

```

### 1. Lista de Personajes

## Mejoras Futuras- **Pantalla:** `StarWarsCharactersPage`

- **Funcionalidades:**

- [ ] Implementar cache local con SQLite  - Carga inicial de 82 personajes

- [ ] Añadir modo offline  - Barra de búsqueda en tiempo real

- [ ] Implementar favoritos  - Scroll infinito con indicador de carga

- [ ] Añadir animaciones de transición  - Manejo de estados (loading/success/error)

- [ ] Soporte para temas claro/oscuro  - Navegación a detalle por tap

- [ ] Internacionalización (i18n)

### 2. Detalle del Personaje

## Conclusiones- **Pantalla:** `CharacterDetailPage`

- **Funcionalidades:**

Este taller demuestra con éxito:  - Información completa del personaje

  - Carga de información del planeta natal

1. **Consumo efectivo de APIs REST** en Flutter usando el paquete `http`  - UI responsiva con Cards y Material 3

2. **Arquitectura escalable** con separación de responsabilidades  - Navegación de regreso

3. **Navegación moderna** con go_router y paso de parámetros

4. **Manejo robusto de estados y errores**### 3. Manejo de Estados

5. **UI/UX optimizada** con Material Design 3 y tema Star Wars- **Loading:** Indicadores de carga durante peticiones HTTP

6. **Código mantenible** con documentación completa- **Success:** Muestra de datos con UI optimizada

- **Error:** Manejo de errores de red, HTTP y parsing

El proyecto sirve como base sólida para aplicaciones Flutter que requieren consumo de APIs REST y demuestra las mejores prácticas del desarrollo móvil moderno.

## Instalación y Ejecución

## Contacto

### Prerrequisitos

**Cristopher Arias Contreras**  - Flutter SDK ^3.9.0

Estudiante de Ingeniería de Sistemas  - Dart ^3.0.0

📧 cristopher.arias01@uceva.edu.co- Android Studio / VS Code
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

## Conclusiones

Este taller demuestra con éxito:

1. **Consumo efectivo de APIs REST** en Flutter usando el paquete `http`
2. **Arquitectura escalable** con separación de responsabilidades
3. **Navegación moderna** con go_router y paso de parámetros
4. **Manejo robusto de estados y errores**
5. **UI/UX optimizada** con Material Design 3
6. **Código mantenible** con documentación completa

El proyecto sirve como base sólida para aplicaciones Flutter que requieren consumo de APIs REST y demuestra las mejores prácticas del desarrollo móvil moderno.

## Contacto

**Cristopher Arias Contreras**  
Estudiante de Ingeniería de Sistemas  
 cristopher.arias01@uceva.edu.co