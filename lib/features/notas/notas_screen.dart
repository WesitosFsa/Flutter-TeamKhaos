import 'package:flutter/material.dart';
import 'package:plantilla/features/notas/model/nota.dart';
import 'package:plantilla/features/notas/service/nota_service.dart';
import 'package:plantilla/features/notas/view/nota_form_dialog.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  List<Nota> _notas = [];
  late Set<String> _seleccionadas = {};

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final box = await NotaService.getBox();
    setState(() {
      _notas = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: _seleccionadas.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => setState(() => _seleccionadas.clear()),
              )
            : const Icon(Icons.menu, color: Colors.black),
        title: Text(
          _seleccionadas.isNotEmpty
              ? '${_seleccionadas.length} seleccionadas'
              : ' ',
          style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _seleccionadas.length == _notas.length && _notas.isNotEmpty
                  ? Icons.deselect
                  : Icons.select_all,
              color: Colors.black,
            ),
            onPressed: _notas.isEmpty 
                ? null 
                : () {
                    setState(() {
                      if (_seleccionadas.length == _notas.length) {
                        _seleccionadas.clear();
                      } else {
                        _seleccionadas = _notas.map((n) => n.id).toSet();
                      }
                    });
                  },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: _seleccionadas.isNotEmpty ? Colors.red : Colors.grey,
            ),
            onPressed: _seleccionadas.isEmpty ? null : () => _confirmarEliminacion(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notas',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_notas.length} notas guardadas',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  final nota = _notas[index];
                  return Dismissible(
                    key: Key(nota.id),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      await NotaService.eliminarNotas([nota.id]);
                      setState(() {
                        _notas.removeAt(index);
                        _seleccionadas.remove(nota.id);
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (_seleccionadas.isNotEmpty) {
                          setState(() {
                            _seleccionadas.contains(nota.id)
                                ? _seleccionadas.remove(nota.id)
                                : _seleccionadas.add(nota.id);
                          });
                        } else {
                          _showEditDialog(nota);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          _seleccionadas.contains(nota.id)
                              ? _seleccionadas.remove(nota.id)
                              : _seleccionadas.add(nota.id);
                        });
                      },
                      child: _buildNotaCard(
                        nota,
                        isSelected: _seleccionadas.contains(nota.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: const Color(0xFF5D5FEF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNotaCard(Nota nota, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isSelected ? const Color(0xFF5D5FEF).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF5D5FEF) : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                // ignore: deprecated_member_use
                ? const Color(0xFF5D5FEF).withOpacity(0.3) 
                // ignore: deprecated_member_use
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          nota.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          nota.parrafo,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  void _showAddDialog() async {
    final res = await showDialog<dynamic>(
      context: context,
      builder: (context) => const NotaFormDialog(),
    );

    if (res != null && res is Map) {
      final nueva = Nota(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: res['titulo']!,
        parrafo: res['parrafo']!,
      );
      await NotaService.agregarNota(nueva);
      _cargarNotas();
    }
  }

  void _showEditDialog(Nota nota) async {
    final res = await showDialog<dynamic>(
      context: context,
      builder: (context) => NotaFormDialog(nota: nota),
    );

    if (res == 'delete') {
      await NotaService.eliminarNotas([nota.id]);
      _cargarNotas();
    } else if (res != null && res is Map) {
      nota.titulo = res['titulo']!;
      nota.parrafo = res['parrafo']!;
      await NotaService.actualizarNota(nota);
      _cargarNotas();
    }
  }

  void _confirmarEliminacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar notas?'),
        content: Text('Se eliminarán ${_seleccionadas.length} notas permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await NotaService.eliminarNotas(_seleccionadas.toList());
              setState(() {
                _seleccionadas.clear();
              });
              _cargarNotas();
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
