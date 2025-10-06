import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/isolate_service.dart';

/// Página que demuestra el uso de Isolates para tareas CPU-intensivas
class IsolateDemoPage extends StatefulWidget {
  const IsolateDemoPage({super.key});

  @override
  State<IsolateDemoPage> createState() => _IsolateDemoPageState();
}

class _IsolateDemoPageState extends State<IsolateDemoPage>
    with TickerProviderStateMixin {
  
  // Estados para diferentes tareas
  bool _isCalculating = false;
  bool _isGeneratingPrimes = false;
  bool _isProcessingData = false;
  
  // Resultados
  BigSumResult? _sumResult;
  PrimeResult? _primeResult;
  ImageProcessResult? _processResult;
  
  // Controladores para inputs
  final _iterationsController = TextEditingController(text: '1000000');
  final _primesController = TextEditingController(text: '10000');
  final _dataController = TextEditingController(text: '5000');
  
  // Para demostrar que la UI no se bloquea
  late AnimationController _uiAnimationController;
  late Animation<double> _uiAnimation;
  
  // Contador para demostrar que la UI sigue funcionando
  int _uiCounter = 0;
  Timer? _uiCounterTimer;

  @override
  void initState() {
    super.initState();
    _setupUIAnimation();
    _startUICounter();
  }

  void _setupUIAnimation() {
    _uiAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _uiAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _uiAnimationController, curve: Curves.easeInOut),
    );
    _uiAnimationController.repeat(reverse: true);
  }

  void _startUICounter() {
    _uiCounterTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _uiCounter++;
      });
    });
  }

  @override
  void dispose() {
    _uiAnimationController.dispose();
    _uiCounterTimer?.cancel();
    _iterationsController.dispose();
    _primesController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildUIStatusCard(),
            const SizedBox(height: 20),
            _buildHeavySumSection(),
            const SizedBox(height: 20),
            _buildPrimeGeneratorSection(),
            const SizedBox(height: 20),
            _buildDataProcessingSection(),
            const SizedBox(height: 20),
            _buildIsolateInfo(),
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
                Icon(Icons.memory, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Demostración de Isolates',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta página demuestra:\n'
              '• Isolate.spawn para tareas CPU-intensivas\n'
              '• Comunicación por mensajes (SendPort/ReceivePort)\n'
              '• La UI permanece responsiva durante cálculos pesados\n'
              '• Diferentes tipos de tareas pesadas paralelas',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUIStatusCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Estado de la UI (Prueba de No-Bloqueo)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Contador que demuestra que la UI sigue funcionando
                Column(
                  children: [
                    const Text('Contador UI:', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      '$_uiCounter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const Text('(+10/sec)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                
                // Animación que demuestra fluidez
                Column(
                  children: [
                    const Text('Animación UI:', style: TextStyle(fontWeight: FontWeight.w500)),
                    AnimatedBuilder(
                      animation: _uiAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(_uiAnimation.value),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.green.shade700, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white.withOpacity(1 - _uiAnimation.value),
                            ),
                          ),
                        );
                      },
                    ),
                    const Text('Fluida ✓', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '✅ La UI permanece responsiva mientras los Isolates trabajan en segundo plano',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeavySumSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🧮 Cálculo Pesado de Suma',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _iterationsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Iteraciones',
                      border: OutlineInputBorder(),
                      helperText: 'Más iteraciones = más tiempo',
                    ),
                    enabled: !_isCalculating,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isCalculating ? null : _calculateHeavySum,
                  icon: _isCalculating 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.calculate),
                  label: Text(_isCalculating ? 'Calculando...' : 'Calcular'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Botones rápidos
            Wrap(
              spacing: 8,
              children: [
                _buildQuickButton('100K', 100000, _isCalculating, () => _calculateWithIterations(100000)),
                _buildQuickButton('500K', 500000, _isCalculating, () => _calculateWithIterations(500000)),
                _buildQuickButton('1M', 1000000, _isCalculating, () => _calculateWithIterations(1000000)),
                _buildQuickButton('5M', 5000000, _isCalculating, () => _calculateWithIterations(5000000)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_sumResult != null) _buildSumResult(_sumResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimeGeneratorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔢 Generador de Números Primos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _primesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número máximo',
                      border: OutlineInputBorder(),
                      helperText: 'Generar primos hasta este número',
                    ),
                    enabled: !_isGeneratingPrimes,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isGeneratingPrimes ? null : _generatePrimes,
                  icon: _isGeneratingPrimes 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.filter_list),
                  label: Text(_isGeneratingPrimes ? 'Generando...' : 'Generar'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              children: [
                _buildQuickButton('1K', 1000, _isGeneratingPrimes, () => _generatePrimesWithMax(1000)),
                _buildQuickButton('5K', 5000, _isGeneratingPrimes, () => _generatePrimesWithMax(5000)),
                _buildQuickButton('10K', 10000, _isGeneratingPrimes, () => _generatePrimesWithMax(10000)),
                _buildQuickButton('50K', 50000, _isGeneratingPrimes, () => _generatePrimesWithMax(50000)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_primeResult != null) _buildPrimeResult(_primeResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildDataProcessingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🖼️ Procesamiento Pesado de Datos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dataController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Elementos a procesar',
                      border: OutlineInputBorder(),
                      helperText: 'Simula procesamiento de imágenes/datos',
                    ),
                    enabled: !_isProcessingData,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessingData ? null : _processHeavyData,
                  icon: _isProcessingData 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.image),
                  label: Text(_isProcessingData ? 'Procesando...' : 'Procesar'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              children: [
                _buildQuickButton('1K', 1000, _isProcessingData, () => _processDataWithSize(1000)),
                _buildQuickButton('2.5K', 2500, _isProcessingData, () => _processDataWithSize(2500)),
                _buildQuickButton('5K', 5000, _isProcessingData, () => _processDataWithSize(5000)),
                _buildQuickButton('10K', 10000, _isProcessingData, () => _processDataWithSize(10000)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_processResult != null) _buildProcessResult(_processResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, int value, bool isDisabled, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.purple.shade700,
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildSumResult(BigSumResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              const Text('Resultado del Cálculo:', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(result.toString(), style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPrimeResult(PrimeResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              const Text('Números Primos Generados:', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(result.toString(), style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildProcessResult(ImageProcessResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.orange.shade700, size: 20),
              const SizedBox(width: 8),
              const Text('Procesamiento Completado:', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(result.toString(), style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildIsolateInfo() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  'Información sobre Isolates',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '🔧 Cómo funcionan los Isolates:\n'
              '• Cada Isolate tiene su propia memoria heap\n'
              '• Se comunican solo por mensajes (SendPort/ReceivePort)\n'
              '• Perfectos para cálculos CPU-intensivos\n'
              '• No bloquean el hilo principal de la UI\n\n'
              '💡 Cuándo usarlos:\n'
              '• Parsing de archivos grandes (JSON, CSV)\n'
              '• Procesamiento de imágenes\n'
              '• Cálculos matemáticos complejos\n'
              '• Compresión/descompresión de datos\n'
              '• Algoritmos de búsqueda o ordenamiento pesados',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _calculateHeavySum() async {
    final iterations = int.tryParse(_iterationsController.text) ?? 1000000;
    _calculateWithIterations(iterations);
  }

  Future<void> _calculateWithIterations(int iterations) async {
    setState(() {
      _isCalculating = true;
      _sumResult = null;
    });

    try {
      final result = await IsolateService.calculateHeavySum(iterations);
      setState(() {
        _sumResult = result;
      });
    } catch (e) {
      _showError('Error en cálculo: $e');
    } finally {
      setState(() {
        _isCalculating = false;
      });
    }
  }

  Future<void> _generatePrimes() async {
    final maxNumber = int.tryParse(_primesController.text) ?? 10000;
    _generatePrimesWithMax(maxNumber);
  }

  Future<void> _generatePrimesWithMax(int maxNumber) async {
    setState(() {
      _isGeneratingPrimes = true;
      _primeResult = null;
    });

    try {
      final result = await IsolateService.generatePrimes(maxNumber);
      setState(() {
        _primeResult = result;
      });
    } catch (e) {
      _showError('Error generando primos: $e');
    } finally {
      setState(() {
        _isGeneratingPrimes = false;
      });
    }
  }

  Future<void> _processHeavyData() async {
    final dataSize = int.tryParse(_dataController.text) ?? 5000;
    _processDataWithSize(dataSize);
  }

  Future<void> _processDataWithSize(int dataSize) async {
    setState(() {
      _isProcessingData = true;
      _processResult = null;
    });

    try {
      final result = await IsolateService.processHeavyData(dataSize);
      setState(() {
        _processResult = result;
      });
    } catch (e) {
      _showError('Error procesando datos: $e');
    } finally {
      setState(() {
        _isProcessingData = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}