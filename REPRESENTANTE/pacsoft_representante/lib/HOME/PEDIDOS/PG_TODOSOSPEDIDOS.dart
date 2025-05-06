import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgTodosPedidos extends StatefulWidget {
  const PgTodosPedidos({super.key});

  @override
  State<PgTodosPedidos> createState() => _PgTodosPedidosState();
}

class _PgTodosPedidosState extends State<PgTodosPedidos> {
  // Dados mockados (serão substituídos pelo banco)
  final List<Map<String, dynamic>> _pedidos = [
    {
      'razaoSocial': 'Coimbra embalagens',
      'cidade': 'Santo Antônio de Jesus',
      'data': '15/05/2024',
      'valor': 'R\$ 2.500,00'
    },
    {
      'razaoSocial': 'Neto Fest',
      'cidade': 'Amargosa',
      'data': '10/05/2024',
      'valor': 'R\$ 1.800,00'
    },
    {
      'razaoSocial': 'Distribuidora Edel',
      'cidade': 'Ubaíra',
      'data': '03/05/2024',
      'valor': 'R\$ 3.200,00'
    },
  ];

  // Controles
  final TextEditingController _filtroController = TextEditingController();
  String _ordenacaoData = 'none'; // 'asc', 'desc', 'none'

  // Formatar data (dd/MM/yyyy)
  String _formatarData(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Converter string para DateTime
  DateTime _parseData(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  // Lista filtrada e ordenada
  List<Map<String, dynamic>> get _pedidosFiltrados {
    List<Map<String, dynamic>> resultado = List.from(_pedidos);

    // Filtro por texto (Razão Social ou Cidade)
    if (_filtroController.text.isNotEmpty) {
      resultado = resultado.where((pedido) =>
          pedido['razaoSocial'].toLowerCase().contains(_filtroController.text.toLowerCase()) ||
          pedido['cidade'].toLowerCase().contains(_filtroController.text.toLowerCase())
      ).toList();
    }

    // Ordenação por data
    if (_ordenacaoData != 'none') {
      resultado.sort((a, b) {
        final dateA = _parseData(a['data']);
        final dateB = _parseData(b['data']);
        return _ordenacaoData == 'desc' 
            ? dateB.compareTo(dateA) // Mais recente primeiro
            : dateA.compareTo(dateB); // Mais antiga primeiro
      });
    }

    return resultado;
  }

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
                      'Todos os pedidos',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo de busca dinâmica
                    TextField(
                      controller: _filtroController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por Razão Social ou Cidade',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    SizedBox(height: 10),

                    // Botões de ordenação por data
                    Row(
                      children: [
                        Text('Ordenar por data:', style: TextStyle(fontWeight: FontWeight.w800)),
                        SizedBox(width: 10),
                        ChoiceChip(
                          label: Text('Mais recente'),
                          selected: _ordenacaoData == 'desc',
                          onSelected: (selected) {
                            setState(() {
                              _ordenacaoData = selected ? 'desc' : 'none';
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        ChoiceChip(
                          label: Text('Mais antiga'),
                          selected: _ordenacaoData == 'asc',
                          onSelected: (selected) {
                            setState(() {
                              _ordenacaoData = selected ? 'asc' : 'none';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Tabela de pedidos
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          // Cabeçalho
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text('Razão social', style: TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Cidade', style: TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Data', style: TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Valor', style: TextStyle(fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                          ),
                          
                          // Linhas de pedidos
                          ..._pedidosFiltrados.map((pedido) => Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    pedido['razaoSocial'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(pedido['cidade']),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(pedido['data']),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(pedido['valor']),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
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

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }
}