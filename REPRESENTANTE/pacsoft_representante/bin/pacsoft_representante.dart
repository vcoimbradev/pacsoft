import 'dart:convert';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

// Middleware para habilitar CORS
Response _cors(Response response) {
  return response.change(headers: {
    'Access-Control-Allow-Origin': '*', // Permite todas as origens
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS', // Métodos permitidos
    'Access-Control-Allow-Headers': 'Content-Type', // Cabeçalhos permitidos
    ...response.headers,
  });
}

Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        // Responde a requisições OPTIONS diretamente
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        });
      }
      final response = await handler(request);
      return _cors(response);
    };
  };
}

// Conexão com o banco de dados
Future<MySqlConnection> conectarBanco() async {
  final configPath = 'c:\\Users\\ingri\\Desktop\\Nova pasta\\pacsoft\\REPRESENTANTE\\pacsoft_representante\\bin\\config.json';
  final configFile = File(configPath);
  print('Caminho do arquivo config.json: $configPath');

   if (!await configFile.exists()) {
    throw Exception('Arquivo config.json não encontrado. Verifique o caminho.');
  }

  final config = jsonDecode(await configFile.readAsString());

  var settings = ConnectionSettings(
    host: config['db_host'],
    port: config['db_port'],
    user: config['db_user'],
    password: config['db_password'],
    db: config['db_name'],
  );

  return MySqlConnection.connect(settings);
}

// Função de login
Future<Response> login(Request request) async {
  final conn = await conectarBanco();
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    // Validação dos dados recebidos
    if (data['cnpj_cpf'] == null || data['senha'] == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Dados incompletos ou inválidos'}));
    }

    final cnpjCpf = data['cnpj_cpf'] as String;
    final senha = data['senha'] as String;

    var results = await conn.query(
      'SELECT * FROM representantes WHERE (cnpj = ? OR cpf = 12345678900) AND senha = senhaSegura123',
      [cnpjCpf, cnpjCpf, senha],
    );

    if (results.isNotEmpty) {
      return Response.ok(jsonEncode({'status': 'sucesso'}), headers: {
        'Content-Type': 'application/json',
      });
    } else {
      return Response.forbidden(jsonEncode({'message': 'Usuário ou senha inválidos'}));
    }
  } catch (e) {
    return Response.internalServerError(body: 'Erro ao processar login: $e');
  } finally {
    await conn.close();
  }
}

Future<Response> inserirDados(Request request) async {
  final conn = await conectarBanco();
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final razaoSocial = data['razao_social'];
    final cnpj = data['cnpj'];
    final inscricaoEstadual = data['inscricao_estadual'];
    final endereco = data['endereco'];
    final bairro = data['bairro'];
    final cidade = data['cidade'];
    final estado = data['estado'];
    final cep = data['cep'];
    final email = data['email'];
    final contato = data['contato'];

    await conn.query(
      'INSERT INTO clientes (razao_social, cnpj, inscricao_estadual, endereco, bairro, cidade, estado, cep, email, telefone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [razaoSocial, cnpj, inscricaoEstadual, endereco, bairro, cidade, estado, cep, email, contato],
    );

    return Response.ok(jsonEncode({'status': 'sucesso'}), headers: {
      'Content-Type': 'application/json',
    });
  } catch (e) {
    return Response.internalServerError(body: 'Erro ao inserir dados: $e');
  } finally {
    await conn.close();
  }
}

// Rotas de login
shelf_router.Router criarRotas() {
  final router = shelf_router.Router();

  router.post('/login2', login);
  router.post('/inserir_cliente', inserirDados);

  return router;
}

void main() async {
  final handler = const Pipeline()
      .addMiddleware(logRequests()) // Middleware para log
      .addMiddleware(corsMiddleware()) // Middleware para CORS
      .addHandler(criarRotas());

  final server = await serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}