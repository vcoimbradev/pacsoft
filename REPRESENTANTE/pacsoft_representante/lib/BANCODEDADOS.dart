import 'package:hive/hive.dart';

class DBHelper {
  static Future<void> inicializar() async {
    await Hive.openBox('usuarios');
    var box = Hive.box('usuarios');
    // Usuário de teste (só adiciona se não existir)
    if (!box.containsKey('12345678900')) {
      await box.put('12345678900', 'senha123');
    }
  }

  static Future<bool> autenticar(String cnpjCpf, String senha) async {
    var box = Hive.box('usuarios');
    final senhaSalva = box.get(cnpjCpf);
    return senhaSalva == senha;
  }
}