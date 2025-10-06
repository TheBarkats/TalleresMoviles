import 'dart:async';

/// Servicio que maneja Timer para cronómetro y cuenta regresiva
class TimerService {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isCountdown = false;
  int _initialCountdownValue = 0;
  
  // Stream controller para notificar cambios de tiempo
  final StreamController<int> _timeController = StreamController<int>.broadcast();
  final StreamController<bool> _statusController = StreamController<bool>.broadcast();
  
  // Getters públicos
  Stream<int> get timeStream => _timeController.stream;
  Stream<bool> get statusStream => _statusController.stream;
  bool get isRunning => _isRunning;
  bool get isCountdown => _isCountdown;
  int get currentSeconds => _seconds;
  
  /// Inicia el cronómetro (cuenta hacia arriba)
  void startStopwatch() {
    print('⏱️ [TimerService] Iniciando cronómetro');
    _isCountdown = false;
    _start();
  }
  
  /// Inicia cuenta regresiva desde el valor especificado
  void startCountdown(int seconds) {
    print('⏳ [TimerService] Iniciando cuenta regresiva desde $seconds segundos');
    _isCountdown = true;
    _seconds = seconds;
    _initialCountdownValue = seconds;
    _timeController.add(_seconds);
    _start();
  }
  
  /// Pausa el timer
  void pause() {
    print('⏸️ [TimerService] Timer pausado');
    _timer?.cancel();
    _isRunning = false;
    _statusController.add(_isRunning);
  }
  
  /// Reanuda el timer
  void resume() {
    if (!_isRunning && _seconds > 0) {
      print('▶️ [TimerService] Timer reanudado');
      _start();
    }
  }
  
  /// Reinicia el timer
  void reset() {
    print('🔄 [TimerService] Timer reiniciado');
    _timer?.cancel();
    _seconds = _isCountdown ? _initialCountdownValue : 0;
    _isRunning = false;
    _timeController.add(_seconds);
    _statusController.add(_isRunning);
  }
  
  /// Para el timer completamente
  void stop() {
    print('⏹️ [TimerService] Timer detenido');
    _timer?.cancel();
    _seconds = 0;
    _isRunning = false;
    _timeController.add(_seconds);
    _statusController.add(_isRunning);
  }
  
  void _start() {
    if (_isRunning) return;
    
    _isRunning = true;
    _statusController.add(_isRunning);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCountdown) {
        _seconds--;
        _timeController.add(_seconds);
        
        // Cuenta regresiva terminó
        if (_seconds <= 0) {
          print('🔔 [TimerService] Cuenta regresiva terminada!');
          timer.cancel();
          _isRunning = false;
          _statusController.add(_isRunning);
          
          // Opcional: Callback cuando termine la cuenta regresiva
          _onCountdownFinished();
        }
      } else {
        // Cronómetro normal
        _seconds++;
        _timeController.add(_seconds);
      }
    });
  }
  
  void _onCountdownFinished() {
    // Aquí podrías agregar lógica adicional cuando termine la cuenta regresiva
    // Por ejemplo: reproducir sonido, mostrar notificación, etc.
    print('✅ [TimerService] ¡Tiempo terminado!');
  }
  
  /// Formatea los segundos en formato MM:SS o HH:MM:SS
  static String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// Limpia recursos cuando se destruye el servicio
  void dispose() {
    print('🗑️ [TimerService] Limpiando recursos');
    _timer?.cancel();
    _timeController.close();
    _statusController.close();
  }
}