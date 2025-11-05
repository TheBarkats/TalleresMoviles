/// Modelo de Universidad para Firestore
/// Representa una institución universitaria con sus datos básicos
class Universidad {
  final String? id; // ID del documento en Firestore
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  Universidad({
    this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  /// Crea una Universidad desde un documento de Firestore
  factory Universidad.fromFirestore(Map<String, dynamic> data, String id) {
    return Universidad(
      id: id,
      nit: data['nit'] ?? '',
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      paginaWeb: data['pagina_web'] ?? '',
    );
  }

  /// Convierte la Universidad a un Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }

  /// Crea una copia de la Universidad con campos actualizados
  Universidad copyWith({
    String? id,
    String? nit,
    String? nombre,
    String? direccion,
    String? telefono,
    String? paginaWeb,
  }) {
    return Universidad(
      id: id ?? this.id,
      nit: nit ?? this.nit,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      paginaWeb: paginaWeb ?? this.paginaWeb,
    );
  }

  @override
  String toString() {
    return 'Universidad(id: $id, nit: $nit, nombre: $nombre, direccion: $direccion, telefono: $telefono, paginaWeb: $paginaWeb)';
  }
}
