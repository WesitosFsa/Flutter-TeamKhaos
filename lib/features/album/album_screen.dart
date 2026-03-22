import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantilla/features/album/model/media.dart';
import 'package:plantilla/features/album/service/media_service.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<Media> _album = [];
  late Set<String> _seleccionadas = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarAlbum();
  }

  Future<void> _cargarAlbum() async {
    final box = await MediaService.getBox();
    setState(() {
      _album = box.values.toList();
    });
  }

  Future<void> _pickMedia() async {
    final bool? esVideo = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Qué deseas añadir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('FOTO'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('VIDEO'),
          ),
        ],
      ),
    );

    if (esVideo == null) return;

    final XFile? pickedFile = esVideo
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Usar el método actualizado que maneja bytes
      await MediaService.agregarMedia(pickedFile, "Nueva captura", esVideo);
      _cargarAlbum();
    }
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
              : '  ',
          style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _seleccionadas.length == _album.length && _album.isNotEmpty
                  ? Icons.deselect
                  : Icons.select_all,
              color: Colors.black,
            ),
            onPressed: _album.isEmpty 
                ? null 
                : () {
                    setState(() {
                      if (_seleccionadas.length == _album.length) {
                        _seleccionadas.clear();
                      } else {
                        _seleccionadas = _album.map((m) => m.id).toSet();
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
              'Galería Local',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_album.length} archivos multimedia',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _album.length,
                itemBuilder: (context, index) {
                  final media = _album[index];
                  final isSelected = _seleccionadas.contains(media.id);
                  return GestureDetector(
                    onTap: () {
                      if (_seleccionadas.isNotEmpty) {
                        setState(() {
                          isSelected
                              ? _seleccionadas.remove(media.id)
                              : _seleccionadas.add(media.id);
                        });
                      } else {
                        // Podrías abrir un visor aquí
                      }
                    },
                    onLongPress: () {
                      setState(() => _seleccionadas.add(media.id));
                    },
                    child: _buildMediaCard(media, isSelected),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickMedia,
        backgroundColor: const Color(0xFF5D5FEF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }

  Widget _buildMediaCard(Media media, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? const Color(0xFF5D5FEF) : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF5D5FEF).withOpacity(0.3),
              blurRadius: 10,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Carga de imagen diferente para WEB y MOVIL
            kIsWeb 
              ? (media.bytes != null 
                  ? Image.memory(media.bytes!, fit: BoxFit.cover) 
                  : const Center(child: Icon(Icons.broken_image)))
              : Image.file(
                  File(media.path),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
            if (media.esVideo)
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
            if (isSelected)
              Container(
                color: const Color(0xFF5D5FEF).withOpacity(0.3),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 30),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar archivos?'),
        content: Text('Se eliminarán ${_seleccionadas.length} archivos permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final aEliminar = _album.where((m) => _seleccionadas.contains(m.id)).toList();
              await MediaService.eliminarMedia(aEliminar);
              setState(() {
                _seleccionadas.clear();
              });
              _cargarAlbum();
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
