import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgRelatorioPedidosMes extends StatefulWidget {
  const PgRelatorioPedidosMes({super.key, });

  @override
  State<PgRelatorioPedidosMes> createState() => _PgRelatorioPedidosMesState();
}

class _PgRelatorioPedidosMesState extends State<PgRelatorioPedidosMes> {
  // Datas para filtro
  DateTime _dataInicial = DateTime.now();
  DateTime _dataFinal = DateTime.now();
  
  // Controladores para os campos de data
  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();

  // Dados mockados (substituir pelos dados reais do banco)
  final List<Map<String, dynamic>> _pedidos = [
    {
      'razaoSocial': 'Coimbra embalagens',
      'data': '2025-04-08',
      'quantidadeKG': 1500,
      'valor': 17500.00,
      'status': 'Em aberto',
    },
    {
      'razaoSocial': 'Neto Fest',
      'data': '2025-04-04',
      'quantidadeKG': 3000,
      'valor': 38000.00,
      'status': 'Enviado',
    },
    {
      'razaoSocial': 'Distribuidora Edel',
      'data': '2025-03-17',
      'quantidadeKG': 2000,
      'valor': 25000.00,
      'status': 'Faturado',
    },
  ];

  // Lista de pedidos filtrados
  List<Map<String, dynamic>> _pedidosFiltrados = [];

  @override
  void initState() {
    super.initState();
    // Definir período padrão como mês atual (abril de 2025 conforme a imagem)
    _dataInicial = DateTime(2025, 4, 1);
    _dataFinal = DateTime(2025, 4, 30);
    _atualizarControladoresData();
    _filtrarPedidos();
  }

  @override
  void dispose() {
    _dataInicialController.dispose();
    _dataFinalController.dispose();
    super.dispose();
  }

  // Método para converter string no formato yyyy-MM-dd para DateTime
  DateTime _parseDataBanco(String dataStr) {
    return DateTime.parse(dataStr);
  }

  void _atualizarControladoresData() {
    _dataInicialController.text = DateFormat('dd/MM/yyyy').format(_dataInicial);
    _dataFinalController.text = DateFormat('dd/MM/yyyy').format(_dataFinal);
  }

  // Método para filtrar pedidos pelo período selecionado
  void _filtrarPedidos() {
    setState(() {
      _pedidosFiltrados = _pedidos.where((pedido) {
        final dataPedido = _parseDataBanco(pedido['data']);
        return dataPedido.isAfter(_dataInicial.subtract(const Duration(days: 1))) &&
               dataPedido.isBefore(_dataFinal.add(const Duration(days: 1)));
      }).toList();
    });
  }

  // Método para selecionar data
  Future<void> _selecionarData(BuildContext context, bool isInicial) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInicial ? _dataInicial : _dataFinal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        if (isInicial) {
          _dataInicial = picked;
        } else {
          _dataFinal = picked;
        }
        _atualizarControladoresData();
        _filtrarPedidos();
      });
    }
  }

  // Método para formatar valor monetário
  String _formatarMoeda(double valor) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);
  }

  // Método para obter cor do status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'em aberto':
        return Colors.orange;
      case 'enviado':
        return Colors.green;
      case 'faturado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Calcular valor total dos pedidos no período
  double get _valorTotal {
    return _pedidosFiltrados.fold(0, (sum, pedido) => sum + (pedido['valor'] as double));
  }

  // Gerar PDF do relatório
  Future<void> _gerarPDF() async {
    final pdf = pw.Document();
    final logo = await _getImageLogo();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Relatório de Pedidos\nPeríodo: ${_dataInicialController.text} a ${_dataFinalController.text}',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  if (logo != null)
                    pw.Image(logo, width: 100, height: 50),
                ],
              ),
              pw.SizedBox(height: 20),
              
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Razão Social', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Data', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Quantidade', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Valor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Status', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ..._pedidosFiltrados.map((pedido) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(pedido['razaoSocial']),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(DateFormat('dd/MM/yyyy').format(_parseDataBanco(pedido['data']))),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('${pedido['quantidadeKG']} KG'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(_formatarMoeda(pedido['valor'] as double)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromInt((_getStatusColor(pedido['status']).withOpacity(0.7)).value),
                            borderRadius: pw.BorderRadius.circular(12),
                          ),
                          child: pw.Text(
                            pedido['status'],
                            style: pw.TextStyle(color: PdfColors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total: ${_formatarMoeda(_valorTotal)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Pedidos encontrados: ${_pedidosFiltrados.length}',
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

  Future<pw.ImageProvider?> _getImageLogo() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/images/logo.png');
      return pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100, ),
      body: Column(
        children: [
          const Barra_pesquisa(),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pedidos do mês',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Seletor de período
                const Text(
                  'Pesquisar período',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dataInicialController,
                        decoration: InputDecoration(
                          labelText: 'De:',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selecionarData(context, true),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _dataFinalController,
                        decoration: InputDecoration(
                          labelText: 'Até:',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selecionarData(context, false),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: _filtrarPedidos,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Pesquisar'),
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 2),
          
          // Resultados
          if (_pedidosFiltrados.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedidos encontrados: ${_pedidosFiltrados.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total: ${_formatarMoeda(_valorTotal)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          
          // Lista de pedidos
          Expanded(
            child: _pedidosFiltrados.isEmpty
                ? const Center(
                    child: Text('Nenhum pedido encontrado no período selecionado'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _pedidosFiltrados.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidosFiltrados[index];
                      final dataPedido = _parseDataBanco(pedido['data']);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Razão social: ${pedido['razaoSocial']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Data:'),
                                  Text(DateFormat('dd/MM/yyyy').format(dataPedido)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Quantidade KG:'),
                                  Text('${pedido['quantidadeKG']} KG'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Valor R\$:'),
                                  Text(_formatarMoeda(pedido['valor'] as double)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Status:'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(pedido['status']),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      pedido['status'],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Botão para exportar PDF
          if (_pedidosFiltrados.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _gerarPDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Salvar em PDF'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: barra_inferior(),
    );
  }
}