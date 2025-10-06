import 'dart:async';
import 'dart:math';

/// Servicio que simula operaciones asíncronas con Future y async/await
class AsyncService {
  
  /// Simula una consulta de datos con delay
  /// Demuestra el uso de Future.delayed y async/await
  static Future<List<String>> fetchData({int delaySeconds = 3}) async {
    print('🔵 [AsyncService] Iniciando consulta de datos...');
    print('🔵 [AsyncService] Timestamp inicio: ${DateTime.now()}');
    
    try {
      // Simulamos una operación asíncrona (consulta API, base de datos, etc.)
      await Future.delayed(Duration(seconds: delaySeconds));
      
      // Simulamos posibilidad de error (20% chance)
      if (Random().nextInt(10) < 2) {
        throw Exception('Error simulado de red');
      }
      
      final data = [
        'Usuario: Juan Pérez',
        'Email: juan@example.com',
        'Última conexión: ${DateTime.now()}',
        'Productos favoritos: 5',
        'Notificaciones: 3 nuevas',
      ];
      
      print('🟢 [AsyncService] Datos obtenidos exitosamente');
      print('🟢 [AsyncService] Timestamp fin: ${DateTime.now()}');
      
      return data;
      
    } catch (e) {
      print('🔴 [AsyncService] Error: $e');
      print('🔴 [AsyncService] Timestamp error: ${DateTime.now()}');
      rethrow;
    }
  }
  
  /// Simula múltiples operaciones asíncronas paralelas
  static Future<Map<String, dynamic>> fetchMultipleData() async {
    print('🔵 [AsyncService] Iniciando múltiples consultas paralelas...');
    
    try {
      // Ejecutamos múltiples Future en paralelo usando Future.wait
      final results = await Future.wait([
        _fetchUserProfile(),
        _fetchUserStats(),
        _fetchNotifications(),
      ]);
      
      return {
        'profile': results[0],
        'stats': results[1],
        'notifications': results[2],
        'timestamp': DateTime.now().toIso8601String(),
      };
      
    } catch (e) {
      print('🔴 [AsyncService] Error en consultas múltiples: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, String>> _fetchUserProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'name': 'Ana García',
      'avatar': '👩‍💻',
      'role': 'Desarrolladora Flutter',
    };
  }
  
  static Future<Map<String, int>> _fetchUserStats() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return {
      'projects': 12,
      'commits': 89,
      'followers': 156,
    };
  }
  
  static Future<List<String>> _fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    return [
      'Nueva actualización disponible',
      'Proyecto aprobado ✅',
      'Recordatorio: Reunión a las 3 PM',
    ];
  }
}