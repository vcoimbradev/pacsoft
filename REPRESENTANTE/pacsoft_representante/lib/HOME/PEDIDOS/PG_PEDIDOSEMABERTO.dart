import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';
import 'package:hive/hive.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PG_PEDIDOS_INCOMPLETOS.dart';

class PgPedidosAbertos extends StatefulWidget {
  const PgPedidosAbertos({super.key});

  @override
  State<PgPedidosAbertos> createState() => _PgPedidosAbertosState();
}

class _PgPedidosAbertosState extends State<PgPedidosAbertos> {
  List<Map<String, dynamic>> _pedidos = [];
  final TextEditingController _filtroController = TextEditingController();
  String _ordenacaoData = 'none';

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    final box = await Hive.openBox('pedidos_em_aberto');
    setState(() {
      _pedidos = box.keys.map((key) {
        final pedido = Map<String, dynamic>.from(box.get(key) as Map);
        pedido['hiveKey'] = key; // Salva a chave do Hive
        // Conversão segura para Map<String, dynamic>
        // Converte data ISO para dd/mm/yyyy
        if (pedido['data'] != null && pedido['data'].contains('-')) {
          final data = DateTime.parse(pedido['data']);
          pedido['data'] = _formatarData(data);
        }
        // Também converta a lista de produtos, se necessário
        if (pedido['produtos'] != null && pedido['produtos'] is List) {
          pedido['produtos'] = (pedido['produtos'] as List)
              .map((p) => Map<String, dynamic>.from(p as Map))
              .toList();
        }
        return pedido;
      }).toList();
    });
  }

  String _formatarData(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  DateTime _parseData(String dateStr) {
    if (dateStr.contains('-')) {
      // Formato ISO, inclui segundos
      return DateTime.parse(dateStr);
    }
    // Formato dd/MM/yyyy
    final parts = dateStr.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  List<Map<String, dynamic>> get _pedidosFiltrados {
    List<Map<String, dynamic>> resultado = List.from(_pedidos);

    if (_filtroController.text.isNotEmpty) {
      resultado = resultado.where((pedido) =>
          pedido['razaoSocial'].toLowerCase().contains(_filtroController.text.toLowerCase()) ||
          pedido['cidade'].toLowerCase().contains(_filtroController.text.toLowerCase())
      ).toList();
    }

    if (_ordenacaoData != 'none') {
      resultado.sort((a, b) {
        final dateA = _parseData(a['data']);
        final dateB = _parseData(b['data']);
        return _ordenacaoData == 'desc' 
            ? dateB.compareTo(dateA)
            : dateA.compareTo(dateB);
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
                      'Pedidos em aberto',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
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
                              ],
                            ),
                          ),
                          ..._pedidosFiltrados.map((pedido) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PgPedidos_Incompletos(
                                    razao_social: pedido['razaoSocial'],
                                    cnpj: pedido['cnpj'],
                                    cidade: pedido['cidade'],
                                    idCliente: pedido['idCliente'],
                                    idRepresentante: pedido['idRepresentante'],
                                    pedidoAnterior: pedido,
                                    hiveKey: pedido['hiveKey'], // Passe a chave aqui
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(pedido['razaoSocial'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(pedido['cidade']),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(pedido['data']),
                                  ),
                                ],
                              ),
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