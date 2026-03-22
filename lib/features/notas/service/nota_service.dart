import 'package:hive_flutter/hive_flutter.dart';
import 'package:plantilla/features/notas/model/nota.dart';

class NotaService {
  static const String boxName = 'notasBox';

  static Future<Box<Nota>> getBox() async {
    return await Hive.openBox<Nota>(boxName);
  }

  static Future<void> agregarNota(Nota nota) async {
    final box = await getBox();
    await box.put(nota.id, nota);
  }

  static Future<void> actualizarNota(Nota nota) async {
    await nota.save();
  }

  static Future<void> eliminarNotas(List<String> ids) async {
    final box = await getBox();
    await box.deleteAll(ids);
  }
}
