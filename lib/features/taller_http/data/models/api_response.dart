/// Modelo que representa la respuesta paginada de la API SWAPI
/// Encapsula el resultado de las consultas con paginación
class ApiResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  ApiResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Factory constructor para crear ApiResponse desde JSON
  /// Utiliza un parser personalizado para convertir cada elemento
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convierte el ApiResponse a JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map(toJsonT).toList(),
    };
  }

  /// Verifica si hay más páginas disponibles
  bool get hasNextPage => next != null;

  /// Verifica si hay páginas anteriores disponibles
  bool get hasPreviousPage => previous != null;

  /// Obtiene el número de página actual de la URL next
  int? get currentPage {
    if (next != null) {
      final uri = Uri.parse(next!);
      final pageParam = uri.queryParameters['page'];
      if (pageParam != null) {
        return int.tryParse(pageParam);
      }
    }
    return 1;
  }

  @override
  String toString() {
    return 'ApiResponse(count: $count, results: ${results.length} items)';
  }
}
