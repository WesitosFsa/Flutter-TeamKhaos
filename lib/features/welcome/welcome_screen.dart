import 'package:flutter/material.dart';
import 'package:plantilla/features/welcome/navegacion.dart';



class WelcomeScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  
  @override

  
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: PageView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
              child: const Center(
              child: Text("Bienvenido a a la aplicacion para gestion de tareas"),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue
            ),
            child: const Center(   
              child: Text("Este es un crud donde puede asignar o editar tareas"),

            ),
          ),  
          Container(
            decoration: const BoxDecoration(
              color: Colors.green
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Eso es todo espero te guste",
                   style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavegacionScreen()),
                  ), child: const Text('Siguiente')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}