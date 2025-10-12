import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/taller_http/presentation/pages/home_page.dart';
import '../../features/taller_http/presentation/pages/starwars_characters_page.dart';
import '../../features/taller_http/presentation/pages/character_detail_page.dart';

/// Configuración central de rutas para el Taller HTTP - Star Wars API
/// Maneja toda la navegación de la aplicación con tipo seguro
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta principal - HomePage del Taller HTTP
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    
    // Ruta principal del taller HTTP - Lista de personajes
    GoRoute(
      path: '/starwars',
      name: 'starwars-characters',
      builder: (context, state) => const StarWarsCharactersPage(),
    ),
    
    // Ruta de detalle del personaje con parámetros
    GoRoute(
      path: '/starwars/character/:id',
      name: 'character-detail',
      builder: (context, state) {
        final characterId = state.pathParameters['id']!;
        final characterName = state.uri.queryParameters['name'] ?? 'Personaje sin nombre';
        return CharacterDetailPage(
          characterId: characterId,
          characterName: characterName,
        );
      },
    ),
  ],
  
  // Página de error personalizada
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
      backgroundColor: Colors.red,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Página no encontrada',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.error.toString(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Volver al Inicio'),
          ),
        ],
      ),
    ),
  ),
);
