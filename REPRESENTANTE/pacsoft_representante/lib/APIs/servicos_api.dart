import 'package:http/http.dart' as http;
import 'dart:convert';

class ServicosApi {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> autenticarViaApi(String cpfCnpj, String senha) async {
    try {
      // 1. Faz autenticação
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cpfCnpj': cpfCnpj, 'senha': senha}),
      );

      if (loginResponse.statusCode != 200) {
        throw Exception('Erro no login: ${loginResponse.statusCode}');
      }

      final loginData = json.decode(loginResponse.body);
      
      if (!loginData['autenticado']) {
        return {'autenticado': false};
      }

      // 2. Se autenticado, busca dados completos
      final dadosResponse = await http.post(
        Uri.parse('$baseUrl/representantes/$cpfCnpj'),
      );

      if (dadosResponse.statusCode != 200) {
        throw Exception('Erro ao buscar dados: ${dadosResponse.statusCode}');
      }

      return {
        'autenticado': true,
        'nome': loginData['nome'],
        'dadosCompletos': json.decode(dadosResponse.body),
      };
    } catch (e) {
      throw Exception('Erro na comunicação: $e');
    }
  }

static Future<Map<String, dynamic>> getRepresentante(String cpfCnpj) async {
  final response = await http.post(
    Uri.parse('$baseUrl/representantes/$cpfCnpj'),
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falha ao carregar dados');
  }
}
}