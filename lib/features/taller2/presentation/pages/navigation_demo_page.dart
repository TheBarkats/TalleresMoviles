import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Página que demuestra las diferencias entre go, push y replace
class NavigationDemoPage extends StatefulWidget {
  const NavigationDemoPage({super.key});

  @override
  State<NavigationDemoPage> createState() => _NavigationDemoPageState();
}

class _NavigationDemoPageState extends State<NavigationDemoPage> {
  int _navigationCount = 0;

  @override
  void initState() {
    super.initState();
    // LIFECYCLE: initState - Inicialización del contador de navegación
    print('🟢 NavigationDemoPage - initState(): Inicializando demo de navegación');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // LIFECYCLE: didChangeDependencies - Se ejecuta cuando cambian las dependencias
    print('🟡 NavigationDemoPage - didChangeDependencies(): Configurando dependencias de navegación');
  }

  @override
  Widget build(BuildContext context) {
    // LIFECYCLE: build - Construye la UI de la demo de navegación
    print('🔵 NavigationDemoPage - build(): Construyendo demo de navegación (count: $_navigationCount)');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo de Navegación'),
        backgroundColor: Colors.indigo.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header explicativo
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Tipos de Navegación',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Esta demo muestra las diferencias entre los métodos de navegación de go_router. '
                      'Observa el comportamiento del botón "atrás" en cada caso.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contador de navegaciones
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.navigation, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Navegaciones realizadas: $_navigationCount',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // LIFECYCLE: setState - Reinicia el contador
                          print('🔄 NavigationDemoPage - setState(): Reiniciando contador de navegación');
                          _navigationCount = 0;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botones de demostración
            _buildNavigationButton(
              context: context,
              method: 'go',
              title: 'context.go()',
              description: 'Reemplaza toda la pila de navegación.\nEl botón atrás llevará al estado anterior según la nueva ruta.',
              color: Colors.blue,
              icon: Icons.refresh,
              onPressed: () {
                _incrementCounter();
                context.go('/navigation-demo/result/go?message=${Uri.encodeComponent('Navegación con GO - Reemplaza toda la pila')}');
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildNavigationButton(
              context: context,
              method: 'push',
              title: 'context.push()',
              description: 'Añade una nueva pantalla a la pila.\nEl botón atrás regresa a la pantalla anterior normalmente.',
              color: Colors.green,
              icon: Icons.add,
              onPressed: () {
                _incrementCounter();
                context.push('/navigation-demo/result/push?message=${Uri.encodeComponent('Navegación con PUSH - Añade a la pila')}');
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildNavigationButton(
              context: context,
              method: 'replace',
              title: 'context.replace()',
              description: 'Reemplaza la pantalla actual en la pila.\nEl botón atrás NO regresa a esta pantalla.',
              color: Colors.orange,
              icon: Icons.swap_horiz,
              onPressed: () {
                _incrementCounter();
                context.replace('/navigation-demo/result/replace?message=${Uri.encodeComponent('Navegación con REPLACE - Reemplaza la pantalla actual')}');
              },
            ),
            
            const SizedBox(height: 32),
            
            // Explicación técnica
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explicación Técnica',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildTechnicalExplanation(
                      'go()',
                      'Ideal para cambios de flujo completos. Útil en autenticación, onboarding, o cambios de sección principal.',
                      Icons.refresh,
                      Colors.blue,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildTechnicalExplanation(
                      'push()',
                      'Perfecto para detalles, formularios, o cualquier pantalla donde el usuario debe poder regresar fácilmente.',
                      Icons.add,
                      Colors.green,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildTechnicalExplanation(
                      'replace()',
                      'Útil para flujos paso a paso donde no queremos que el usuario regrese al paso anterior.',
                      Icons.swap_horiz,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botón para volver al inicio
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: const Text('Volver al Catálogo Principal'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required String method,
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalExplanation(
    String method,
    String explanation,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  text: '$method: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                TextSpan(text: explanation),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _incrementCounter() {
    setState(() {
      // LIFECYCLE: setState - Incrementa el contador de navegaciones
      print('🔄 NavigationDemoPage - setState(): Incrementando contador a ${_navigationCount + 1}');
      _navigationCount++;
    });
  }

  @override
  void dispose() {
    // LIFECYCLE: dispose - Limpieza cuando se elimina el widget
    print('🔴 NavigationDemoPage - dispose(): Limpiando recursos de demo de navegación');
    super.dispose();
  }
}