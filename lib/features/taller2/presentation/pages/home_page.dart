import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modelo simple para los productos que se mostrarán en el GridView
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final Color color;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.color,
  });
}

/// Página principal que demuestra GridView y navegación con parámetros
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de productos de ejemplo
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Smartphone Pro',
      description: 'El último smartphone con tecnología avanzada',
      imageUrl: 'https://via.placeholder.com/200x200/4CAF50/FFFFFF?text=Phone',
      price: 999.99,
      color: Colors.green,
    ),
    Product(
      id: '2',
      name: 'Laptop Gaming',
      description: 'Potente laptop para juegos y trabajo',
      imageUrl: 'https://via.placeholder.com/200x200/2196F3/FFFFFF?text=Laptop',
      price: 1299.99,
      color: Colors.blue,
    ),
    Product(
      id: '3',
      name: 'Auriculares Pro',
      description: 'Auriculares con cancelación de ruido',
      imageUrl: 'https://via.placeholder.com/200x200/FF9800/FFFFFF?text=Audio',
      price: 299.99,
      color: Colors.orange,
    ),
    Product(
      id: '4',
      name: 'Smartwatch',
      description: 'Reloj inteligente con múltiples funciones',
      imageUrl: 'https://via.placeholder.com/200x200/9C27B0/FFFFFF?text=Watch',
      price: 399.99,
      color: Colors.purple,
    ),
    Product(
      id: '5',
      name: 'Tablet Design',
      description: 'Tablet perfecta para diseño y creatividad',
      imageUrl: 'https://via.placeholder.com/200x200/F44336/FFFFFF?text=Tablet',
      price: 799.99,
      color: Colors.red,
    ),
    Product(
      id: '6',
      name: 'Cámara 4K',
      description: 'Cámara profesional con grabación 4K',
      imageUrl: 'https://via.placeholder.com/200x200/607D8B/FFFFFF?text=Camera',
      price: 1199.99,
      color: Colors.blueGrey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // LIFECYCLE: initState se ejecuta una sola vez al crear el widget
    // Ideal para inicialización que no depende del contexto
    debugPrint('🟢 HomePage - initState(): Inicializando página principal con ${products.length} productos');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // LIFECYCLE: Se ejecuta después de initState y cuando cambian las dependencias
    // Útil para operaciones que necesitan acceso al contexto
    debugPrint('🟡 HomePage - didChangeDependencies(): Configurando dependencias del contexto');
  }

  @override
  Widget build(BuildContext context) {
    // LIFECYCLE: Se ejecuta cada vez que se necesita reconstruir el widget
    // Se llama después de initState, didChangeDependencies y setState
    debugPrint('🔵 HomePage - build(): Construyendo interfaz de usuario');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taller 2 - Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            tooltip: 'Demo de Navegación',
            onPressed: () {
              context.go('/navigation-demo');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con información
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catálogo de Productos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Toca cualquier producto para ver sus detalles',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          
          // GridView con productos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                // Configuración del GridView para mostrar 2 columnas
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columnas
                  childAspectRatio: 0.85, // Relación ancho/alto de cada item (más alto)
                  crossAxisSpacing: 8.0, // Espaciado horizontal
                  mainAxisSpacing: 8.0, // Espaciado vertical
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product);
                },
              ),
            ),
          ),
        ],
      ),
      
      // Botón flotante para demostrar setState
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // LIFECYCLE: setState marca el widget como "dirty" y programa una reconstrucción
            // Se usa cuando queremos actualizar la UI después de cambiar el estado
            debugPrint('🔄 HomePage - setState(): Actualizando estado (simulado)');
            
            // Simulamos un cambio mezclando la lista de productos
            products.shuffle();
          });
        },
        tooltip: 'Mezclar productos (setState)',
        child: const Icon(Icons.shuffle),
      ),
    );
  }

  /// Construye una tarjeta para cada producto en el GridView
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navegación con parámetros usando go_router
          // Pasamos el ID como parámetro de ruta y el nombre como query parameter
          context.go('/product/${product.id}?name=${Uri.encodeComponent(product.name)}');
        },
        child: Stack(
          children: [
            // Imagen del producto (fondo)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: product.color.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  _getProductIcon(product.name),
                  size: 40,
                  color: product.color,
                ),
              ),
            ),
            
            // Información del producto (superpuesta)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  border: Border(
                    top: BorderSide(
                      color: product.color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                height: 32, // Altura fija para evitar overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 7,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: product.color,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna un icono apropiado basado en el nombre del producto
  IconData _getProductIcon(String productName) {
    if (productName.toLowerCase().contains('phone')) return Icons.smartphone;
    if (productName.toLowerCase().contains('laptop')) return Icons.laptop;
    if (productName.toLowerCase().contains('auricular')) return Icons.headphones;
    if (productName.toLowerCase().contains('watch')) return Icons.watch;
    if (productName.toLowerCase().contains('tablet')) return Icons.tablet;
    if (productName.toLowerCase().contains('camera') || productName.toLowerCase().contains('cámara')) return Icons.camera_alt;
    return Icons.devices;
  }

  @override
  void dispose() {
    // LIFECYCLE: Se ejecuta cuando el widget se elimina permanentemente
    // Ideal para limpiar recursos, cancelar suscripciones, etc.
    debugPrint('🔴 HomePage - dispose(): Limpiando recursos de la página principal');
    super.dispose();
  }
}