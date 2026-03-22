import 'package:hive_flutter/hive_flutter.dart';
import 'package:plantilla/features/tareas/model/tarea.dart';


class TareaService {
  static const String boxName = 'tareasBox';

  // Abrir la caja (base de datos)
  static Future<Box<Tarea>> getBox() async {
    return await Hive.openBox<Tarea>(boxName);
  }

  // Añadir
  static Future<void> agregarTarea(Tarea tarea) async {
    final box = await getBox();
    await box.put(tarea.id, tarea);
  }

  // Editar / Actualizar
  static Future<void> actualizarTarea(Tarea tarea) async {
    await tarea.save(); // Gracias a que extiende de HiveObject
  }

  // Eliminar múltiples
  static Future<void> eliminarTareas(List<String> ids) async {
    final box = await getBox();
    await box.deleteAll(ids);
  }
}