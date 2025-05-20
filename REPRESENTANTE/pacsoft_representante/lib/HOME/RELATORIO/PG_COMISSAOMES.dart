import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgComissaoMes extends StatefulWidget {
  const PgComissaoMes({super.key, });

  @override
  State<PgComissaoMes> createState() => _PgComissaoMesState();
}

class _PgComissaoMesState extends State<PgComissaoMes> {
  // Variáveis para controle das datas
  DateTime _dataInicial = DateTime.now();
  DateTime _dataFinal = DateTime.now();
  final double _taxaComissao = 0.03; // 3% - pode ser ajustado ou vindo do banco

  // Dados mockados com datas no formato yyyy-MM-dd (como virá do banco)
  final List<Map<String, dynamic>> _pedidos = [
    {
      'razaoSocial': 'Coimbra embalagens',
      'data': '2025-04-08',
      'valor': 17500.00,
    },
    {
      'razaoSocial': 'Neto Fest',
      'data': '2025-04-04',
      'valor': 38000.00,
    },
  ];

  // Controladores para os campos de data
  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Definir o mês atual como padrão (abril de 2025 conforme a imagem)
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

  // Lista de pedidos filtrados
  List<Map<String, dynamic>> _pedidosFiltrados = [];

  // Calcular valor total dos pedidos no período
  double get _valorTotal {
    return _pedidosFiltrados.fold(0, (sum, pedido) => sum + (pedido['valor'] as double));
  }

  // Calcular valor da comissão
  double get _valorComissao {
    return _valorTotal * _taxaComissao;
  }

  // Método para formatar valor monetário
  String _formatarMoeda(double valor) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);
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
                  pw.Text('Relatório de Comissão\nPeríodo: ${_dataInicialController.text} a ${_dataFinalController.text}',
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
                        child: pw.Text('Valor R\$', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                        child: pw.Text(_formatarMoeda(pedido['valor'] as double)),
                      ),
                    ],
                  )),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Valor total: ${_formatarMoeda(_valorTotal)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Text('Comissão (${(_taxaComissao * 100).toStringAsFixed(0)}%): ${_formatarMoeda(_valorComissao)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                    ],
                  ),
                ],
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
                  'Comissão por mês',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                
                // Seção de pesquisa por período
                Text(
                  'Pesquisar período',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dataInicialController,
                        decoration: InputDecoration(
                          labelText: 'De:',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selecionarData(context, true),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _dataFinalController,
                        decoration: InputDecoration(
                          labelText: 'Até:',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selecionarData(context, false),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: _filtrarPedidos,
                  child: Text('Pesquisar'),
                ),
              ],
            ),
          ),
          
          Divider(thickness: 2),
          
          // Lista de pedidos
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Cabeçalho da tabela
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Razão Social', 
                              style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                        Expanded(
                          child: Text('Data', 
                              style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                        Expanded(
                          child: Text('Valor R\$', 
                              style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                  
                  // Lista de pedidos
                  ..._pedidosFiltrados.map((pedido) => Card(
                    margin: EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              pedido['razaoSocial'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_parseDataBanco(pedido['data'])),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _formatarMoeda(pedido['valor'] as double),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  
                  // Totais
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Divider(thickness: 2),
                        SizedBox(height: 10),
                        Text(
                          'Valor total R\$: ${_formatarMoeda(_valorTotal)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Valor da comissão R\$: ${_formatarMoeda(_valorComissao)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // Botão para gerar PDF
                        ElevatedButton.icon(
                          onPressed: _gerarPDF,
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text('Salvar em PDF'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: barra_inferior( // Adicione o nome do usuário aqui
      ),
    );
  }
}