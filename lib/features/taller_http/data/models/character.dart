/// Modelo que representa un personaje de Star Wars
/// Mapea la respuesta JSON de la API SWAPI para personajes
class Character {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String homeworld;
  final List<String> films;
  final List<String> species;
  final List<String> vehicles;
  final List<String> starships;
  final DateTime created;
  final DateTime edited;
  final String url;

  Character({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.homeworld,
    required this.films,
    required this.species,
    required this.vehicles,
    required this.starships,
    required this.created,
    required this.edited,
    required this.url,
  });

  /// Factory constructor para crear un Character desde JSON
  /// Convierte la respuesta de la API en un objeto Character
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      height: json['height'] ?? '',
      mass: json['mass'] ?? '',
      hairColor: json['hair_color'] ?? '',
      skinColor: json['skin_color'] ?? '',
      eyeColor: json['eye_color'] ?? '',
      birthYear: json['birth_year'] ?? '',
      gender: json['gender'] ?? '',
      homeworld: json['homeworld'] ?? '',
      films: List<String>.from(json['films'] ?? []),
      species: List<String>.from(json['species'] ?? []),
      vehicles: List<String>.from(json['vehicles'] ?? []),
      starships: List<String>.from(json['starships'] ?? []),
      created: DateTime.parse(json['created']),
      edited: DateTime.parse(json['edited']),
      url: json['url'] ?? '',
    );
  }

  /// Convierte el Character a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'height': height,
      'mass': mass,
      'hair_color': hairColor,
      'skin_color': skinColor,
      'eye_color': eyeColor,
      'birth_year': birthYear,
      'gender': gender,
      'homeworld': homeworld,
      'films': films,
      'species': species,
      'vehicles': vehicles,
      'starships': starships,
      'created': created.toIso8601String(),
      'edited': edited.toIso8601String(),
      'url': url,
    };
  }

  /// Obtiene el ID del personaje a partir de la URL
  /// Útil para navegación y identificación única
  String get id {
    print('[Character] URL: $url');
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
    print('[Character] PathSegments: $pathSegments');
    if (pathSegments.isNotEmpty) {
      final extractedId = pathSegments.last;
      print('[Character] Extracted ID: $extractedId');
      return extractedId;
    }
    print('[Character] Using default ID: 1');
    return '1';
  }

  /// Genera una URL de imagen para el personaje
  /// Utiliza un servicio externo que proporciona imágenes
  String get imageUrl {
    return 'https://starwars-visualguide.com/assets/img/characters/$id.jpg';
  }

  /// Propiedades calculadas para mostrar información formateada
  String get formattedHeight {
    if (height == 'unknown') return 'Desconocido';
    return '$height cm';
  }

  String get formattedMass {
    if (mass == 'unknown') return 'Desconocido';
    return '$mass kg';
  }

  String get formattedBirthYear {
    if (birthYear == 'unknown') return 'Desconocido';
    return birthYear;
  }

  String get formattedGender {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Masculino';
      case 'female':
        return 'Femenino';
      case 'n/a':
        return 'No aplica';
      default:
        return 'Desconocido';
    }
  }

  @override
  String toString() {
    return 'Character(name: $name, height: $height, gender: $gender)';
  }
}
