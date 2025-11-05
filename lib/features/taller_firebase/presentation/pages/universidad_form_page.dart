import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/universidad.dart';
import '../../data/services/universidades_service.dart';

/// Formulario para crear o editar una universidad
class UniversidadFormPage extends StatefulWidget {
  final String? universidadId;

  const UniversidadFormPage({
    super.key,
    this.universidadId,
  });

  @override
  State<UniversidadFormPage> createState() => _UniversidadFormPageState();
}

class _UniversidadFormPageState extends State<UniversidadFormPage> {
  final _formKey = GlobalKey<FormState>();
  final UniversidadesService _service = UniversidadesService();

  // Controladores
  final _nitController = TextEditingController();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _paginaWebController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;
  Universidad? _universidadOriginal;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    if (widget.universidadId != null) {
      setState(() {
        _isLoading = true;
        _isEditing = true;
      });

      try {
        final universidad = await _service.obtenerUniversidadPorId(widget.universidadId!);
        
        if (universidad != null && mounted) {
          setState(() {
            _universidadOriginal = universidad;
            _nitController.text = universidad.nit;
            _nombreController.text = universidad.nombre;
            _direccionController.text = universidad.direccion;
            _telefonoController.text = universidad.telefono;
            _paginaWebController.text = universidad.paginaWeb;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cargar universidad: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Universidad' : 'Nueva Universidad'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icono y título
                    Icon(
                      Icons.school,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isEditing
                          ? 'Edita los datos de la universidad'
                          : 'Completa los datos de la nueva universidad',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 32),

                    // Campo NIT
                    TextFormField(
                      controller: _nitController,
                      decoration: const InputDecoration(
                        labelText: 'NIT *',
                        hintText: '890.123.456-7',
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El NIT es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre *',
                        hintText: 'Unidad Central del Valle',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        if (value.trim().length < 3) {
                          return 'El nombre debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Dirección
                    TextFormField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección *',
                        hintText: 'Cra 27A #48-144, Tuluá - Valle',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La dirección es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Teléfono
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono *',
                        hintText: '+57 602 2242202',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El teléfono es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Página Web
                    TextFormField(
                      controller: _paginaWebController,
                      decoration: const InputDecoration(
                        labelText: 'Página Web *',
                        hintText: 'https://www.uceva.edu.co',
                        prefixIcon: Icon(Icons.language),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La página web es requerida';
                        }
                        
                        // Validar formato URL
                        final urlPattern = RegExp(
                          r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                        );
                        
                        if (!urlPattern.hasMatch(value.trim())) {
                          return 'Ingresa una URL válida (debe comenzar con http:// o https://)';
                        }
                        
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '* Campos obligatorios',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton(
                            onPressed: _isLoading ? null : _guardar,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar NIT único
    final nitExiste = await _service.existeNit(
      _nitController.text.trim(),
      excludeId: _universidadOriginal?.id,
    );

    if (nitExiste && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya existe una universidad con ese NIT'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final universidad = Universidad(
        id: _universidadOriginal?.id,
        nit: _nitController.text.trim(),
        nombre: _nombreController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        paginaWeb: _paginaWebController.text.trim(),
      );

      if (_isEditing) {
        await _service.actualizarUniversidad(universidad);
      } else {
        await _service.crearUniversidad(universidad);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Universidad actualizada correctamente'
                  : 'Universidad creada correctamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
