import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/taller2/presentation/pages/home_page.dart';
import '../../features/taller2/presentation/pages/product_detail_page.dart';
import '../../features/taller2/presentation/pages/navigation_demo_page.dart';

/// Configuración central de rutas usando go_router
/// Maneja toda la navegación de la aplicación con tipo seguro
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta principal - HomePage con GridView
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    
    // Ruta con parámetros - Detalle de producto
    GoRoute(
      path: '/product/:id',
      name: 'product-detail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        final productName = state.uri.queryParameters['name'] ?? 'Producto sin nombre';
        return ProductDetailPage(
          productId: productId,
          productName: productName,
        );
      },
    ),
    
    // Ruta de demostración de navegación
    GoRoute(
      path: '/navigation-demo',
      name: 'navigation-demo',
      builder: (context, state) => const NavigationDemoPage(),
    ),
    
    // Ruta con parámetros desde navigation demo
    GoRoute(
      path: '/navigation-demo/result/:method',
      name: 'navigation-result',
      builder: (context, state) {
        final method = state.pathParameters['method']!;
        final message = state.uri.queryParameters['message'] ?? 'Sin mensaje';
        return NavigationResultPage(
          method: method,
          message: message,
        );
      },
    ),
  ],
  
  // Manejo de errores de navegación
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error de Navegación'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Página no encontrada',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.error.toString(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Volver al Inicio'),
          ),
        ],
      ),
    ),
  ),
);

/// Página de resultado para demostrar diferentes tipos de navegación
class NavigationResultPage extends StatefulWidget {
  final String method;
  final String message;

  const NavigationResultPage({
    super.key,
    required this.method,
    required this.message,
  });

  @override
  State<NavigationResultPage> createState() => _NavigationResultPageState();
}

class _NavigationResultPageState extends State<NavigationResultPage> {
  @override
  void initState() {
    super.initState();
    // LIFECYCLE: initState se ejecuta una sola vez cuando el widget se crea
    // Se usa para inicialización que no depende del contexto
    print('🟢 NavigationResultPage - initState(): Widget creado, método: ${widget.method}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // LIFECYCLE: Se ejecuta después de initState y cuando cambian las dependencias
    // Se usa para operaciones que dependen del contexto (Theme, MediaQuery, etc.)
    print('🟡 NavigationResultPage - didChangeDependencies(): Dependencias cargadas');
  }

  @override
  Widget build(BuildContext context) {
    // LIFECYCLE: Se ejecuta cada vez que el widget necesita reconstruirse
    // Se ejecuta después de initState, didChangeDependencies y setState
    print('🔵 NavigationResultPage - build(): Construyendo UI');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado: ${widget.method}'),
        backgroundColor: _getMethodColor(widget.method),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Método de Navegación:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.method.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _getMethodColor(widget.method),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mensaje:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildMethodExplanation(),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Simular setState para mostrar en logs
                      setState(() {
                        // LIFECYCLE: setState dispara una reconstrucción del widget
                        print('🔄 NavigationResultPage - setState(): Forzando reconstrucción');
                      });
                    },
                    child: const Text('Trigger setState'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Volver al Inicio'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodExplanation() {
    String explanation;
    IconData icon;
    
    switch (widget.method) {
      case 'go':
        explanation = 'go() reemplaza toda la pila de navegación. '
            'El botón atrás llevará a la pantalla anterior según la nueva ruta.';
        icon = Icons.refresh;
        break;
      case 'push':
        explanation = 'push() añade una nueva pantalla a la pila. '
            'El botón atrás regresa a la pantalla anterior.';
        icon = Icons.add;
        break;
      case 'replace':
        explanation = 'replace() reemplaza la pantalla actual. '
            'El botón atrás NO regresa a la pantalla que fue reemplazada.';
        icon = Icons.swap_horiz;
        break;
      default:
        explanation = 'Método de navegación desconocido.';
        icon = Icons.help;
    }
    
    return Card(
      color: _getMethodColor(widget.method).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: _getMethodColor(widget.method)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                explanation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'go':
        return Colors.blue;
      case 'push':
        return Colors.green;
      case 'replace':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    // LIFECYCLE: Se ejecuta cuando el widget se elimina permanentemente del árbol
    // Se usa para limpiar recursos, cancelar suscripciones, etc.
    print('🔴 NavigationResultPage - dispose(): Widget eliminado, liberando recursos');
    super.dispose();
  }
}