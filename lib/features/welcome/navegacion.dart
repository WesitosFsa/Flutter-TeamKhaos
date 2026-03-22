import 'package:flutter/material.dart';
import 'package:plantilla/features/album/album_screen.dart';
import 'package:plantilla/features/notas/notas_screen.dart';
import 'package:plantilla/features/tareas/tareas_screen.dart';


class NavegacionScreen extends StatefulWidget {
  const NavegacionScreen({super.key});

  @override
  State<NavegacionScreen> createState() => _NavegacionScreenState();
}

class _NavegacionScreenState extends State<NavegacionScreen> {
  int currentPageIndex = 0;


  final List<Widget> _paginas = [
    const NotasScreen(),
    const VerTareasWidget(),
    const AlbumScreen()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[currentPageIndex], 

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index; 
          });
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.note), label: 'Notas'),
          NavigationDestination(icon: Icon(Icons.task), label: 'Tareas'),
          NavigationDestination(icon: Icon(Icons.add_a_photo_outlined), label: 'Album'),

        ],
      ),
    );
  }
}