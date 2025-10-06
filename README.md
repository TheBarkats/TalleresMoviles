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

## Taller: Segundo Plano - Asincronía, Timer e Isolates

### 📋 Descripción del Nuevo Taller

Este nuevo taller demuestra conceptos avanzados de programación asíncrona en Flutter:

- **🔄 Future/async/await**: Operaciones asíncronas no bloqueantes
- **⏱️ Timer**: Cronómetro y cuenta regresiva con controles
- **🧮 Isolates**: Tareas CPU-intensivas sin bloquear la UI

### 🏗️ Estructura Implementada

```
lib/features/taller_segundo_plano/
├── services/
│   ├── async_service.dart      # Simulación de consultas asíncronas
│   ├── timer_service.dart      # Manejo de Timer con Streams
│   └── isolate_service.dart    # Procesamiento en Isolates
└── presentation/pages/
    ├── async_demo_page.dart    # Demo de Future/async/await
    ├── timer_demo_page.dart    # Demo de cronómetro
    └── isolate_demo_page.dart  # Demo de Isolates
```

### 🎯 Funcionalidades Principales

#### 1. **Demo de Async/Await**
- Consultas simuladas con `Future.delayed()`
- Manejo de estados: Loading → Success/Error
- Operaciones paralelas con `Future.wait()`
- Logs detallados para debugging
- UI responsiva durante operaciones

#### 2. **Demo de Timer**
- Cronómetro (cuenta hacia arriba)
- Cuenta regresiva (countdown personalizable)  
- Controles: Iniciar/Pausar/Reanudar/Reiniciar
- Streams para comunicar cambios de estado
- Limpieza automática de recursos

#### 3. **Demo de Isolates**
- Cálculos matemáticos pesados (suma compleja)
- Generación de números primos
- Procesamiento de datos simulado
- UI permanece fluida durante cálculos
- Comunicación por mensajes entre Isolates

### 💡 Conceptos Demostrados

#### **Asincronía**
```dart
// Ejemplo de consulta asíncrona
Future<List<String>> fetchData({int delaySeconds = 3}) async {
  await Future.delayed(Duration(seconds: delaySeconds));
  
  // Simulación de posible error
  if (Random().nextInt(10) < 2) {
    throw Exception('Error simulado de red');
  }
  
  return ['Dato 1', 'Dato 2', 'Dato 3'];
}
```

#### **Timer con Streams**
```dart
Timer? _timer;
final StreamController<int> _timeController = StreamController<int>.broadcast();

void startTimer() {
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    _seconds++;
    _timeController.add(_seconds); // Notificar cambios
  });
}
```

#### **Isolates para CPU**
```dart
// Función que se ejecuta en Isolate separado
void _heavySumIsolate(IsolateData data) {
  double sum = 0;
  for (int i = 0; i < data.iterations; i++) {
    sum += sqrt(i * i + 1) * sin(i) * cos(i);
  }
  
  data.sendPort.send(BigSumResult(sum: sum, iterations: data.iterations));
}
```

### 🔍 Características Técnicas

#### **Manejo de Estados**
- Loading states con indicadores visuales
- Error handling con mensajes informativos  
- Success states con datos formateados

#### **Resource Management**
```dart
@override
void dispose() {
  _timer?.cancel();              // Cancelar timers
  _timeController.close();       // Cerrar streams
  _receivePort.close();         // Cerrar communication ports
  super.dispose();
}
```

#### **UI Responsiva**
- Animaciones que demuestran fluidez durante Isolates
- Contadores en tiempo real para probar no-bloqueo
- Layout adaptativo con LayoutBuilder

### 📊 Casos de Uso Prácticos

#### **Future/async/await**
- Autenticación de usuarios
- Carga de datos desde APIs
- Operaciones de base de datos
- Upload/download de archivos

#### **Timer**
- Aplicaciones de fitness (cronómetros)
- Juegos (timeouts, countdowns)
- Notificaciones periódicas
- Auto-refresh de contenido

#### **Isolates**
- Procesamiento de imágenes
- Parsing de archivos grandes (JSON/CSV)
- Algoritmos de ordenamiento
- Cálculos científicos/matemáticos

### 🚀 Cómo Probar

1. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

2. **Navegar a las demos**:
   - Página principal muestra 3 tarjetas principales
   - Cada demo incluye explicaciones y ejemplos interactivos
   - Revisar la consola de debug para logs detallados

3. **Probar funcionalidades**:
   - **Async**: Botones para consultas de diferentes duraciones
   - **Timer**: Cronómetro y countdown con controles
   - **Isolates**: Diferentes tipos de procesamiento CPU-intensivo

### 📈 Logging Detallado

El proyecto incluye logging comprensivo para seguimiento:

```
🔵 [AsyncService] Iniciando consulta de datos...
🟢 [AsyncService] Datos obtenidos exitosamente
⏱️ [TimerService] Iniciando cronómetro  
🔧 [IsolateService] Iniciando cálculo pesado
✅ [IsolateService] Cálculo completado
```

---

