import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/image_carousel_widget.dart';

/// Página de detalle de producto que demuestra TabBar y recepción de parámetros
class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> productData;

  @override
  void initState() {
    super.initState();
    // LIFECYCLE: initState se ejecuta una sola vez al crear el widget
    // Inicializamos el TabController y cargamos datos del producto
    debugPrint('🟢 ProductDetailPage - initState(): Inicializando detalle del producto ID: ${widget.productId}');
    
    _tabController = TabController(length: 3, vsync: this);
    _loadProductData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // LIFECYCLE: Se ejecuta después de initState y cuando cambian las dependencias
    // Útil para operaciones que dependen del contexto como Theme, MediaQuery
    debugPrint('🟡 ProductDetailPage - didChangeDependencies(): Configurando dependencias del contexto');
  }

  void _loadProductData() {
    // Simulamos carga de datos basada en el ID recibido como parámetro
    productData = _getProductDataById(widget.productId);
  }

  Map<String, dynamic> _getProductDataById(String id) {
    // Datos simulados de productos basados en el ID
    final Map<String, Map<String, dynamic>> productsDatabase = {
      '1': {
        'name': 'Smartphone Pro',
        'price': 999.99,
        'description': 'El último smartphone con tecnología avanzada y características premium.',
        'color': Colors.green,
        'images': [
          'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Phone+1',
          'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Phone+2',
          'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Phone+3',
        ],
        'specs': {
          'Pantalla': '6.7" OLED',
          'Procesador': 'A17 Pro',
          'RAM': '8GB',
          'Almacenamiento': '256GB',
          'Cámara': '48MP + 12MP',
          'Batería': '4000mAh',
        },
        'features': [
          'Resistente al agua IP68',
          'Carga inalámbrica',
          'Face ID',
          'Grabación 4K',
          '5G Ready',
        ],
      },
      '2': {
        'name': 'Laptop Gaming',
        'price': 1299.99,
        'description': 'Potente laptop diseñada para juegos y trabajo profesional.',
        'color': Colors.blue,
        'images': [
          'https://via.placeholder.com/300x300/2196F3/FFFFFF?text=Laptop+1',
          'https://via.placeholder.com/300x300/2196F3/FFFFFF?text=Laptop+2',
          'https://via.placeholder.com/300x300/2196F3/FFFFFF?text=Laptop+3',
        ],
        'specs': {
          'Pantalla': '15.6" 144Hz',
          'Procesador': 'Intel i7',
          'RAM': '16GB DDR4',
          'Almacenamiento': '1TB SSD',
          'GPU': 'RTX 4060',
          'Peso': '2.3kg',
        },
        'features': [
          'Teclado RGB',
          'Sistema de refrigeración avanzado',
          'Audio premium',
          'Conectividad completa',
          'Batería de larga duración',
        ],
      },
      // Agregar más productos según necesites...
    };

    return productsDatabase[id] ?? {
      'name': widget.productName,
      'price': 0.0,
      'description': 'Producto no encontrado en la base de datos.',
      'color': Colors.grey,
      'images': [
        'https://via.placeholder.com/300x300/9E9E9E/FFFFFF?text=No+Image',
      ],
      'specs': {'Error': 'Datos no disponibles'},
      'features': ['Información no disponible'],
    };
  }

  @override
  Widget build(BuildContext context) {
    // LIFECYCLE: Se ejecuta cada vez que se necesita reconstruir el widget
    debugPrint('🔵 ProductDetailPage - build(): Construyendo UI del producto ${widget.productName}');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(productData['name']),
        backgroundColor: productData['color'].withValues(alpha: 0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              setState(() {
                // LIFECYCLE: setState fuerza una reconstrucción del widget
                debugPrint('🔄 ProductDetailPage - setState(): Compartiendo producto');
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Compartiendo ${productData['name']}'),
                  backgroundColor: productData['color'],
                ),
              );
            },
          ),
        ],
      ),
      
      body: SafeArea(
        child: Column(
          children: [
            // Información básica del producto - Más compacta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: productData['color'].withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: productData['color'].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'ID: ${widget.productId} | ${widget.productName}',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${productData['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: productData['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // TabBar para diferentes secciones
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: productData['color'],
                unselectedLabelColor: Colors.grey,
                indicatorColor: productData['color'],
                tabs: const [
                  Tab(icon: Icon(Icons.info, size: 20), text: 'Detalles'),
                  Tab(icon: Icon(Icons.build, size: 20), text: 'Specs'),
                  Tab(icon: Icon(Icons.photo, size: 20), text: 'Galería'),
                ],
              ),
            ),
            
            // Contenido de las tabs
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(),
                  _buildSpecsTab(),
                  _buildGalleryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Botones de acción - Más compactos
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Catálogo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${productData['name']} agregado'),
                        backgroundColor: productData['color'],
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: productData['color'],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            productData['description'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Características principales',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          
          ...productData['features'].map<Widget>((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: productData['color'],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildSpecsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Especificaciones técnicas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          ...productData['specs'].entries.map<Widget>((entry) => Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(entry.value),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Galería de imágenes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          
          // Widget personalizado: Carrusel de imágenes
          ImageCarouselWidget(
            images: productData['images'],
            height: 200, // Reducir altura para evitar overflow
            autoPlay: true,
          ),
          
          const SizedBox(height: 16),
          
          // Grid de imágenes adicionales - Más compacto
          Text(
            'Vista rápida',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120, // Altura fija para evitar overflow
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
              ),
              itemCount: productData['images'].length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: productData['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: productData['color'].withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: productData['color'],
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: productData['color'],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // LIFECYCLE: Se ejecuta cuando el widget se elimina permanentemente
    // Importante: limpiar el TabController para evitar memory leaks
    debugPrint('🔴 ProductDetailPage - dispose(): Limpiando TabController y recursos');
    _tabController.dispose();
    super.dispose();
  }
}