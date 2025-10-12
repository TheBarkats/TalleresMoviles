import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Página principal del Taller HTTP - Star Wars API
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    debugPrint('HomePage - initState(): Inicializando Taller HTTP - Star Wars API');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('HomePage - didChangeDependencies(): Configurando dependencias del contexto');
  }

  @override
  void dispose() {
    debugPrint('HomePage - dispose(): Limpiando recursos del taller HTTP');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HomePage - build(): Construyendo interfaz del Taller HTTP');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taller HTTP - Star Wars API'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con información del taller
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Consumo de API REST',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Este taller demuestra:\n'
                      '• Consumo de API pública con paquete http\n'
                      '• Manejo de estados (cargando/éxito/error)\n'
                      '• Navegación con go_router y parámetros\n'
                      '• Separación por capas (models/services/views)\n'
                      '• Scroll infinito y búsqueda en tiempo real',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botón principal para acceder al taller
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.public,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _navigateToStarWars,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Ver Personajes de Star Wars',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'API: swapi.info',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // FAB para información del estudiante
      floatingActionButton: FloatingActionButton(
        onPressed: _showProjectInfo,
        tooltip: 'Información del Proyecto',
        child: const Icon(Icons.info),
      ),
    );
  }

  /// Navega al taller de Star Wars
  void _navigateToStarWars() {
    debugPrint('HomePage - Navegando al taller HTTP de Star Wars');
    context.go('/starwars');
  }

  /// Muestra información del proyecto y estudiante
  void _showProjectInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Flexible(
              child: Text('Información del Proyecto'),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Taller HTTP - Consumo de API REST',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text('Asignatura: Electiva profesional I - Desarrollo Móvil'),
              SizedBox(height: 4),
              Text('Estudiante: Cristopher Arias Contreras'),
              SizedBox(height: 4),
              Text('Código: 230222032'),
              SizedBox(height: 12),
              Text(
                'Características implementadas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Consumo de API pública (Star Wars API)'),
              Text('Manejo de estados y errores'),
              Text('Navegación con go_router'),
              Text('Scroll infinito y paginación'),
              Text('Búsqueda en tiempo real'),
              Text('Arquitectura limpia por capas'),
              SizedBox(height: 12),
              Text(
                'Tecnologías:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Flutter 3.9+'),
              Text('• Dart 3.0+'),
              Text('• http: ^1.1.0'),
              Text('• go_router: ^14.2.7'),
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
}
