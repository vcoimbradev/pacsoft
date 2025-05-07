import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgEditarCliente extends StatefulWidget {
  const PgEditarCliente({super.key});

  @override
  State<StatefulWidget> createState() => _PgEditarClienteState();
}

class _PgEditarClienteState extends State<PgEditarCliente> {
  final TextEditingController _razaoSocialController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  // Adicione os outros controllers conforme necessário...

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
                      'Editar Cliente',
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
                      controller: TextEditingController(),
                    ),
                    
                    // Campo Endereço
                    _buildCampoTexto(
                      label: 'Endereço',
                      controller: TextEditingController(),
                    ),
                    
                    // Linha com Bairro e Cidade/UF
                    Row(
                      children: [
                        Expanded(
                          child: _buildCampoTexto(
                            label: 'Bairro',
                            controller: TextEditingController(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildCampoTexto(
                            label: 'Cidade / UF',
                            controller: TextEditingController(),
                          ),
                        ),
                      ],
                    ),
                    
                    // Campo CEP
                    _buildCampoTexto(
                      label: 'CEP',
                      controller: TextEditingController(),
                      keyboardType: TextInputType.number,
                    ),
                    
                    // Campo Email
                    _buildCampoTexto(
                      label: 'Email',
                      controller: TextEditingController(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    // Campo Contato
                    _buildCampoTexto(
                      label: 'Contato',
                      controller: TextEditingController(),
                      keyboardType: TextInputType.phone,
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Botões Inferiores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBotaoAcao(
                          texto: 'Cancelar Alteracão',
                          icone: 'lixeira.png',
                        ),
                        _buildBotaoAcao(
                          texto: 'Salvar Alteracão',
                          icone: 'disquete.png',
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
              controller: controller,
              keyboardType: keyboardType,
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
  }) {
    return ElevatedButton(
      onPressed: () {},
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
}