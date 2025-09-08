import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgClientesInativos extends StatefulWidget {
  const PgClientesInativos({super.key});

  @override
  State<PgClientesInativos> createState() => _PgClientesInativosState();
}

class _PgClientesInativosState extends State<PgClientesInativos> {
  // Dados mockados com datas futuras para teste em 2025
  final List<Map<String, dynamic>> _todosClientes = [
    {
      'razaoSocial': 'Distribuidora Edel',
      'cidade': 'Ubaíra',
      'ultimoPedido': '26/11/2024', // Formato dd/MM/yyyy
      'cnpj': '00.000.000/0001-00',
    },
    {
      'razaoSocial': 'Albertino Pack',  
      'cidade': 'Cruz das Almas',
      'ultimoPedido': '29/03/2025',
      'cnpj': '11.111.111/0001-11',
    },
    {
      'razaoSocial': 'Coimbra Embalagens',
      'cidade': 'Santo Antônio de Jesus',
      'ultimoPedido': '05/12/2024',
      'cnpj': '22.222.222/0001-22',
    },
    {
      'razaoSocial': 'Teste Futuro',
      'cidade': 'Salvador',
      'ultimoPedido': '15/01/2025', // Cliente com pedido recente em 2025
      'cnpj': '33.333.333/0001-33',
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _clientesFiltrados = [];
  final DateTime _dataAtual = DateTime.now(); // Usa a data real do dispositivo

  @override
  void initState() {
    super.initState();
    _clientesFiltrados = _processarClientes(_todosClientes);
    _searchController.addListener(_filtrarClientes);
  }

  // Método para parsear data no formato dd/MM/yyyy
  DateTime _parseData(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  // Método para formatar data no formato dd/MM/yyyy
  String _formatarData(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Processa a lista de clientes adicionando dias sem pedido
  List<Map<String, dynamic>> _processarClientes(List<Map<String, dynamic>> clientes) {
    return clientes.map((cliente) {
      final ultimoPedido = _parseData(cliente['ultimoPedido']);
      final diferenca = _dataAtual.difference(ultimoPedido).inDays;
      
      return {
        ...cliente,
        'diasSemPedido': diferenca,
        'status': diferenca > 30 ? 'Inativo' : 'Ativo',
        'statusColor': diferenca > 30 ? Colors.orange : Colors.green,
      };
    }).where((cliente) => cliente['diasSemPedido'] > 30).toList();
  }

  void _filtrarClientes() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _clientesFiltrados = _processarClientes(_todosClientes);
        return;
      }

      _clientesFiltrados = _processarClientes(_todosClientes.where((cliente) {
        final nome = cliente['razaoSocial'].toString().toLowerCase();
        final cnpj = cliente['cnpj'].toString().replaceAll(RegExp(r'[^0-9]'), '');
        final cidade = cliente['cidade'].toString().toLowerCase();
        
        return nome.contains(query) || 
               cnpj.contains(query.replaceAll(RegExp(r'[^0-9]'), '')) ||
               cidade.contains(query);
      }).toList());
    });
  }

  Future<void> _gerarEPdf() async {
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
                  pw.Text('Clientes sem pedidos mais que 30 dias\n${_formatarData(_dataAtual)}',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  if (logo != null)
                    pw.Image(logo, width: 100, height: 50),
                ],
              ),
              pw.SizedBox(height: 20),
              
              if (_searchController.text.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text('Filtro aplicado: "${_searchController.text}"',
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                ),
              
              pw.Text('Data de referência: ${_formatarData(_dataAtual)}',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 10),
              
              pw.TableHelper.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: pw.BoxDecoration(color: PdfColors.blue800),
                data: [
                  ['Razão Social', 'Cidade', 'Último Pedido', 'Dias Sem Pedido'],
                  ..._clientesFiltrados.map((cliente) => [
                    cliente['razaoSocial'],
                    cliente['cidade'],
                    cliente['ultimoPedido'],
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: cliente['diasSemPedido'] > 60 ? PdfColors.red : PdfColors.orange,
                        borderRadius: pw.BorderRadius.circular(12),
                      ),
                      child: pw.Text(
                        cliente['diasSemPedido'].toString(),
                        style: pw.TextStyle(color: PdfColors.white),
                      ),
                    ),
                  ]),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total de clientes: ${_clientesFiltrados.length}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
                  'Clientes sem pedidos mais que 30 dias',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Data atual: ${_formatarData(_dataAtual)}',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar por nome, cidade ou CNPJ',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                
                if (_searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${_clientesFiltrados.length} resultados encontrados',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: _clientesFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Nenhum cliente inativo encontrado'),
                        SizedBox(height: 10),
                        Text(
                          'Data de referência: ${_formatarData(_dataAtual)}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
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
                                flex: 3,
                                child: Text('Razão Social', 
                                    style: TextStyle(fontWeight: FontWeight.w800)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Cidade', 
                                    style: TextStyle(fontWeight: FontWeight.w800)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Dias Sem Pedido', 
                                    style: TextStyle(fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                        ),
                        
                        // Lista de clientes
                        ..._clientesFiltrados.map((cliente) => Card(
                          margin: EdgeInsets.only(top: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cliente['razaoSocial'],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Último: ${cliente['ultimoPedido']}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(cliente['cidade']),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: cliente['statusColor'],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${cliente['diasSemPedido']} dias',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
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
    _searchController.removeListener(_filtrarClientes);
    _searchController.dispose();
    super.dispose();
  }
}