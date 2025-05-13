import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PgCadastroCliente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PgCadastroClienteState();
}

class _PgCadastroClienteState extends State<PgCadastroCliente> {
  final TextEditingController _razaoSocialController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _inscricaoEstadualController =
      TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeUfController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          Barra_pesquisa(),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Cadastrar Novo Cliente',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo Razão Social
                    _buildCampoTexto(
                      label: 'Razão social',
                      controller: _razaoSocialController,
                    ),

                    // Campo CNPJ
                    _buildCampoTexto(
                      label: 'CNPJ',
                      controller: _cnpjController,
                      keyboardType: TextInputType.number,
                    ),

                    // Campo Inscrição Estadual
                    _buildCampoTexto(
                      label: 'Insc. estadual',
                      controller: _inscricaoEstadualController,
                    ),

                    // Campo Endereço
                    _buildCampoTexto(
                      label: 'Endereço',
                      controller: _enderecoController,
                    ),

                    // Linha com Bairro e Cidade/UF
                    Row(
                      children: [
                        Expanded(
                          child: _buildCampoTexto(
                            label: 'Bairro',
                            controller: _bairroController,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildCampoTexto(
                            label: 'Cidade / UF',
                            controller: _cidadeUfController,
                            enabled: false, // Apenas este campo desabilitado
                          ),
                        ),
                      ],
                    ),

                    // Campo CEP
                    _buildCampoTexto(
                      label: 'CEP',
                      controller: _cepController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 8) {
                          _buscarCep(value);
                        }
                      },
                    ),

                    // Campo Email
                    _buildCampoTexto(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    // Campo Contato
                    _buildCampoTexto(
                      label: 'Contato',
                      controller: _contatoController,
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 30),

                    // Botões Inferiores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBotaoAcao(
                          texto: 'Cancelar cadastro',
                          icone: 'lixeira.png',
                        ),
                        _buildBotaoAcao(
                          texto: 'Salvar cadastro',
                          icone: 'disquete.png',
                          onPressed: () async {
                            final box = await Hive.openBox('clientes');
                            final key = DateTime.now()
                                .toString(); // Replace with a unique key generator
                            await box.put(key, {
                              'razao_social': _razaoSocialController.text,
                              'cnpj': _cnpjController.text,
                              'inscricaoEstadual':
                                  _inscricaoEstadualController.text,
                              'endereco': _enderecoController.text,
                              'bairro': _bairroController.text,
                              'cidade': _cidadeUfController.text,
                              'cep': _cepController.text,
                              'email': _emailController.text,
                              'contato': _contatoController.text,
                            });
                            Navigator.pop(
                                context); // Volta para a tela anterior (Todos os Clientes)
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: barra_inferior(),
    );
  }

  // Widget para campos de texto padronizados
  Widget _buildCampoTexto({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    bool enabled = true, // Adicionado parâmetro enabled
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              enabled: enabled, // Usando o parâmetro enabled
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para botões de ação
  Widget _buildBotaoAcao({
    required String texto,
    required String icone,
    Color? cor,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor ?? Colors.grey[200],
        foregroundColor: Colors.black,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/$icone', width: 40),
          Text(
            texto,
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buscarCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(jsonDecode(response.body));
        if (!data.containsKey('erro')) {
          setState(() {
            _bairroController.text = data['bairro'] ?? '';
            _cidadeUfController.text =
                '${data['localidade'] ?? ''} / ${data['uf'] ?? ''}';
            _enderecoController.text = data['logradouro'] ?? '';
          });
        }
      }
    } catch (e) {
      // Trate o erro conforme necessário
    }
  }
}
