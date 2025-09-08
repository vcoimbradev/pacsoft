import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgTodosPedidosRelatorio extends StatefulWidget {
  const PgTodosPedidosRelatorio({super.key});

  @override
  State<PgTodosPedidosRelatorio> createState() => _PgTodosPedidosRelatorioState();
}

class _PgTodosPedidosRelatorioState extends State<PgTodosPedidosRelatorio> {
  final List<Map<String, dynamic>> _todosPedidos = [
    {
      'razaoSocial': 'Coimbra embalagens',
      'cnpj': '00.000.000/0001-00',
      'data': '08/04/2025',
      'quantidadeKG': '1500KG',
      'valor': 'R\$ 17.500,00',
      'status': 'Em aberto',
    },
    {
      'razaoSocial': 'Distribuidora Edel',
      'cnpj': '11.111.111/0001-11',
      'data': '17/07/2024',
      'quantidadeKG': '2000KG',
      'valor': 'R\$ 25.000,00',
      'status': 'Enviado',
    },
    {
      'razaoSocial': 'Albertino Pack',
      'cnpj': '22.222.222/0001-22',
      'data': '15/03/2024',
      'quantidadeKG': '1800KG',
      'valor': 'R\$ 20.000,00',
      'status': 'Faturado',
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _pedidosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _pedidosFiltrados = _todosPedidos.map(_adicionarCorStatus).toList();
    _searchController.addListener(_filtrarPedidos);
  }

  // Adiciona cor conforme o status
  Map<String, dynamic> _adicionarCorStatus(Map<String, dynamic> pedido) {
    final status = pedido['status'].toString().toLowerCase();
    Color statusColor;
    
    if (status.contains('aberto')) {
      statusColor = Colors.yellow[700]!;
    } else if (status.contains('enviado')) {
      statusColor = Colors.green;
    } else if (status.contains('faturado')) {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.grey;
    }
    
    return {...pedido, 'statusColor': statusColor};
  }

  void _filtrarPedidos() {
    final query = _searchController.text.trim();
    
    setState(() {
      if (query.isEmpty) {
        _pedidosFiltrados = _todosPedidos.map(_adicionarCorStatus).toList();
        return;
      }

      // Verifica se a query é numérica (CNPJ) ou textual (Nome)
      final isNumerico = RegExp(r'^[0-9]+$').hasMatch(query);
      
      _pedidosFiltrados = _todosPedidos.where((pedido) {
        if (isNumerico) {
          // Busca por CNPJ (remove formatação)
          final cnpj = pedido['cnpj'].toString().replaceAll(RegExp(r'[^0-9]'), '');
          return cnpj.contains(query);
        } else {
          // Busca por nome (case insensitive)
          final nome = pedido['razaoSocial'].toString().toLowerCase();
          return nome.contains(query.toLowerCase());
        }
      }).map(_adicionarCorStatus).toList();
    });
  }

  Future<void> _gerarEPdf() async {
    final pdf = pw.Document();
    final logo = await _getImageLogo();

    // Agrupa pedidos por CNPJ
    final Map<String, List<Map<String, dynamic>>> pedidosPorCliente = {};
    for (var pedido in _pedidosFiltrados) {
      final cnpj = pedido['cnpj'];
      pedidosPorCliente.putIfAbsent(cnpj, () => []).add(pedido);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Relatório de Pedidos\n${_formatarDataPdf(DateTime.now())}',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  if (logo != null)
                    pw.Image(logo, width: 100, height: 50),
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Filtro aplicado
              if (_searchController.text.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text('Filtro aplicado: "${_searchController.text}"',
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                ),
              
              // Lista por cliente
              ...pedidosPorCliente.entries.map((entry) {
                final cnpj = entry.key;
                final pedidos = entry.value;
                final cliente = pedidos.first['razaoSocial'];
                
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Dados do Cliente
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                        color: PdfColors.grey100,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Cliente: $cliente',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('CNPJ: $cnpj'),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    
                    // Tabela de pedidos do cliente
                    pw.TableHelper.fromTextArray(
                      context: context,
                      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                      headerDecoration: pw.BoxDecoration(color: PdfColors.blue800),
                      data: [
                        ['Data', 'Quantidade (KG)', 'Valor (R\$)', 'Status'],
                        ...pedidos.map((pedido) => [
                          pedido['data'],
                          pedido['quantidadeKG'],
                          pedido['valor'],
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: pw.BoxDecoration(
                              color: _getPdfStatusColor(pedido['status']),
                              borderRadius: pw.BorderRadius.circular(12),
                            ),
                            child: pw.Text(
                              pedido['status'],
                              style: pw.TextStyle(color: PdfColors.white),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    
                    // Total por cliente
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Total deste cliente: ${_calcularTotal(pedidos)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 30),
                  ],
                );
              }),
              
              // Total geral
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'TOTAL GERAL: ${_calcularTotal(_pedidosFiltrados)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                      color: PdfColors.blue800,
                    ),
                  ),
                ],
              ),
              pw.Text(
                'Clientes: ${pedidosPorCliente.length} | Pedidos: ${_pedidosFiltrados.length}',
                style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  PdfColor _getPdfStatusColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('aberto')) {
      return PdfColors.yellow;
    } else if (statusLower.contains('enviado')) {
      return PdfColors.green;
    } else if (statusLower.contains('faturado')) {
      return PdfColors.blue;
    } else {
      return PdfColors.grey;
    }
  }

  Future<pw.ImageProvider?> _getImageLogo() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/images/logo.png');
      return pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      return null;
    }
  }

  String _formatarDataPdf(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _calcularTotal(List<Map<String, dynamic>> pedidos) {
    double total = pedidos.fold(0, (sum, pedido) {
      final valor = double.tryParse(pedido['valor'].replaceAll(RegExp(r'[^0-9,]'), '').replaceAll(',', '.')) ?? 0;
      return sum + valor;
    });
    return 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [

          Barra_pesquisa(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                
                // Campo de pesquisa
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Digite o nome do cliente ou CNPJ',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 8),
                
                // Info sobre o que foi digitado
                if (_searchController.text.isNotEmpty)
                  Text(
                    _searchController.text.contains(RegExp(r'[0-9]'))
                        ? 'Pesquisando por CNPJ'
                        : 'Pesquisando por nome',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                
                // Exibe CNPJ se houver apenas um cliente nos resultados
                if (_pedidosFiltrados.isNotEmpty && 
                    _pedidosFiltrados.map((e) => e['cnpj']).toSet().length == 1)
                  Text(
                    'CNPJ: ${_pedidosFiltrados.first['cnpj']}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
          
          // Lista de pedidos
          Expanded(
            child: _pedidosFiltrados.isEmpty
                ? Center(child: Text('Nenhum pedido encontrado'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          'Pedidos encontrados: ${_pedidosFiltrados.length}',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // Cards de pedidos
                        ..._pedidosFiltrados.map((pedido) => Card(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Razão Social e CNPJ
                                Text(
                                  'Cliente: ${pedido['razaoSocial']}',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'CNPJ: ${pedido['cnpj']}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 12),
                                
                                // Detalhes em linhas
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Data:',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(pedido['data']),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quantidade KG:',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(pedido['quantidadeKG']),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Valor R\$:',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(pedido['valor']),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status:',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: pedido['statusColor'],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            pedido['status'],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        
                        // Botão para gerar PDF
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton.icon(
                            onPressed: _gerarEPdf,
                            icon: Icon(Icons.picture_as_pdf),
                            label: Text('Salvar em PDF'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ),
                      ],
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
    _searchController.removeListener(_filtrarPedidos);
    _searchController.dispose();
    super.dispose();
  }
}