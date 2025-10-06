import 'dart:isolate';
import 'dart:math';

/// Servicio que maneja Isolates para tareas pesadas sin bloquear la UI
class IsolateService {
  
  /// Ejecuta una tarea pesada de suma en un Isolate separado
  static Future<BigSumResult> calculateHeavySum(int iterations) async {
    print('🔧 [IsolateService] Iniciando cálculo pesado con $iterations iteraciones');
    
    final receivePort = ReceivePort();
    final isolateData = IsolateData(
      sendPort: receivePort.sendPort,
      iterations: iterations,
    );
    
    try {
      // Spawn del Isolate
      await Isolate.spawn(_heavySumIsolate, isolateData);
      
      // Esperar resultado del Isolate
      final result = await receivePort.first as BigSumResult;
      print('✅ [IsolateService] Cálculo completado');
      
      return result;
      
    } catch (e) {
      print('❌ [IsolateService] Error en Isolate: $e');
      rethrow;
    } finally {
      receivePort.close();
    }
  }
  
  /// Genera una lista grande de números primos usando Isolate
  static Future<PrimeResult> generatePrimes(int maxNumber) async {
    print('🔢 [IsolateService] Generando números primos hasta $maxNumber');
    
    final receivePort = ReceivePort();
    final isolateData = IsolateData(
      sendPort: receivePort.sendPort,
      iterations: maxNumber,
    );
    
    try {
      await Isolate.spawn(_primeGeneratorIsolate, isolateData);
      final result = await receivePort.first as PrimeResult;
      print('✅ [IsolateService] Generación de primos completada');
      
      return result;
      
    } catch (e) {
      print('❌ [IsolateService] Error generando primos: $e');
      rethrow;
    } finally {
      receivePort.close();
    }
  }
  
  /// Simula procesamiento de imagen/datos pesados
  static Future<ImageProcessResult> processHeavyData(int dataSize) async {
    print('🖼️ [IsolateService] Procesando datos pesados de tamaño $dataSize');
    
    final receivePort = ReceivePort();
    final isolateData = IsolateData(
      sendPort: receivePort.sendPort,
      iterations: dataSize,
    );
    
    try {
      await Isolate.spawn(_heavyDataProcessingIsolate, isolateData);
      final result = await receivePort.first as ImageProcessResult;
      print('✅ [IsolateService] Procesamiento completado');
      
      return result;
      
    } catch (e) {
      print('❌ [IsolateService] Error procesando datos: $e');
      rethrow;
    } finally {
      receivePort.close();
    }
  }
}

/// Función que se ejecuta en el Isolate para cálculos pesados
void _heavySumIsolate(IsolateData data) {
  final stopwatch = Stopwatch()..start();
  
  double sum = 0;
  for (int i = 0; i < data.iterations; i++) {
    // Operación CPU-intensiva: suma con operaciones matemáticas complejas
    sum += sqrt(i * i + 1) * sin(i) * cos(i);
    
    // Simulamos más trabajo
    if (i % 1000 == 0) {
      sum = sum / 1.0001; // Evitar overflow
    }
  }
  
  stopwatch.stop();
  
  final result = BigSumResult(
    sum: sum,
    iterations: data.iterations,
    executionTimeMs: stopwatch.elapsedMilliseconds,
    isolateId: Isolate.current.hashCode,
  );
  
  data.sendPort.send(result);
}

/// Función que genera números primos en Isolate
void _primeGeneratorIsolate(IsolateData data) {
  final stopwatch = Stopwatch()..start();
  final primes = <int>[];
  
  for (int num = 2; num <= data.iterations; num++) {
    bool isPrime = true;
    for (int i = 2; i <= sqrt(num); i++) {
      if (num % i == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) {
      primes.add(num);
    }
  }
  
  stopwatch.stop();
  
  final result = PrimeResult(
    primes: primes,
    maxNumber: data.iterations,
    count: primes.length,
    executionTimeMs: stopwatch.elapsedMilliseconds,
    isolateId: Isolate.current.hashCode,
  );
  
  data.sendPort.send(result);
}

/// Función que simula procesamiento pesado de datos
void _heavyDataProcessingIsolate(IsolateData data) {
  final stopwatch = Stopwatch()..start();
  final random = Random();
  
  // Simulamos procesamiento de datos pesados
  final processedData = <String>[];
  for (int i = 0; i < data.iterations; i++) {
    // Simulamos transformaciones complejas
    final value = random.nextDouble() * 1000;
    final processed = 'Item_${i}_processed_${(value * sin(i) * cos(i)).toStringAsFixed(2)}';
    processedData.add(processed);
    
    // Simulamos más trabajo CPU-intensivo
    if (i % 100 == 0) {
      processedData.sort();
    }
  }
  
  stopwatch.stop();
  
  final result = ImageProcessResult(
    processedItems: processedData.length,
    sampleData: processedData.take(5).toList(),
    dataSize: data.iterations,
    executionTimeMs: stopwatch.elapsedMilliseconds,
    isolateId: Isolate.current.hashCode,
  );
  
  data.sendPort.send(result);
}

/// Clase para pasar datos al Isolate
class IsolateData {
  final SendPort sendPort;
  final int iterations;
  
  IsolateData({
    required this.sendPort,
    required this.iterations,
  });
}

/// Resultado del cálculo pesado de suma
class BigSumResult {
  final double sum;
  final int iterations;
  final int executionTimeMs;
  final int isolateId;
  
  BigSumResult({
    required this.sum,
    required this.iterations,
    required this.executionTimeMs,
    required this.isolateId,
  });
  
  @override
  String toString() {
    return 'Suma: ${sum.toStringAsFixed(2)}\n'
           'Iteraciones: $iterations\n'
           'Tiempo: ${executionTimeMs}ms\n'
           'Isolate ID: $isolateId';
  }
}

/// Resultado de la generación de números primos
class PrimeResult {
  final List<int> primes;
  final int maxNumber;
  final int count;
  final int executionTimeMs;
  final int isolateId;
  
  PrimeResult({
    required this.primes,
    required this.maxNumber,
    required this.count,
    required this.executionTimeMs,
    required this.isolateId,
  });
  
  @override
  String toString() {
    final sample = primes.take(10).join(', ');
    return 'Primos encontrados: $count\n'
           'Rango: 2 - $maxNumber\n'
           'Muestra: $sample${count > 10 ? '...' : ''}\n'
           'Tiempo: ${executionTimeMs}ms\n'
           'Isolate ID: $isolateId';
  }
}

/// Resultado del procesamiento pesado de datos
class ImageProcessResult {
  final int processedItems;
  final List<String> sampleData;
  final int dataSize;
  final int executionTimeMs;
  final int isolateId;
  
  ImageProcessResult({
    required this.processedItems,
    required this.sampleData,
    required this.dataSize,
    required this.executionTimeMs,
    required this.isolateId,
  });
  
  @override
  String toString() {
    return 'Items procesados: $processedItems\n'
           'Tamaño original: $dataSize\n'
           'Muestra: ${sampleData.join(', ')}\n'
           'Tiempo: ${executionTimeMs}ms\n'
           'Isolate ID: $isolateId';
  }
}