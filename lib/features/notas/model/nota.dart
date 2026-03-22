import 'package:hive/hive.dart';

part 'nota.g.dart'; // Se genera con build_runner

@HiveType(typeId: 1) // El 0 ya lo usa Tarea
class Nota extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titulo;

  @HiveField(2)
  String parrafo;

  Nota({
    required this.id,
    required this.titulo,
    required this.parrafo,
  });
}
