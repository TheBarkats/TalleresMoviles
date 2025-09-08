import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Clase principal de la aplicación, define el widget raíz.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Hola, Flutter'),
    );
  }
}

// Página principal de la app, con estado (StatefulWidget).
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Estado asociado a MyHomePage, maneja la lógica y el UI dinámico.

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _appBarTitle = 'Hola, Flutter';

  // Alterna el título de la AppBar y muestra un SnackBar
  void _toggleTitle() {
    setState(() {
      if (_appBarTitle == 'Hola, Flutter') {
        _appBarTitle = '¡Chao Flutter!';
      } else {
        _appBarTitle = 'Hola, Flutter';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Título actualizado')),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Cristopher Arias Contreras',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Row con dos imágenes: una de red y una local (asset)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen desde internet
                Image.network(
                  'https://ih1.redbubble.net/image.3493741147.4284/st,medium,507x507-pad,600x600,f8f8f8.webp',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 20),
                // Imagen local desde assets
                Image.asset(
                  'lib/assets/gato1.png',
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ElevatedButton para alternar el título
            ElevatedButton(
              onPressed: _toggleTitle,
              child: const Text('Cambiar título de la AppBar'),
            ),
            const SizedBox(height: 16),
            // ListView simple de 4 elementos con icono y texto
            Container(
              height: 140,
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text('Elemento 1'),
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text('Elemento 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.pink),
                    title: Text('Elemento 3'),
                  ),
                  ListTile(
                    leading: Icon(Icons.pets, color: Colors.blue),
                    title: Text('Elemento 4'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Contador y botón flotante
            const Text('Dale click para aumentar:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Incrementar',
              child: const Icon(Icons.add),
            ),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrementar',
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
