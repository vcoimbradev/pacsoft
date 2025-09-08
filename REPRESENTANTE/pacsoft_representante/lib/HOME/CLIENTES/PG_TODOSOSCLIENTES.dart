import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';
import 'package:pacsoft_representante/HOME/CLIENTES/PG_EDITARCLIENTE.dart';

class PgTodosClientes extends StatefulWidget {
  const PgTodosClientes({super.key});

  @override
  State<StatefulWidget> createState() => _PgTodosClientesState();
}

class _PgTodosClientesState extends State<PgTodosClientes> {
  // Lista de clientes (ilustrativa - será substituída pelos dados reais)
  final List<Map<String, String>> clientes = [
    {
      'razaoSocial': 'Coimbra embalagens',
      'cidade': 'Santo Antônio de Jesus',
    },
    {
      'razaoSocial': 'Neto Fest',
      'cidade': 'Amargosa',
    },
    {
      'razaoSocial': 'Distribuidora Edel',
      'cidade': 'Ubaíra',
    },
    {
      'razaoSocial': 'Albertino Pack',
      'cidade': 'Cruz das Almas',
    },
  ];

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
                      'Todos os Clientes',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Cabeçalho da tabela
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Razão social',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Cidade',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lista de clientes
                    ...clientes.map((cliente) {
                      return Container(
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(cliente['razaoSocial']!),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(cliente['cidade']!),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PgEditarCliente(), // Substitua pelo widget correto
                                    ),
                                  );
                                  // Ação de editar cliente
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
}