import 'package:flutter/material.dart';
import '../../data/models/character.dart';
import '../../data/models/planet.dart';
import '../../data/services/starwars_api_service.dart';

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

/// Página de detalle de un personaje de Star Wars
/// Muestra información completa incluyendo planeta natal y películas
class CharacterDetailPage extends StatefulWidget {
  final String characterId;
  final String characterName;

  const CharacterDetailPage({
    super.key,
    required this.characterId,
    required this.characterName,
  });

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  Character? _character;
  Planet? _planet;
  bool _isLoading = true;
  bool _isLoadingPlanet = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    print('[CharacterDetail] initState(): Cargando personaje ${widget.characterName}');
    _loadCharacterDetails();
  }

  @override
  void dispose() {
    print('[CharacterDetail] dispose(): Liberando recursos');
    super.dispose();
  }

  /// Carga los detalles del personaje desde la API
  Future<void> _loadCharacterDetails() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('[CharacterDetail] Obteniendo detalles del personaje ID: ${widget.characterId}');
      
      final character = await StarWarsApiService.getCharacterById(widget.characterId);
      
      if (mounted) {
        setState(() {
          _character = character;
          _isLoading = false;
        });

        print('[CharacterDetail] Personaje cargado: ${character.name}');

        // Cargar planeta de origen si está disponible
        if (character.homeworld.isNotEmpty) {
          _loadPlanetDetails(character.homeworld);
        }
      }

    } catch (e) {
      print('[CharacterDetail] Error al cargar personaje: $e');

      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });

        _showErrorSnackBar('Error al cargar detalles del personaje: $e');
      }
    }
  }

  /// Carga los detalles del planeta de origen del personaje
  Future<void> _loadPlanetDetails(String planetUrl) async {
    setState(() {
      _isLoadingPlanet = true;
    });

    try {
      print('[CharacterDetail] Obteniendo planeta: $planetUrl');

      final planet = await StarWarsApiService.getPlanetByUrl(planetUrl);

      if (mounted) {
        setState(() {
          _planet = planet;
          _isLoadingPlanet = false;
        });

        print('[CharacterDetail] Planeta cargado: ${planet.name}');
      }

    } catch (e) {
      print('[CharacterDetail] Error al cargar planeta: $e');

      if (mounted) {
        setState(() {
          _isLoadingPlanet = false;
        });

        // No mostramos error del planeta ya que es información secundaria
      }
    }
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
          onPressed: _loadCharacterDetails,
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
              Icons.person_pin,
              color: Colors.yellow[600],
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.characterName.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.white,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
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
            border: Border.all(color: Colors.cyan[400]!, width: 2),
          ),
          child: BackButton(color: Colors.cyan[400]),
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
        child: _buildBody(),
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
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.yellow[600]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[600]!),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ANALYZING SUBJECT...',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[600],
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Retrieving galactic records',
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
                'DATA CORRUPTED',
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
                'Subject records unavailable',
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
                  onPressed: _loadCharacterDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'RETRY SCAN',
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

    // Contenido del personaje
    if (_character == null) {
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
                Icons.person_off,
                size: 48,
                color: Colors.orange[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'SUBJECT NOT FOUND',
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
              'No data available in archives',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.grey[400],
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCharacterHeader(_character!),
          const SizedBox(height: 20),
          _buildPhysicalInfo(_character!),
          const SizedBox(height: 20),
          _buildPersonalInfo(_character!),
          const SizedBox(height: 20),
          _buildPlanetInfo(),
          const SizedBox(height: 20),
          _buildMoviesInfo(_character!),
        ],
      ),
    );
  }

  Widget _buildCharacterHeader(Character character) {
    final characterImage = StarWarsImages.characterImages[character.name] ?? 
                          StarWarsImages.defaultCharacterImage;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
        border: Border.all(color: Colors.yellow[600]!, width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Badge superior
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.yellow[600],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'GALACTIC SUBJECT',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Avatar principal
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.yellow[600]!, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
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
                      size: 80,
                      color: Colors.yellow[600],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[600]!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Nombre del personaje
          Text(
            character.name.toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[600],
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Badge de género
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.cyan[700],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan[400]!, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wc,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  character.formattedGender.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalInfo(Character character) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
        border: Border.all(color: Colors.cyan[400]!, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyan[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.biotech,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'PHYSICAL ATTRIBUTES',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan[400],
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Height', character.formattedHeight, Icons.height),
          _buildInfoRow('Mass', character.formattedMass, Icons.monitor_weight),
          _buildInfoRow('Hair Color', character.hairColor, Icons.face),
          _buildInfoRow('Skin Color', character.skinColor, Icons.palette),
          _buildInfoRow('Eye Color', character.eyeColor, Icons.visibility),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(Character character) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información Personal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Año de nacimiento', character.formattedBirthYear, Icons.cake),
            _buildInfoRow('Género', character.formattedGender, Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
        border: Border.all(color: Colors.orange[400]!, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.public,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'HOMEWORLD DATA',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[400],
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoadingPlanet) 
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[400]!),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Scanning planet...',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_planet != null) ...[
            _buildInfoRow('Planet', _planet!.name, Icons.public),
            _buildInfoRow('Climate', _planet!.climate, Icons.wb_sunny),
            _buildInfoRow('Terrain', _planet!.terrain, Icons.landscape),
            _buildInfoRow('Diameter', _planet!.formattedDiameter, Icons.straighten),
            _buildInfoRow('Gravity', _planet!.formattedGravity, Icons.arrow_downward),
          ] else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                border: Border.all(color: Colors.orange[400]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[400], size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'PLANET DATA UNAVAILABLE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMoviesInfo(Character character) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apariciones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Películas',
              '${character.films.length} película(s)',
              Icons.movie,
            ),
            _buildInfoRow(
              'Vehículos',
              '${character.vehicles.length} vehículo(s)',
              Icons.directions_car,
            ),
            _buildInfoRow(
              'Naves',
              '${character.starships.length} nave(s)',
              Icons.rocket_launch,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: Colors.cyan[700]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.cyan[700],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.cyan[400],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}