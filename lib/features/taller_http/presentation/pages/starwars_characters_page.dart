import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/character.dart';
import '../../data/models/api_response.dart';
import '../../data/services/starwars_api_service.dart';

/// Página principal del taller HTTP que muestra la lista de personajes de Star Wars
/// Demuestra el consumo de API REST, manejo de estados y navegación
class StarWarsCharactersPage extends StatefulWidget {
  const StarWarsCharactersPage({super.key});

  @override
  State<StarWarsCharactersPage> createState() => _StarWarsCharactersPageState();
}

/// Mapa de imágenes para los personajes principales de Star Wars
class StarWarsImages {
  static const Map<String, String> characterImages = {
    'Luke Skywalker': 'https://upload.wikimedia.org/wikipedia/en/9/9b/Luke_Skywalker.png',
    'C-3PO': 'https://static.wikia.nocookie.net/starwars/images/3/3f/C-3PO_TLJ_Card_Trader_Award_Card.png',
    'R2-D2': 'https://static.wikia.nocookie.net/starwars/images/e/eb/ArtooTFA2-Fathead.png',
    'Darth Vader': 'https://static.wikia.nocookie.net/starwars/images/0/02/Vader-rotjpromo.jpg',
    'Leia Organa': 'https://static.wikia.nocookie.net/starwars/images/f/fc/Leia_Organa_TLJ.png',
    'Owen Lars': 'https://static.wikia.nocookie.net/starwars/images/e/eb/OwenCardTrader.png',
    'Beru Whitesun lars': 'https://static.wikia.nocookie.net/starwars/images/c/cc/BeruCardTrader.png',
    'R5-D4': 'https://static.wikia.nocookie.net/starwars/images/c/cb/R5-D4_Sideshow.png',
    'Biggs Darklighter': 'https://static.wikia.nocookie.net/starwars/images/0/00/BiggsHS-ANH.png',
    'Obi-Wan Kenobi': 'https://static.wikia.nocookie.net/starwars/images/4/4e/ObiWanHS-SWE.jpg',
    'Anakin Skywalker': 'https://static.wikia.nocookie.net/starwars/images/6/6f/Anakin_Skywalker_RotS.png',
    'Wilhuff Tarkin': 'https://static.wikia.nocookie.net/starwars/images/c/c1/Tarkininfobox.jpg',
    'Chewbacca': 'https://static.wikia.nocookie.net/starwars/images/4/48/Chewbacca_TLJ.png',
    'Han Solo': 'https://static.wikia.nocookie.net/starwars/images/e/e2/TFAHanSolo.png',
    'Greedo': 'https://static.wikia.nocookie.net/starwars/images/c/c6/Greedo.jpg',
    'Jabba Desilijic Tiure': 'https://static.wikia.nocookie.net/starwars/images/7/7f/Jabba_SWSB.png',
    'Wedge Antilles': 'https://static.wikia.nocookie.net/starwars/images/6/60/WedgeHelmetless-ROTJHD.jpg',
    'Jek Tono Porkins': 'https://static.wikia.nocookie.net/starwars/images/e/eb/JekPorkins-DB.png',
    'Yoda': 'https://static.wikia.nocookie.net/starwars/images/d/d6/Yoda_SWSB.png',
    'Palpatine': 'https://static.wikia.nocookie.net/starwars/images/d/d8/Emperor_Sidious.png',
  };
  
  static const String defaultCharacterImage = 'https://static.wikia.nocookie.net/starwars/images/c/cc/RebelAlliance-logo.png';
}

class _StarWarsCharactersPageState extends State<StarWarsCharactersPage> {
  // Estados de la página
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  List<Character> _characters = [];
  int _currentPage = 1;
  bool _hasMoreData = true;
  String _searchQuery = '';
  
  // Controladores
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Timer para debounce en búsqueda
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    print('[CharactersPage] initState(): Inicializando página de personajes');
    
    // Cargar datos iniciales en initState, NO en build()
    _loadCharacters();
    
    // Configurar scroll infinito
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Maneja el scroll infinito para cargar más personajes
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoadingMore && _hasMoreData && _error == null) {
        _loadMoreCharacters();
      }
    }
  }

  /// Carga la primera página de personajes
  Future<void> _loadCharacters({String? search}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = 1;
      _characters.clear();
    });

    try {
      print('[CharactersPage] Cargando personajes...');
      
      final ApiResponse<Character> response = await StarWarsApiService.getCharacters(
        page: _currentPage,
        search: search,
      );

      if (mounted) {
        setState(() {
          _characters = response.results;
          _hasMoreData = response.hasNextPage;
          _isLoading = false;
        });
        
        print('[CharactersPage] Personajes cargados: ${_characters.length}');
      }

    } catch (e) {
      print('[CharactersPage] Error al cargar personajes: $e');
      
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        
        // Mostrar error al usuario
        _showErrorSnackBar('Error al cargar personajes: $e');
      }
    }
  }

  /// Carga más personajes para scroll infinito
  Future<void> _loadMoreCharacters() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      print('[CharactersPage] Cargando página $nextPage...');
      
      final ApiResponse<Character> response = await StarWarsApiService.getCharacters(
        page: nextPage,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (mounted) {
        setState(() {
          _characters.addAll(response.results);
          _currentPage = nextPage;
          _hasMoreData = response.hasNextPage;
          _isLoadingMore = false;
        });
        
        print('[CharactersPage] Más personajes cargados. Total: ${_characters.length}');
      }

    } catch (e) {
      print('[CharactersPage] Error al cargar más personajes: $e');
      
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        
        _showErrorSnackBar('Error al cargar más personajes: $e');
      }
    }
  }

  /// Maneja la búsqueda de personajes
  Future<void> _onSearch() async {
    final search = _searchController.text.trim();
    _searchQuery = search;
    print('[CharactersPage] Buscando: "$search"');
    
    await _loadCharacters(search: search.isEmpty ? null : search);
  }

  /// Maneja la búsqueda en tiempo real con debounce
  void _onSearchChanged(String value) {
    // Cancelar timer anterior si existe
    _debounceTimer?.cancel();
    
    // Crear nuevo timer con debounce de 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.trim() != _searchQuery) {
        _onSearch();
      }
    });
  }

  /// Limpia la búsqueda y recarga todos los personajes
  Future<void> _clearSearch() async {
    _searchController.clear();
    _searchQuery = '';
    await _loadCharacters();
  }

  /// Muestra un SnackBar con mensaje de error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () => _loadCharacters(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Fondo negro espacial
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Colors.yellow[600],
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'STAR WARS GALAXY',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.yellow[600]!, width: 2),
          ),
          child: BackButton(color: Colors.yellow[600]),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildStarWarsHeader(),
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildStarWarsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow,
            blurRadius: 10,
            spreadRadius: -5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellow[600]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.public,
                  color: Colors.yellow[600],
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GALACTIC DATABASE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[600],
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    'Imperial Archives',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow[800]!, width: 1),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.3),
            ),
            child: const Text(
              'Accessing SWAPI Database • Live Data Stream Active',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.greenAccent,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: Colors.cyan, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText: 'Search the galaxy...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'monospace',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.cyan[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.cyan[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.cyan[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.cyan[400]!, width: 2),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.red[400]),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onSubmitted: (_) => _onSearch(),
              onChanged: (value) {
                setState(() {});
                _onSearchChanged(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan[700]!, Colors.cyan[400]!],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _onSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'SCAN',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // Estado de carga inicial
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.cyan[400]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[400]!),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'SCANNING GALAXY...',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[400],
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Accessing Imperial Database',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey[400],
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    // Estado de error
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red[400]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.warning_amber_outlined,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'CONNECTION LOST',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Imperial Database Unavailable',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.grey[400],
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(color: Colors.red[400]!, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[700]!, Colors.red[400]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () => _loadCharacters(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'RETRY CONNECTION',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Lista vacía
    if (_characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange[400]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.search_off,
                size: 48,
                color: Colors.orange[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'NO RESULTS FOUND',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[400],
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The galaxy search returned empty',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.grey[400],
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                border: Border.all(color: Colors.orange[400]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Try a different search term',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Lista de personajes
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: _characters.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Indicador de carga al final
        if (index == _characters.length) {
          return Container(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[400]!),
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loading more beings...',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.grey[400],
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final character = _characters[index];
        return _buildCharacterCard(character);
      },
    );
  }

  Widget _buildCharacterCard(Character character) {
    final characterImage = StarWarsImages.characterImages[character.name] ?? 
                          StarWarsImages.defaultCharacterImage;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
        border: Border.all(
          color: Colors.cyan.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            print('[CharactersPage] Navegando a detalle del personaje: ${character.name}');
            
            // Navegación con go_router pasando parámetros
            context.push(
              '/starwars/character/${character.id}?name=${Uri.encodeComponent(character.name)}',
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar del personaje
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.yellow[600]!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      characterImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Icon(
                            Icons.person,
                            color: Colors.yellow[600],
                            size: 40,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[400]!),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información del personaje
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.yellow[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.wc,
                            color: Colors.cyan[400],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            character.formattedGender,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.cake,
                            color: Colors.cyan[400],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            character.formattedBirthYear,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Indicador de navegación
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.cyan[400]!, width: 1),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.cyan[400],
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

