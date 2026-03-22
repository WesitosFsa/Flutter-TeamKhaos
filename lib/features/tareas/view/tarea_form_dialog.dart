import 'package:flutter/material.dart';
import 'package:plantilla/features/tareas/model/tarea.dart';

class TareaFormDialog extends StatefulWidget {
  final Tarea? tarea;

  const TareaFormDialog({super.key, this.tarea});

  @override
  State<TareaFormDialog> createState() => _TareaFormDialogState();
}

class _TareaFormDialogState extends State<TareaFormDialog> {
  late TextEditingController _tituloController;
  late TextEditingController _descController;
  late String _time;
  late String _date;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarea?.titulo ?? '');
    _descController = TextEditingController(text: widget.tarea?.descripcion ?? '');
    _time = widget.tarea?.hora ?? "10:00 AM";
    _date = widget.tarea?.fecha ?? "Mar 21, 2026";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _date = "${_getMonth(picked.month)} ${picked.day}, ${picked.year}";
      });
    }
  }

  String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _time = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.tarea != null;

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
                isEditing ? 'Actualizar Tarea' : 'Add Task',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Que estas planeando?", style: TextStyle(color: Colors.grey)),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.sports_soccer, size: 20),
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              maxLines: null,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.bookmark_border, size: 20),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Hora", _time, onTap: () => _selectTime(context)),
            const SizedBox(height: 15),
            _buildInfoRow("Fecha", _date, onTap: () => _selectDate(context)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context, 'delete'),
                    icon: const Icon(Icons.close, color: Color(0xFF5D5FEF)),
                    label: const Text("Delete Task", style: TextStyle(color: Color(0xFF5D5FEF))),
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
                          'descripcion': _descController.text,
                          'fecha': _date,
                          'hora': _time,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D5FEF),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? "Actualizar Tarea" : "Guardar Tarea", style: const TextStyle(color: Colors.white)),
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

  Widget _buildInfoRow(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}