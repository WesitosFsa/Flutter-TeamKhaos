import 'dart:io';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:plantilla/features/album/model/media.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  static const String boxName = 'mediaBox';

  static Future<Box<Media>> getBox() async {
    return await Hive.openBox<Media>(boxName);
  }

  // Ahora acepta XFile para mayor compatibilidad
  static Future<void> agregarMedia(XFile pickedFile, String titulo, bool esVideo) async {
    final bytes = await pickedFile.readAsBytes();
    String permanentPath = "";

    if (!kIsWeb) {
      // SOLO PARA MOVIL/DESKTOP: Copiar el archivo físicamente
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(pickedFile.path);
      permanentPath = p.join(appDir.path, fileName);
      final permanentFile = File(permanentPath);
      await permanentFile.writeAsBytes(bytes);
    }

    final media = Media(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      path: permanentPath,
      esVideo: esVideo,
      fecha: DateTime.now().toString().split(' ')[0],
      bytes: kIsWeb ? bytes : null, // Guardamos los bytes en la Web
    );

    final box = await getBox();
    await box.put(media.id, media);
  }

  static Future<void> eliminarMedia(List<Media> listaMedia) async {
    final box = await getBox();
    for (var media in listaMedia) {
      if (!kIsWeb && media.path.isNotEmpty) {
        final file = File(media.path);
        if (await file.exists()) {
          await file.delete();
        }
      }
      await box.delete(media.id);
    }
  }
}
