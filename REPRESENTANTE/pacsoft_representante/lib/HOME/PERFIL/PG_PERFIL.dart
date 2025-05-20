/*import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pacsoft_representante/APIs/servicos_api.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';
import 'package:pacsoft_representante/BANCODEDADOS.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pg_Perfil extends StatefulWidget {
  const Pg_Perfil({super.key,});
  

  @override
  State<Pg_Perfil> createState() => _Pg_PerfilState();
}

class _Pg_PerfilState extends State<Pg_Perfil> {
  Map<String, dynamic>? _dadosRep;
  bool _editando = false;
  bool _isLoading = true;

  final _telefoneController = TextEditingController();
  final _agenciaController = TextEditingController();
  final _contaController = TextEditingController();
  final _pixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/representante/${widget.cpfCnpj}'),
      );

      if (response.statusCode == 200) {
        final dados = json.decode(response.body);
        setState(() {
          _dadosRep = dados;
          _preencherControllers();
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar dados do representante');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
      );
    }
  }

  void _preencherControllers() {
    _telefoneController.text = _dadosRep?['telefone'] ?? '';
    _agenciaController.text = _dadosRep?['agencia'] ?? '';
    _contaController.text = _dadosRep?['conta'] ?? '';
    _pixController.text = _dadosRep?['pix'] ?? '';
  }

  Future<void> _salvarEdicao() async {
    try {
    final novo = {
      ..._dadosRep!,
      'telefone': _telefoneController.text,
      'agencia': _agenciaController.text,
      'conta': _contaController.text,
      'pix': _pixController.text,
    };
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/representante/${}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(novo),
      );

      if (response.statusCode == 200) {
        setState(() {
          _editando = false;
          _dadosRep = novo;
        });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dados atualizados com sucesso!')),
    );}
      else {
        throw Exception('Falha ao atualizar dados');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar dados: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: barra_superior(height: 100),
        body: Center(child: CircularProgressIndicator()),
        bottomNavigationBar: barra_inferior(),
      );
    }

    if (_dadosRep == null) {
      return Scaffold(
        appBar: barra_superior(height: 100),
        body: Center(child: Text('Erro ao carregar dados')),
        bottomNavigationBar: barra_inferior(),
      );
    }
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          Barra_pesquisa(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Perfil do Representante',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w900,
                          fontSize: 20)),
                  Icon(Icons.account_circle_outlined, size: 150),
                  SizedBox(height: 20),
                  if (_editando)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _salvarEdicao,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 165, 214, 167),
                            foregroundColor: Color.fromARGB(255, 0, 0, 0),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Salvar',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _editando = false;
                              // Restaura os valores originais
                              _telefoneController.text =
                                  _dadosRep!['telefone'] ?? '';
                              _agenciaController.text =
                                  _dadosRep!['agencia'] ?? '';
                              _contaController.text = _dadosRep!['conta'] ?? '';
                              _pixController.text = _dadosRep!['pix'] ?? '';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 165, 214, 167),
                            foregroundColor: Color.fromARGB(255, 0, 0, 0),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _editando = true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 165, 214, 167),
                        foregroundColor: Color.fromARGB(255, 0, 0, 0),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Editar',
                          style: TextStyle(
                              fontFamily: 'Lato', fontWeight: FontWeight.w700)),
                    ),
                  SizedBox(height: 20),
                  _buildInfoField('Nome Completo', _dadosRep!['nome']),
                  SizedBox(height: 15),
                  _buildInfoField('CPF', _dadosRep!['cpf']),
                  SizedBox(height: 15),
                  _buildInfoField('CNPJ', _dadosRep!['cnpj']),
                  SizedBox(height: 15),
                  _editando
                      ? _buildEditField('Telefone', _telefoneController)
                      : _buildInfoField('Telefone', _dadosRep!['telefone']),
                  SizedBox(height: 15),
                  _editando
                      ? _buildEditField('Agencia', _agenciaController)
                      : _buildInfoField('Agencia', _dadosRep!['agencia']),
                  SizedBox(height: 15),
                  _editando
                      ? _buildEditField('Conta Bancária', _contaController)
                      : _buildInfoField('Conta Bancária', _dadosRep!['conta']),
                  SizedBox(height: 15),
                  _editando
                      ? _buildEditField('Chave Pix', _pixController)
                      : _buildInfoField('Chave Pix', _dadosRep!['pix']),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: barra_inferior(),
    );
  }

  Widget _buildInfoField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextField(
            enabled: false,
            controller: TextEditingController(text: value ?? ''),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}*/
