import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/timer_service.dart';

/// Página que demuestra el uso de Timer con cronómetro y cuenta regresiva
class TimerDemoPage extends StatefulWidget {
  const TimerDemoPage({super.key});

  @override
  State<TimerDemoPage> createState() => _TimerDemoPageState();
}

class _TimerDemoPageState extends State<TimerDemoPage> {
  late TimerService _timerService;
  int _currentTime = 0;
  bool _isRunning = false;
  
  // Controllers para cuenta regresiva
  final _countdownController = TextEditingController(text: '60');
  
  // Stream subscriptions
  StreamSubscription<int>? _timeSubscription;
  StreamSubscription<bool>? _statusSubscription;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService();
    _setupStreamListeners();
  }

  void _setupStreamListeners() {
    _timeSubscription = _timerService.timeStream.listen((time) {
      setState(() {
        _currentTime = time;
      });
    });
    
    _statusSubscription = _timerService.statusStream.listen((isRunning) {
      setState(() {
        _isRunning = isRunning;
      });
    });
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    _statusSubscription?.cancel();
    _timerService.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTimerDisplay(),
            const SizedBox(height: 20),
            _buildStopwatchControls(),
            const SizedBox(height: 30),
            _buildCountdownSection(),
            const SizedBox(height: 30),
            _buildTimerInfo(),
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
                Icon(Icons.timer, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Demostración de Timer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta página demuestra:\n'
              '• Timer.periodic para cronómetro y cuenta regresiva\n'
              '• Manejo de estados: Iniciar / Pausar / Reanudar / Reiniciar\n'
              '• Limpieza de recursos con dispose()\n'
              '• Streams para comunicar cambios de tiempo',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _timerService.isCountdown ? Icons.hourglass_bottom : Icons.timer,
                  size: 32,
                  color: _isRunning ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  _timerService.isCountdown ? 'Cuenta Regresiva' : 'Cronómetro',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isRunning ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Display principal del tiempo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: _isRunning ? Colors.green.shade50 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isRunning ? Colors.green.shade300 : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Text(
                TimerService.formatTime(_currentTime),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                  color: _isRunning ? Colors.green.shade700 : Colors.grey.shade700,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Indicador de estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isRunning ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _isRunning ? '🟢 EN EJECUCIÓN' : '⏸️ PAUSADO',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopwatchControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⏱️ Cronómetro (Cuenta hacia arriba)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _timerService.isCountdown ? null : (!_isRunning ? _startStopwatch : _timerService.pause),
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !_isRunning && _currentTime > 0 ? _timerService.resume : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Reanudar'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _timerService.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _timerService.stop,
                    icon: const Icon(Icons.stop),
                    label: const Text('Detener'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⏳ Cuenta Regresiva (Countdown)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countdownController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Segundos',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                      helperText: 'Ingresa el tiempo en segundos',
                    ),
                    enabled: !_isRunning,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _startCountdown,
                  icon: const Icon(Icons.hourglass_bottom),
                  label: const Text('Iniciar\nCountdown'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Botones rápidos para countdown
            Wrap(
              spacing: 8,
              children: [
                _buildQuickCountdownButton('30s', 30),
                _buildQuickCountdownButton('1m', 60),
                _buildQuickCountdownButton('2m', 120),
                _buildQuickCountdownButton('5m', 300),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCountdownButton(String label, int seconds) {
    return ElevatedButton(
      onPressed: _isRunning ? null : () => _startCountdownWithSeconds(seconds),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.shade100,
        foregroundColor: Colors.deepOrange.shade700,
        textStyle: const TextStyle(fontSize: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildTimerInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Información del Timer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildInfoRow('Estado actual:', _isRunning ? 'Ejecutándose' : 'Detenido'),
            _buildInfoRow('Tipo:', _timerService.isCountdown ? 'Cuenta regresiva' : 'Cronómetro'),
            _buildInfoRow('Tiempo actual:', TimerService.formatTime(_currentTime)),
            _buildInfoRow('Actualización:', 'Cada 1 segundo'),
            
            const SizedBox(height: 8),
            const Text(
              '💡 Tips:\n'
              '• El Timer se cancela automáticamente al pausar\n'
              '• Los recursos se limpian en dispose()\n'
              '• La cuenta regresiva se detiene automáticamente en 0\n'
              '• Los streams permiten escuchar cambios de estado',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _startStopwatch() {
    _timerService.startStopwatch();
  }

  void _startCountdown() {
    final seconds = int.tryParse(_countdownController.text) ?? 60;
    if (seconds > 0) {
      _timerService.startCountdown(seconds);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un número válido de segundos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startCountdownWithSeconds(int seconds) {
    _countdownController.text = seconds.toString();
    _timerService.startCountdown(seconds);
  }
}