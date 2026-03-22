import 'package:hive/hive.dart';

part 'tarea.g.dart'; // Se genera con build_runner

@HiveType(typeId: 0)
class Tarea extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titulo;

  @HiveField(2)
  String descripcion;

  @HiveField(3)
  String fecha;

  @HiveField(4)
  bool completada;

  @HiveField(5)
  String hora;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    this.hora = "10:00 AM",
    this.completada = false,
  });
}