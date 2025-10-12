/// Modelo que representa un planeta de Star Wars
/// Mapea la respuesta JSON de la API SWAPI para planetas
class Planet {
  final String name;
  final String rotationPeriod;
  final String orbitalPeriod;
  final String diameter;
  final String climate;
  final String gravity;
  final String terrain;
  final String surfaceWater;
  final String population;
  final List<String> residents;
  final List<String> films;
  final DateTime created;
  final DateTime edited;
  final String url;

  Planet({
    required this.name,
    required this.rotationPeriod,
    required this.orbitalPeriod,
    required this.diameter,
    required this.climate,
    required this.gravity,
    required this.terrain,
    required this.surfaceWater,
    required this.population,
    required this.residents,
    required this.films,
    required this.created,
    required this.edited,
    required this.url,
  });

  /// Factory constructor para crear un Planet desde JSON
  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'] ?? '',
      rotationPeriod: json['rotation_period'] ?? '',
      orbitalPeriod: json['orbital_period'] ?? '',
      diameter: json['diameter'] ?? '',
      climate: json['climate'] ?? '',
      gravity: json['gravity'] ?? '',
      terrain: json['terrain'] ?? '',
      surfaceWater: json['surface_water'] ?? '',
      population: json['population'] ?? '',
      residents: List<String>.from(json['residents'] ?? []),
      films: List<String>.from(json['films'] ?? []),
      created: DateTime.parse(json['created']),
      edited: DateTime.parse(json['edited']),
      url: json['url'] ?? '',
    );
  }

  /// Convierte el Planet a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rotation_period': rotationPeriod,
      'orbital_period': orbitalPeriod,
      'diameter': diameter,
      'climate': climate,
      'gravity': gravity,
      'terrain': terrain,
      'surface_water': surfaceWater,
      'population': population,
      'residents': residents,
      'films': films,
      'created': created.toIso8601String(),
      'edited': edited.toIso8601String(),
      'url': url,
    };
  }

  /// Obtiene el ID del planeta a partir de la URL
  String get id {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.length >= 2) {
      return pathSegments[pathSegments.length - 2];
    }
    return '1';
  }

  /// Genera una URL de imagen para el planeta
  String get imageUrl {
    return 'https://starwars-visualguide.com/assets/img/planets/$id.jpg';
  }

  /// Propiedades formateadas para mostrar
  String get formattedPopulation {
    if (population == 'unknown') return 'Desconocido';
    if (population == '0') return 'Deshabitado';
    
    // Formatear número con separadores de miles
    final number = int.tryParse(population);
    if (number != null) {
      return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
    }
    return population;
  }

  String get formattedDiameter {
    if (diameter == 'unknown') return 'Desconocido';
    return '$diameter km';
  }

  String get formattedGravity {
    if (gravity == 'unknown') return 'Desconocido';
    return gravity;
  }

  @override
  String toString() {
    return 'Planet(name: $name, population: $population, climate: $climate)';
  }
}
