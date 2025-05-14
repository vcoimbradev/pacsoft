import 'package:hive/hive.dart';

class DBHelper {

  static String? Nomedorepresentante;

  // Inicializa todas as "tabelas" (boxes)
  static Future<void> inicializar() async {
    await Hive.openBox('representantes');
    await Hive.openBox('clientes');
    await Hive.openBox('pedidos');
    // Usuário de teste (representante)
    var reps = Hive.box('representantes');
    if (!reps.containsKey('12345678900')) {
      await reps.put('12345678900', {
        'nome': 'Representante Teste',
        'cpf': '12345678900',
        'cnpj': '00000000000199',
        'telefone': '11999999999',
        'agencia': '1234',
        'conta': '56789',
        'pix': '11999999999',
        'senha': 'senha123'
      });
    }
   
  }

  // Autenticação de representante
  static Future<bool> autenticar(String cpf, String senha) async {
    var reps = Hive.box('representantes');
    final rep = reps.get(cpf);
    if (rep != null && rep['senha'] == senha) {
      return true;
    }
    return false;
  }

  // Buscar cliente por CNPJ
  static Future<Map?> buscarCliente(String cnpj) async {
    var clientes = Hive.box('clientes');
    return clientes.get(cnpj);
  }

  // Adicionar novo representante
  static Future<void> adicionarRepresentante(Map<String, dynamic> rep) async {
    var reps = Hive.box('representantes');
    await reps.put(rep['cpf'], rep);
  }

  // Adicionar novo cliente
  static Future<void> adicionarCliente(Map<String, dynamic> cliente) async {
    var clientes = Hive.box('clientes');
    await clientes.put(cliente['cnpj'], cliente);
  }
  
    static Future<void> salvarPedido(Map<String, dynamic> pedido) async {
    var pedidos = Hive.box('pedidos');
    await pedidos.add(pedido);
  }
}