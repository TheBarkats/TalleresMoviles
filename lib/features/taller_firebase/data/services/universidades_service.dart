import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';

/// Servicio para gestionar operaciones CRUD de Universidades en Firestore
class UniversidadesService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Nombre de la colección
  static const String _collectionName = 'universidades';

  /// Obtiene la colección de universidades
  CollectionReference get _universidadesCollection =>
      _firestore.collection(_collectionName);

  // ==================== CREATE ====================
  
  /// Crea una nueva universidad en Firestore
  /// 
  /// [universidad] - Datos de la universidad a crear
  /// Returns el ID del documento creado
  /// Throws [FirebaseException] en caso de error
  Future<String> crearUniversidad(Universidad universidad) async {
    try {
      print('[Firestore] Creando universidad: ${universidad.nombre}');
      
      final docRef = await _universidadesCollection.add(universidad.toFirestore());
      
      print('[Firestore] Universidad creada con ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('[Firestore] Error al crear universidad: $e');
      rethrow;
    }
  }

  // ==================== READ ====================
  
  /// Obtiene un Stream de todas las universidades en tiempo real
  /// 
  /// Returns un Stream de lista de universidades ordenadas por nombre
  Stream<List<Universidad>> obtenerUniversidades() {
    try {
      print('[Firestore] Iniciando stream de universidades');
      
      return _universidadesCollection
          .orderBy('nombre')
          .snapshots()
          .map((snapshot) {
        print('[Firestore] Universidades recibidas: ${snapshot.docs.length}');
        
        return snapshot.docs.map((doc) {
          return Universidad.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
      });
    } catch (e) {
      print('[Firestore] Error al obtener stream: $e');
      rethrow;
    }
  }

  /// Obtiene una universidad específica por ID
  /// 
  /// [id] - ID del documento en Firestore
  /// Returns la universidad encontrada o null si no existe
  Future<Universidad?> obtenerUniversidadPorId(String id) async {
    try {
      print('[Firestore] Obteniendo universidad con ID: $id');
      
      final doc = await _universidadesCollection.doc(id).get();
      
      if (doc.exists) {
        print('[Firestore] Universidad encontrada');
        return Universidad.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      } else {
        print('[Firestore] Universidad no encontrada');
        return null;
      }
    } catch (e) {
      print('[Firestore] Error al obtener universidad: $e');
      rethrow;
    }
  }

  /// Busca universidades por nombre (búsqueda parcial)
  /// 
  /// [query] - Texto a buscar en el nombre
  /// Returns Stream de universidades que coinciden con la búsqueda
  Stream<List<Universidad>> buscarUniversidades(String query) {
    try {
      print('[Firestore] Buscando universidades con query: $query');
      
      return _universidadesCollection
          .orderBy('nombre')
          .snapshots()
          .map((snapshot) {
        final universidades = snapshot.docs.map((doc) {
          return Universidad.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();

        // Filtrar localmente porque Firestore no soporta LIKE nativo
        if (query.isEmpty) return universidades;
        
        return universidades.where((uni) {
          return uni.nombre.toLowerCase().contains(query.toLowerCase()) ||
                 uni.nit.contains(query);
        }).toList();
      });
    } catch (e) {
      print('[Firestore] Error al buscar universidades: $e');
      rethrow;
    }
  }

  // ==================== UPDATE ====================
  
  /// Actualiza una universidad existente
  /// 
  /// [universidad] - Universidad con los datos actualizados (debe incluir id)
  /// Throws [ArgumentError] si el id es null
  /// Throws [FirebaseException] en caso de error
  Future<void> actualizarUniversidad(Universidad universidad) async {
    try {
      if (universidad.id == null) {
        throw ArgumentError('El ID de la universidad no puede ser null');
      }

      print('[Firestore] Actualizando universidad: ${universidad.id}');
      
      await _universidadesCollection
          .doc(universidad.id)
          .update(universidad.toFirestore());
      
      print('[Firestore] Universidad actualizada correctamente');
    } catch (e) {
      print('[Firestore] Error al actualizar universidad: $e');
      rethrow;
    }
  }

  // ==================== DELETE ====================
  
  /// Elimina una universidad por ID
  /// 
  /// [id] - ID del documento a eliminar
  /// Throws [FirebaseException] en caso de error
  Future<void> eliminarUniversidad(String id) async {
    try {
      print('[Firestore] Eliminando universidad: $id');
      
      await _universidadesCollection.doc(id).delete();
      
      print('[Firestore] Universidad eliminada correctamente');
    } catch (e) {
      print('[Firestore] Error al eliminar universidad: $e');
      rethrow;
    }
  }

  // ==================== UTILIDADES ====================
  
  /// Verifica si existe una universidad con el NIT especificado
  /// 
  /// [nit] - NIT a verificar
  /// [excludeId] - ID a excluir de la búsqueda (para edición)
  /// Returns true si existe, false si no
  Future<bool> existeNit(String nit, {String? excludeId}) async {
    try {
      print('[Firestore] Verificando si existe NIT: $nit');
      
      final query = await _universidadesCollection
          .where('nit', isEqualTo: nit)
          .get();
      
      if (excludeId != null) {
        // Excluir el documento actual al editar
        final docs = query.docs.where((doc) => doc.id != excludeId).toList();
        return docs.isNotEmpty;
      }
      
      return query.docs.isNotEmpty;
    } catch (e) {
      print('[Firestore] Error al verificar NIT: $e');
      rethrow;
    }
  }

  /// Obtiene el conteo total de universidades
  /// 
  /// Returns el número total de universidades en la colección
  Future<int> contarUniversidades() async {
    try {
      print('[Firestore] Contando universidades');
      
      final snapshot = await _universidadesCollection.get();
      
      print('[Firestore] Total de universidades: ${snapshot.docs.length}');
      return snapshot.docs.length;
    } catch (e) {
      print('[Firestore] Error al contar universidades: $e');
      rethrow;
    }
  }

  /// Elimina todas las universidades (usar con precaución)
  /// Solo para propósitos de testing
  Future<void> eliminarTodasLasUniversidades() async {
    try {
      print('[Firestore] Eliminando todas las universidades');
      
      final snapshot = await _universidadesCollection.get();
      
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      
      print('[Firestore] Todas las universidades eliminadas');
    } catch (e) {
      print('[Firestore] Error al eliminar todas las universidades: $e');
      rethrow;
    }
  }
}
