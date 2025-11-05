import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/planet.dart';
import '../models/api_response.dart';

/// Excepción personalizada para errores de la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? '(Status: $statusCode)' : ''}';
  }
}

/// Servicio para consumir la API de Star Wars (SWAPI)
/// Maneja todas las peticiones HTTP y la serialización de datos
class StarWarsApiService {
  static const String baseUrl = 'https://swapi.dev/api';
  static const Duration timeout = Duration(seconds: 10);

  /// Cliente HTTP reutilizable con configuración personalizada
  static final http.Client _client = http.Client();

  /// Obtiene la lista de personajes de Star Wars
  /// Soporta paginación y búsqueda por nombre
  /// 
  /// [page] Número de página a obtener (por defecto: 1)
  /// [search] Término de búsqueda opcional para filtrar personajes
  /// 
  /// Returns [ApiResponse<Character>] con la lista paginada
  /// Throws [ApiException] en caso de error
  static Future<ApiResponse<Character>> getCharacters({
    int page = 1, 
    String? search,
  }) async {
    try {
      print('[StarWarsAPI] Obteniendo personajes - Página: $page');
      
      // Construir URL con parámetros de consulta
      final uri = Uri.parse('$baseUrl/people/').replace(
        queryParameters: {
          'page': page.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      
      print('[StarWarsAPI] URL: $uri');

      // Realizar petición HTTP con timeout
      final response = await _client.get(uri).timeout(timeout);
      
      // Verificar código de estado HTTP
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        
        // La API puede devolver directamente un array o un objeto con 'results'
        // Manejar ambos casos para mayor robustez
        if (jsonData is List) {
          // Respuesta directa como array de personajes
          final characters = jsonData
              .map((item) => Character.fromJson(item as Map<String, dynamic>))
              .toList();
          
          // Crear respuesta paginada simulada
          final apiResponse = ApiResponse<Character>(
            count: characters.length,
            next: null,
            previous: null,
            results: characters,
          );
          
          print('[StarWarsAPI] Personajes obtenidos: ${apiResponse.results.length}');
          return apiResponse;
        } else {
          // Respuesta estándar con paginación
          final apiResponse = ApiResponse<Character>.fromJson(
            jsonData as Map<String, dynamic>,
            (json) => Character.fromJson(json),
          );
          
          print('[StarWarsAPI] Personajes obtenidos: ${apiResponse.results.length}');
          return apiResponse;
        }
      } else {
        final errorMsg = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        print('[StarWarsAPI] $errorMsg');
        throw ApiException(errorMsg, response.statusCode);
      }
    } on SocketException {
      const errorMsg = 'Sin conexión a internet. Verifique su conexión.';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    } on http.ClientException {
      const errorMsg = 'Error de cliente HTTP. Intente nuevamente.';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    } on FormatException {
      const errorMsg = 'Formato de respuesta inválido del servidor.';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    } catch (e) {
      final errorMsg = 'Error inesperado: $e';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    }
  }

  /// Obtiene un personaje específico por ID
  /// 
  /// [id] ID del personaje a obtener
  /// 
  /// Returns [Character] con los datos del personaje
  /// Throws [ApiException] en caso de error
  static Future<Character> getCharacterById(String id) async {
    try {
      print('[StarWarsAPI] Obteniendo personaje con ID: $id');
      
      final uri = Uri.parse('$baseUrl/people/$id/');
      print('[StarWarsAPI] URL: $uri');

      final response = await _client.get(uri).timeout(timeout);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final character = Character.fromJson(jsonData);
        
        print('[StarWarsAPI] Personaje obtenido: ${character.name}');
        return character;
      } else if (response.statusCode == 404) {
        const errorMsg = 'Personaje no encontrado';
        print('[StarWarsAPI] $errorMsg');
        throw ApiException(errorMsg, response.statusCode);
      } else {
        final errorMsg = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        print('[StarWarsAPI] $errorMsg');
        throw ApiException(errorMsg, response.statusCode);
      }
    } on SocketException {
      const errorMsg = 'Sin conexión a internet. Verifique su conexión.';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    } on http.ClientException {
      const errorMsg = 'Error de cliente HTTP. Intente nuevamente.';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    } on FormatException {
      const errorMsg = 'Formato de respuesta inválido del servidor.';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    } catch (e) {
      final errorMsg = 'Error inesperado: $e';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    }
  }

  /// Obtiene un planeta por URL completa
  /// 
  /// [planetUrl] URL completa del planeta desde la API
  /// 
  /// Returns [Planet] con los datos del planeta
  /// Throws [ApiException] en caso de error
  static Future<Planet> getPlanetByUrl(String planetUrl) async {
    try {
      print('[StarWarsAPI] Obteniendo planeta desde URL: $planetUrl');
      
      final response = await _client.get(Uri.parse(planetUrl)).timeout(timeout);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final planet = Planet.fromJson(jsonData);
        
        print('[StarWarsAPI] Planeta obtenido: ${planet.name}');
        return planet;
      } else {
        final errorMsg = 'Error al obtener planeta: ${response.statusCode}';
        print('[StarWarsAPI] $errorMsg');
        throw ApiException(errorMsg, response.statusCode);
      }
    } catch (e) {
      final errorMsg = 'Error al obtener planeta: $e';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    }
  }

  /// Obtiene la lista de planetas de Star Wars
  /// Soporta paginación
  /// 
  /// [page] Número de página a obtener (por defecto: 1)
  /// 
  /// Returns [ApiResponse<Planet>] con la lista paginada
  /// Throws [ApiException] en caso de error
  static Future<ApiResponse<Planet>> getPlanets({int page = 1}) async {
    try {
      print('[StarWarsAPI] Obteniendo planetas - Página: $page');
      
      final uri = Uri.parse('$baseUrl/planets/').replace(
        queryParameters: {'page': page.toString()},
      );

      final response = await _client.get(uri).timeout(timeout);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        final apiResponse = ApiResponse<Planet>.fromJson(
          jsonData,
          (json) => Planet.fromJson(json),
        );
        
        print('[StarWarsAPI] Planetas obtenidos: ${apiResponse.results.length}');
        return apiResponse;
      } else {
        final errorMsg = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        print('[StarWarsAPI] $errorMsg');
        throw ApiException(errorMsg, response.statusCode);
      }
    } catch (e) {
      final errorMsg = 'Error al obtener planetas: $e';
      print('[StarWarsAPI] $errorMsg');
      throw ApiException(errorMsg);
    }
  }

  /// Cierra el cliente HTTP y libera recursos
  /// Debe llamarse al finalizar la aplicación
  static void close() {
    print('[StarWarsAPI] Cliente HTTP cerrado');
    _client.close();
  }
}