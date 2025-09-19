import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';

/// Punto de entrada de la aplicación
/// Configuración principal que inicia la aplicación con go_router
void main() {
  runApp(const MyApp());
}

/// Widget raíz de la aplicación
/// Configurado para usar go_router como sistema de navegación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taller 2 - Flutter Móviles',
      
      // Configuración del tema
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Configuración de AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        
        // Configuración de Cards
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        
        // Configuración de botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      
      // Configuración de go_router
      routerConfig: router,
      
      // Configuración para debug
      debugShowCheckedModeBanner: false,
    );
  }
}
