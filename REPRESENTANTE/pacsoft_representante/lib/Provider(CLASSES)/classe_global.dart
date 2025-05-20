import 'package:flutter/material.dart';
import 'package:pacsoft_representante/APIs/servicos_api.dart';

class ClasseGlobal extends ChangeNotifier {
  String? _nome;
  String? _cpfCnpj;
  Map<String, dynamic>? _dadosCompletos;
  bool _isLoading = false;

  // Getters
  String? get nome => _nome;
  String? get cpfCnpj => _cpfCnpj;
  Map<String, dynamic>? get dadosCompletos => _dadosCompletos;
  bool get isLoading => _isLoading;

  // Método de login
Future<void> login(String cpfCnpj, String senha) async {
  _isLoading = true;
  notifyListeners();

  try {
    final authResult = await ServicosApi.autenticarViaApi(cpfCnpj, senha);
    
    if (authResult['autenticado'] == true) {
      // Correção aqui - remova o segundo parâmetro
      final dados = await ServicosApi.getRepresentante(cpfCnpj);
      
      _nome = authResult['nome'];
      _cpfCnpj = cpfCnpj;
      _dadosCompletos = dados;
    } else {
      throw Exception('Credenciais inválidas');
    }
  } catch (e) {
    _nome = null;
    _cpfCnpj = null;
    _dadosCompletos = null;
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Método para logout
  void logout() {
    _nome = null;
    _cpfCnpj = null;
    _dadosCompletos = null;
    notifyListeners();
  }
}