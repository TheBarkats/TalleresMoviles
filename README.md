# Talleres Móviles - Flutter

Este repositorio contiene los talleres de la asignatura "Electiva profesional I" - Desarrollo Móvil.

## Datos del estudiante
- **Nombre completo:** Cristopher Arias Contreras
- **Código:** 230222032

## Taller 2 - Navegación y Widgets Avanzados

Este proyecto demuestra conceptos avanzados de Flutter incluyendo navegación con go_router, widgets personalizados y ciclo de vida de widgets.

### 🚀 Características Implementadas

#### 1. Navegación y Paso de Parámetros

##### go_router Configuración
La aplicación utiliza `go_router` como sistema de navegación principal, configurado en `lib/core/routing/app_router.dart`.

##### Rutas Definidas:
- **`/`** - Página principal con catálogo de productos (GridView)
- **`/product/:id`** - Página de detalle del producto (recibe ID como parámetro de ruta y nombre como query parameter)
- **`/navigation-demo`** - Página de demostración de tipos de navegación
- **`/navigation-demo/result/:method`** - Página de resultado para demostrar diferencias de navegación

##### Paso de Parámetros:
```dart
// Ejemplo de navegación con parámetros
context.go('/product/${product.id}?name=${Uri.encodeComponent(product.name)}');

// En la página de destino se reciben así:
final productId = state.pathParameters['id']!;
final productName = state.uri.queryParameters['name'] ?? 'Producto sin nombre';
```

##### Diferencias entre Métodos de Navegación:

| Método | Comportamiento | Uso Recomendado |
|--------|---------------|-----------------|
| `context.go()` | Reemplaza toda la pila de navegación | Cambios de flujo completos, autenticación |
| `context.push()` | Añade nueva pantalla a la pila | Detalles, formularios, pantallas temporales |
| `context.replace()` | Reemplaza la pantalla actual | Flujos paso a paso, confirmaciones |

#### 2. Widgets Implementados

##### 2.1 GridView (Página Principal)
- **Ubicación**: `lib/features/taller2/presentation/pages/home_page.dart`
- **Propósito**: Mostrar un catálogo de productos en formato de cuadrícula
- **Configuración**: 
  - 2 columnas
  - Relación aspecto 0.75
  - Espaciado de 8px
- **Razón de elección**: GridView es ideal para mostrar elementos en formato de galería/catálogo, permitiendo al usuario ver múltiples productos a la vez de manera organizada.

##### 2.2 TabBar (Página de Detalles)
- **Ubicación**: `lib/features/taller2/presentation/pages/product_detail_page.dart`
- **Propósito**: Organizar información del producto en secciones
- **Pestañas**:
  - **Detalles**: Descripción y características
  - **Specs**: Especificaciones técnicas
  - **Galería**: Carrusel de imágenes
- **Razón de elección**: TabBar permite organizar gran cantidad de información de manera estructurada, mejorando la experiencia del usuario al evitar scroll excesivo.

##### 2.3 ImageCarouselWidget (Widget Personalizado)
- **Ubicación**: `lib/features/taller2/presentation/widgets/image_carousel_widget.dart`
- **Propósito**: Carrusel de imágenes con auto-play y controles manuales
- **Características**:
  - Auto-play configurable
  - Indicadores de página
  - Controles de navegación
  - Gestos táctiles para pausar/reanudar
- **Razón de elección**: Un carrusel de imágenes es fundamental en aplicaciones de e-commerce para mostrar múltiples vistas de un producto de manera atractiva e interactiva.

#### 3. Ciclo de Vida de Widgets

Todos los widgets implementados incluyen logging completo del ciclo de vida con comentarios explicativos:

##### Métodos del Ciclo de Vida Monitoreados:

```dart
@override
void initState() {
  super.initState();
  // 🟢 LIFECYCLE: Se ejecuta una sola vez al crear el widget
  // Uso: Inicialización que no depende del contexto
  print('🟢 Widget - initState(): Inicializando...');
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  // 🟡 LIFECYCLE: Se ejecuta después de initState y cuando cambian las dependencias
  // Uso: Operaciones que dependen del contexto (Theme, MediaQuery, etc.)
  print('🟡 Widget - didChangeDependencies(): Configurando dependencias...');
}

@override
Widget build(BuildContext context) {
  // 🔵 LIFECYCLE: Se ejecuta cada vez que se necesita reconstruir
  // Uso: Construcción de la interfaz de usuario
  print('🔵 Widget - build(): Construyendo UI...');
  return Scaffold(...);
}

void _someAction() {
  setState(() {
    // 🔄 LIFECYCLE: Marca el widget como "dirty" y programa reconstrucción
    // Uso: Actualizar UI después de cambiar el estado
    print('🔄 Widget - setState(): Actualizando estado...');
  });
}

@override
void dispose() {
  // 🔴 LIFECYCLE: Se ejecuta cuando el widget se elimina permanentemente
  // Uso: Limpiar recursos, cancelar suscripciones, etc.
  print('🔴 Widget - dispose(): Limpiando recursos...');
  super.dispose();
}
```

##### Cuándo y Por Qué de Cada Método:

| Método | Cuándo se ejecuta | Por qué es importante |
|--------|-------------------|----------------------|
| `initState()` | Una vez al crear el widget | Inicializar controladores, variables, suscripciones |
| `didChangeDependencies()` | Después de initState y cuando cambian dependencias | Configurar elementos que dependen del contexto |
| `build()` | En cada reconstrucción | Definir la estructura de la UI |
| `setState()` | Cuando se llama manualmente | Notificar cambios de estado y reconstruir |
| `dispose()` | Al eliminar el widget | Evitar memory leaks liberando recursos |

### 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                           # Punto de entrada, configuración de la app
├── core/
│   └── routing/
│       └── app_router.dart            # Configuración de go_router
└── features/
    └── taller2/
        └── presentation/
            ├── pages/
            │   ├── home_page.dart              # Página principal con GridView
            │   ├── product_detail_page.dart    # Página de detalle con TabBar
            │   └── navigation_demo_page.dart   # Demo de navegación
            └── widgets/
                └── image_carousel_widget.dart  # Widget personalizado
```

### 🛠️ Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^14.2.7
```

### 🔍 Observación del Ciclo de Vida

Para ver los logs del ciclo de vida en acción:

1. **Ejecutar la aplicación**: `flutter run`
2. **Abrir la consola de debug** en tu IDE
3. **Navegar entre pantallas** y observar los logs con emojis:
   - 🟢 initState
   - 🟡 didChangeDependencies  
   - 🔵 build
   - 🔄 setState
   - 🔴 dispose

## Taller 1 - Widgets Básicos
Este proyecto es un taller práctico de Flutter donde se implementan widgets básicos, manejo de estado, imágenes, botones y diseño visual.

## Pasos para ejecutar

### Para Taller 2:
1. Clona el repositorio:
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd talleresmoviles
   ```

2. Cambiar a la rama del taller:
   ```bash
   git checkout feature/taller2
   ```

3. Instalar dependencias:
   ```bash
   flutter pub get
   ```

4. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

### Para Taller 1:
1. Clona el repositorio o descarga el código fuente.
2. Abre una terminal en la carpeta del proyecto.
3. Ejecuta:
   ```bash
   flutter pub get
   ```
   para instalar las dependencias.
4. Luego ejecuta:
   ```bash
   flutter run
   ```
   para iniciar la aplicación.

---

**Desarrollado por**: Cristopher Arias Contreras  
**Curso**: Electiva profesional I - Desarrollo Móvil  
**Tecnologías**: Flutter, Dart, go_router
   ```
   flutter run
   ```
   para iniciar la aplicación en un emulador o dispositivo físico.

## Capturas de pantalla
En el word enviado


---

