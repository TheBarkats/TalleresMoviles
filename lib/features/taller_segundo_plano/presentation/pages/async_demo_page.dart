import 'package:flutter/material.dart';
import '../../services/async_service.dart';

/// Página que demuestra el uso de Future, async/await y manejo de estados
class AsyncDemoPage extends StatefulWidget {
  const AsyncDemoPage({super.key});

  @override
  State<AsyncDemoPage> createState() => _AsyncDemoPageState();
}

class _AsyncDemoPageState extends State<AsyncDemoPage> {
  // Estados para demostrar async/await
  bool _isLoading = false;
  List<String>? _data;
  String? _error;
  
  // Estados para múltiples consultas
  bool _isLoadingMultiple = false;
  Map<String, dynamic>? _multipleData;
  String? _multipleError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async/Await Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSingleAsyncSection(),
            const SizedBox(height: 30),
            _buildMultipleAsyncSection(),
            const SizedBox(height: 30),
            _buildConsoleSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Demostración de Asincronía',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta página demuestra:\n'
              '• Future.delayed para simular operaciones asíncronas\n'
              '• async/await para manejo de operaciones no bloqueantes\n'
              '• Manejo de estados: Cargando / Éxito / Error\n'
              '• Operaciones paralelas con Future.wait',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleAsyncSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Consulta Simple (Future/async/await)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _fetchData(3),
                    icon: const Icon(Icons.download),
                    label: const Text('Consultar (3s)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _fetchData(1),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Rápido (1s)'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Estado de la consulta
            if (_isLoading) _buildLoadingState(),
            if (_error != null) _buildErrorState(_error!),
            if (_data != null && !_isLoading) _buildSuccessState(_data!),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleAsyncSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Consultas Múltiples Paralelas (Future.wait)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _isLoadingMultiple ? null : _fetchMultipleData,
              icon: const Icon(Icons.sync),
              label: const Text('Ejecutar 3 consultas en paralelo'),
            ),
            
            const SizedBox(height: 16),
            
            if (_isLoadingMultiple) _buildMultipleLoadingState(),
            if (_multipleError != null) _buildErrorState(_multipleError!),
            if (_multipleData != null && !_isLoadingMultiple) 
              _buildMultipleSuccessState(_multipleData!),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleSection() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.terminal, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Consola de Debug',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa la consola de debug (Debug Console) para ver:\n'
              '• Orden de ejecución de las operaciones\n'
              '• Timestamps de inicio y fin\n'
              '• Manejo de errores y excepciones',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          const Text(
            'Cargando datos...',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            'Estado: LOADING',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ejecutando consultas paralelas...',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          const Text(
            '📡 Perfil de usuario\n📊 Estadísticas\n🔔 Notificaciones',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error en la consulta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  error,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'Estado: ERROR',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(List<String> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text(
                'Datos cargados exitosamente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Estado: SUCCESS',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...data.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.fiber_manual_record, size: 8),
                const SizedBox(width: 8),
                Text(item, style: const TextStyle(fontSize: 13)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMultipleSuccessState(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.done_all, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text(
                'Todas las consultas completadas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Profile data
          if (data['profile'] != null) ...[
            const Text('👤 Perfil:', style: TextStyle(fontWeight: FontWeight.w500)),
            Text('  ${data['profile']['name']} ${data['profile']['avatar']}'),
            Text('  ${data['profile']['role']}'),
            const SizedBox(height: 8),
          ],
          
          // Stats data
          if (data['stats'] != null) ...[
            const Text('📊 Estadísticas:', style: TextStyle(fontWeight: FontWeight.w500)),
            Text('  Proyectos: ${data['stats']['projects']}'),
            Text('  Commits: ${data['stats']['commits']}'),
            Text('  Seguidores: ${data['stats']['followers']}'),
            const SizedBox(height: 8),
          ],
          
          // Notifications
          if (data['notifications'] != null) ...[
            const Text('🔔 Notificaciones:', style: TextStyle(fontWeight: FontWeight.w500)),
            ...(data['notifications'] as List).map((notif) => Text('  • $notif')),
          ],
          
          const SizedBox(height: 8),
          Text(
            'Completado: ${data['timestamp']}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Método para ejecutar consulta simple usando async/await
  Future<void> _fetchData(int delaySeconds) async {
    print('\n🔵 [UI] ANTES: Iniciando consulta de $delaySeconds segundos');
    
    setState(() {
      _isLoading = true;
      _data = null;
      _error = null;
    });
    
    try {
      print('🔵 [UI] DURANTE: Esperando resultado...');
      final result = await AsyncService.fetchData(delaySeconds: delaySeconds);
      
      print('🔵 [UI] DESPUÉS: Resultado recibido');
      setState(() {
        _data = result;
        _isLoading = false;
      });
      
    } catch (e) {
      print('🔴 [UI] DESPUÉS: Error capturado - $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Método para ejecutar múltiples consultas paralelas
  Future<void> _fetchMultipleData() async {
    print('\n🟡 [UI] Iniciando consultas múltiples paralelas');
    
    setState(() {
      _isLoadingMultiple = true;
      _multipleData = null;
      _multipleError = null;
    });
    
    try {
      final result = await AsyncService.fetchMultipleData();
      
      setState(() {
        _multipleData = result;
        _isLoadingMultiple = false;
      });
      
    } catch (e) {
      setState(() {
        _multipleError = e.toString();
        _isLoadingMultiple = false;
      });
    }
  }
}