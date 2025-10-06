import 'package:flutter/material.dart';
import '../../../taller_segundo_plano/presentation/pages/async_demo_page.dart';
import '../../../taller_segundo_plano/presentation/pages/timer_demo_page.dart';
import '../../../taller_segundo_plano/presentation/pages/isolate_demo_page.dart';

/// Modelo para las demos del taller de segundo plano
class DemoItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget page;
  final String subtitle;

  DemoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.page,
    required this.subtitle,
  });
}

/// Página principal que demuestra asincronía, Timer e Isolates
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de demos para el taller de segundo plano
  final List<DemoItem> demos = [
    DemoItem(
      title: 'Async/Await',
      subtitle: 'Future y Asincronía',
      description: 'Demuestra Future, async/await y manejo de estados asíncronos sin bloquear la UI',
      icon: Icons.schedule,
      color: Colors.blue,
      page: const AsyncDemoPage(),
    ),
    DemoItem(
      title: 'Timer',
      subtitle: 'Cronómetro y Countdown',
      description: 'Implementa cronómetro y cuenta regresiva usando Timer con controles completos',
      icon: Icons.timer,
      color: Colors.orange,
      page: const TimerDemoPage(),
    ),
    DemoItem(
      title: 'Isolates',
      subtitle: 'Tareas CPU-intensivas',
      description: 'Ejecuta cálculos pesados en Isolates sin bloquear la interfaz de usuario',
      icon: Icons.memory,
      color: Colors.purple,
      page: const IsolateDemoPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // LIFECYCLE: initState se ejecuta una sola vez al crear el widget
    debugPrint('🟢 HomePage - initState(): Inicializando taller de segundo plano con ${demos.length} demos');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // LIFECYCLE: Se ejecuta después de initState y cuando cambian las dependencias
    debugPrint('🟡 HomePage - didChangeDependencies(): Configurando dependencias del contexto');
  }

  @override
  Widget build(BuildContext context) {
    // LIFECYCLE: Se ejecuta cada vez que se necesita reconstruir el widget
    // Se llama después de initState, didChangeDependencies y setState
    debugPrint('🔵 HomePage - build(): Construyendo interfaz de usuario');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taller: Segundo Plano - Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Header con información
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.workspaces, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Asincronía, Timer e Isolates',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecciona una demo para explorar conceptos de programación asíncrona en Flutter',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          
          // GridView con demos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Una columna para mejor visualización
                  childAspectRatio: 3.0, // Más ancho que alto
                  mainAxisSpacing: 16.0,
                ),
                itemCount: demos.length,
                itemBuilder: (context, index) {
                  final demo = demos[index];
                  return _buildDemoCard(demo);
                },
              ),
            ),
          ),
        ],
      ),
      
      // Información adicional
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showProjectInfo,
        icon: const Icon(Icons.info),
        label: const Text('Info del Proyecto'),
      ),
    );
  }

  /// Construye una tarjeta para cada demo del taller
  Widget _buildDemoCard(DemoItem demo) {
    return Card(
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDemo(demo),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                demo.color.withOpacity(0.1),
                demo.color.withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icono de la demo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: demo.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: demo.color.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    demo.icon,
                    size: 32,
                    color: demo.color,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Contenido de la demo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        demo.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: demo.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        demo.subtitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: demo.color.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        demo.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Flecha indicadora
                Icon(
                  Icons.arrow_forward_ios,
                  color: demo.color.withOpacity(0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navega a la demo seleccionada
  void _navigateToDemo(DemoItem demo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => demo.page,
      ),
    );
  }

  /// Muestra información del proyecto
  void _showProjectInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Información del Proyecto'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Taller: Segundo Plano en Flutter\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Este proyecto demuestra:\n\n'
                '🔄 Asincronía con Future/async/await\n'
                '• Simulación de consultas con delay\n'
                '• Manejo de estados (Loading/Success/Error)\n'
                '• Operaciones paralelas con Future.wait\n\n'
                '⏱️ Timer para cronómetro y countdown\n'
                '• Timer.periodic con controles completos\n'
                '• Streams para comunicar cambios\n'
                '• Limpieza de recursos en dispose()\n\n'
                '🧮 Isolates para tareas CPU-intensivas\n'
                '• Cálculos pesados sin bloquear UI\n'
                '• Comunicación por mensajes\n'
                '• Diferentes tipos de procesamiento\n\n'
                '💡 Todos los ejemplos incluyen:\n'
                '• Logs detallados en consola\n'
                '• Documentación inline\n'
                '• UI responsiva y profesional',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // LIFECYCLE: Se ejecuta cuando el widget se elimina permanentemente
    debugPrint('🔴 HomePage - dispose(): Limpiando recursos del taller segundo plano');
    super.dispose();
  }
}