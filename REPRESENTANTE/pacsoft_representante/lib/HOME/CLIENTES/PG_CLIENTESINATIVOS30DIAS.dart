import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';

class PgClientesInativosFigma extends StatefulWidget {
  const PgClientesInativosFigma({super.key});

  @override
  State<PgClientesInativosFigma> createState() => _PgClientesInativosFigmaState();
}

class _PgClientesInativosFigmaState extends State<PgClientesInativosFigma> {
  // Dados mockados conforme a imagem
  final List<Map<String, dynamic>> _clientes = [
    {
      'razaoSocial': 'Distribuidora Edel',
      'cidade': 'Ubaira',
      'ultimoPedido': '25/11/2024',
    },
    {
      'razaoSocial': 'Albertino Pack',
      'cidade': 'Cruz das Almas',
      'ultimoPedido': '15/10/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          // Barra de pesquisa (mantendo o mesmo componente)
          Barra_pesquisa(),
          
          // Conteúdo principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Text(
                    'Clientes sem pedidos em 30 dias',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Subtítulo
                  const Text(
                    'Razão social',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Lista de clientes
                  Expanded(
                    child: ListView.separated(
                      itemCount: _clientes.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final cliente = _clientes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Razão social em negrito
                              Text(
                                cliente['razaoSocial'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              
                              // Cidade e data
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cliente['cidade'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Último pedido: ${cliente['ultimoPedido']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Barra inferior (mantendo o mesmo componente)
      bottomNavigationBar: barra_inferior(),
    );
  }
}