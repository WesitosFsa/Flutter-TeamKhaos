import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'media.g.dart';

@HiveType(typeId: 2)
class Media extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titulo;

  @HiveField(2)
  String path; // Se usará en móvil/desktop

  @HiveField(3)
  bool esVideo;

  @HiveField(4)
  String fecha;

  @HiveField(5)
  Uint8List? bytes; // NUEVO: Para guardar la imagen en la Web

  Media({
    required this.id,
    required this.titulo,
    required this.path,
    this.esVideo = false,
    required this.fecha,
    this.bytes,
  });
}
