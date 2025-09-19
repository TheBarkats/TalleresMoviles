import 'package:flutter/material.dart';
import 'dart:async';

/// Widget personalizado que implementa un carrusel de imágenes
/// Este es el tercer widget requerido, además de GridView y TabBar
class ImageCarouselWidget extends StatefulWidget {
  final List<String> images;
  final double height;
  final bool autoPlay;
  final Duration autoPlayDuration;
  final Color? indicatorColor;

  const ImageCarouselWidget({
    super.key,
    required this.images,
    this.height = 200,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.indicatorColor,
  });

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    // LIFECYCLE: initState - Inicialización del widget del carrusel
    // Se inicializa el PageController y se configura el auto-play si está habilitado
    debugPrint('🟢 ImageCarouselWidget - initState(): Inicializando carrusel con ${widget.images.length} imágenes');
    
    _pageController = PageController(initialPage: 0);
    
    if (widget.autoPlay && widget.images.length > 1) {
      _startAutoPlay();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // LIFECYCLE: didChangeDependencies - Se ejecuta cuando cambian las dependencias
    // Útil para obtener el tema actual para los indicadores
    debugPrint('🟡 ImageCarouselWidget - didChangeDependencies(): Configurando tema del carrusel');
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (mounted) {
        setState(() {
          // LIFECYCLE: setState - Actualiza el índice actual para el auto-play
          debugPrint('🔄 ImageCarouselWidget - setState(): Auto-play cambiando a imagen ${(_currentIndex + 1) % widget.images.length}');
          
          _currentIndex = (_currentIndex + 1) % widget.images.length;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    // LIFECYCLE: build - Construye la UI del carrusel
    debugPrint('🔵 ImageCarouselWidget - build(): Construyendo carrusel en índice $_currentIndex');
    
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('No hay imágenes disponibles'),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Carrusel principal
        GestureDetector(
          onTap: () {
            // Pausar/reanudar auto-play al tocar
            if (widget.autoPlay) {
              if (_autoPlayTimer?.isActive == true) {
                _stopAutoPlay();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Auto-play pausado'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                _startAutoPlay();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Auto-play reanudado'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor.withValues(alpha: 0.7),
                          Theme.of(context).primaryColor.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Imagen ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.images[index],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Indicadores de página
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? (widget.indicatorColor ?? Theme.of(context).primaryColor)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        
        // Controles del carrusel
        if (widget.images.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _currentIndex > 0
                    ? () {
                        setState(() {
                          _currentIndex--;
                          _pageController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      }
                    : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Imagen anterior',
              ),
              
              Text(
                '${_currentIndex + 1} / ${widget.images.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              
              if (widget.autoPlay)
                IconButton(
                  onPressed: () {
                    if (_autoPlayTimer?.isActive == true) {
                      _stopAutoPlay();
                    } else {
                      _startAutoPlay();
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    _autoPlayTimer?.isActive == true
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  tooltip: _autoPlayTimer?.isActive == true
                      ? 'Pausar auto-play'
                      : 'Iniciar auto-play',
                ),
              
              IconButton(
                onPressed: _currentIndex < widget.images.length - 1
                    ? () {
                        setState(() {
                          _currentIndex++;
                          _pageController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      }
                    : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Siguiente imagen',
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    // LIFECYCLE: dispose - Limpieza de recursos cuando el widget se elimina
    // Importante: cancelar el timer y disponer del PageController
    debugPrint('🔴 ImageCarouselWidget - dispose(): Limpiando timer y PageController del carrusel');
    
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }
}