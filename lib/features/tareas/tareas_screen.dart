import 'package:flutter/material.dart';
import 'package:plantilla/features/tareas/model/tarea.dart';
import 'package:plantilla/features/tareas/service/tarea_service.dart';
import 'package:plantilla/features/tareas/view/tarea_form_dialog.dart';


class VerTareasWidget extends StatefulWidget {
  const VerTareasWidget({super.key});

  @override
  State<VerTareasWidget> createState() => _VerTareasWidgetState();
}

class _VerTareasWidgetState extends State<VerTareasWidget> {
  List<Tarea> _tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    final box = await TareaService.getBox();
    setState(() {
      _tareas = box.values.toList();
    });
  }

  late Set<String> _seleccionadas = {};

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
          // Botón para seleccionar todas las tareas
          IconButton(
            icon: Icon(
              _seleccionadas.length == _tareas.length && _tareas.isNotEmpty
                  ? Icons.deselect
                  : Icons.select_all,
              color: Colors.black,
            ),
            onPressed: _tareas.isEmpty 
                ? null 
                : () {
                    setState(() {
                      if (_seleccionadas.length == _tareas.length) {
                        _seleccionadas.clear();
                      } else {
                        _seleccionadas = _tareas.map((t) => t.id).toSet();
                      }
                    });
                  },
          ),
          // Icono de basura (desactivado si no hay selección)
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
              'Mis Tareas',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_tareas.where((t) => t.completada).length} de ${_tareas.length} tareas',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _tareas.length,
                itemBuilder: (context, index) {
                  final tarea = _tareas[index];
                  return Dismissible(
                    key: Key(tarea.id),
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
                      await TareaService.eliminarTareas([tarea.id]);
                      setState(() {
                        _tareas.removeAt(index);
                        _seleccionadas.remove(tarea.id);
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (_seleccionadas.isNotEmpty) {
                          setState(() {
                            _seleccionadas.contains(tarea.id)
                                ? _seleccionadas.remove(tarea.id)
                                : _seleccionadas.add(tarea.id);
                          });
                        } else {
                          _showEditDialog(tarea);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          _seleccionadas.contains(tarea.id)
                              ? _seleccionadas.remove(tarea.id)
                              : _seleccionadas.add(tarea.id);
                        });
                      },
                      child: _buildTaskCard(
                        tarea,
                        isSelected: _seleccionadas.contains(tarea.id),
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

  Widget _buildTaskCard(Tarea tarea, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // FONDO: Morado muy suave si está SELECCIONADA, si no, blanco
        // ignore: deprecated_member_use
        color: isSelected ? const Color(0xFF5D5FEF).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        // BORDE DE SELECCIÓN: Morado grueso solo si está seleccionada
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
        leading: GestureDetector(
          onTap: () async {
            setState(() => tarea.completada = !tarea.completada);
            await TareaService.actualizarTarea(tarea);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: tarea.completada ? Colors.transparent : Colors.grey.shade400,
                width: 2,
              ),
              color: tarea.completada ? const Color(0xFF5D5FEF) : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: tarea.completada
                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                  : const Icon(Icons.circle, size: 20, color: Colors.transparent),
            ),
          ),
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // ESTADO COMPLETADA: Texto tachado y color gris
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
            color: tarea.completada ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarea.descripcion, 
              style: TextStyle(
                color: tarea.completada ? Colors.grey.shade400 : Colors.grey[600],
                decoration: tarea.completada ? TextDecoration.lineThrough : null,
              )
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${tarea.fecha} - ${tarea.hora}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10, 
                  color: tarea.completada ? Colors.grey.shade400 : Colors.grey[400]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() async {
    final res = await showDialog<dynamic>(
      context: context,
      builder: (context) => const TareaFormDialog(),
    );

    if (res != null && res is Map) {
      final nueva = Tarea(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: res['titulo']!,
        descripcion: res['descripcion']!,
        fecha: res['fecha']!,
        hora: res['hora']!,
      );
      await TareaService.agregarTarea(nueva);
      _cargarTareas();
    }
  }

  void _showEditDialog(Tarea tarea) async {
    final res = await showDialog<dynamic>(
      context: context,
      builder: (context) => TareaFormDialog(tarea: tarea),
    );

    if (res == 'delete') {
      await TareaService.eliminarTareas([tarea.id]);
      _cargarTareas();
    } else if (res != null && res is Map) {
      tarea.titulo = res['titulo']!;
      tarea.descripcion = res['descripcion']!;
      tarea.fecha = res['fecha']!;
      tarea.hora = res['hora']!;
      await TareaService.actualizarTarea(tarea);
      _cargarTareas();
    }
    }

    void _confirmarEliminacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar tareas?'),
        content: Text('Se eliminarán ${_seleccionadas.length} tareas permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              await TareaService.eliminarTareas(_seleccionadas.toList());
              setState(() {
                _seleccionadas.clear();
              });
              _cargarTareas(); // Refrescar lista
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    }
    }