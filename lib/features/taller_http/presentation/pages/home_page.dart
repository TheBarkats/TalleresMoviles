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
        title: const Text('Talleres Electiva Profesional I'),
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
                            'Talleres Electiva Profesional I',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Esta demo contiene distintos talleres entre ellos:\n'
                      '• API de Star Wars:\n'
                      '• Integracion con Firebase y Google cloud_firestore\n',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botones principales para acceder a los talleres
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Taller 1: Star Wars API
                      _TallerCard(
                        icon: Icons.public,
                        color: Colors.green,
                        title: 'Taller HTTP',
                        subtitle: 'Star Wars API',
                        description: 'API: swapi.info',
                        onTap: _navigateToStarWars,
                      ),
                      const SizedBox(height: 20),
                      
                      // Taller 2: Firebase Firestore
                      _TallerCard(
                        icon: Icons.cloud,
                        color: Colors.orange,
                        title: 'Taller Firebase',
                        subtitle: 'Universidades CRUD',
                        description: 'Firestore Database',
                        onTap: _navigateToUniversidades,
                      ),
                    ],
                  ),
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

  /// Navega al taller de Firebase - Universidades
  void _navigateToUniversidades() {
    debugPrint('HomePage - Navegando al taller Firebase de Universidades');
    context.go('/universidades');
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
                'Talleres de Desarrollo Móvil',
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
                'Taller 1 - HTTP:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Consumo de API REST (Star Wars)'),
              Text('• Scroll infinito y búsqueda'),
              Text('• Manejo de estados y errores'),
              SizedBox(height: 8),
              Text(
                'Taller 2 - Firebase:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• CRUD con Firestore'),
              Text('• Sincronización en tiempo real'),
              Text('• Validación de datos'),
              SizedBox(height: 12),
              Text(
                'Tecnologías:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Flutter 3.9+ / Dart 3.0+'),
              Text('• http: ^1.1.0'),
              Text('• firebase_core: ^3.6.0'),
              Text('• cloud_firestore: ^5.4.4'),
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

/// Widget reutilizable para representar cada taller disponible
class _TallerCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onTap;

  const _TallerCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
