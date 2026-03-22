import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plantilla/features/tareas/model/tarea.dart';
import 'package:plantilla/features/notas/model/nota.dart';
import 'package:plantilla/features/album/model/media.dart';
import 'package:plantilla/features/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar los adaptadores generados
  Hive.registerAdapter(TareaAdapter());
  Hive.registerAdapter(NotaAdapter());
  Hive.registerAdapter(MediaAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      
    );
  }
}


