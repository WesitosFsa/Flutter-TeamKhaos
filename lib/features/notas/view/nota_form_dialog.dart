import 'package:flutter/material.dart';
import 'package:plantilla/features/notas/model/nota.dart';

class NotaFormDialog extends StatefulWidget {
  final Nota? nota;

  const NotaFormDialog({super.key, this.nota});

  @override
  State<NotaFormDialog> createState() => _NotaFormDialogState();
}

class _NotaFormDialogState extends State<NotaFormDialog> {
  late TextEditingController _tituloController;
  late TextEditingController _parrafoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota?.titulo ?? '');
    _parrafoController = TextEditingController(text: widget.nota?.parrafo ?? '');
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.nota != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isEditing ? 'Actualizar Nota' : 'Nueva Nota',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Título de la nota", style: TextStyle(color: Colors.grey)),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title, size: 20),
                border: InputBorder.none,
                hintText: "Escribe un título...",
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text("Contenido", style: TextStyle(color: Colors.grey)),
            Expanded(
              child: TextField(
                controller: _parrafoController,
                maxLines: null,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.notes, size: 20),
                  border: InputBorder.none,
                  hintText: "Escribe algo aquí...",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context, 'delete'),
                    icon: const Icon(Icons.close, color: Color(0xFF5D5FEF)),
                    label: const Text("Eliminar", style: TextStyle(color: Color(0xFF5D5FEF))),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Color(0xFF5D5FEF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_tituloController.text.isNotEmpty) {
                        Navigator.pop(context, {
                          'titulo': _tituloController.text,
                          'parrafo': _parrafoController.text,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D5FEF),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? "Actualizar" : "Guardar", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
