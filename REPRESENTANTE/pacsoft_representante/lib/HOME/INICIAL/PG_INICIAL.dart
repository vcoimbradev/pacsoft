import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PG_PEDIDOSEMABERTO.dart';
import 'package:pacsoft_representante/HOME/RELATORIO/PG_TODOSOSPEDIDOSMES.dart';
import 'package:pacsoft_representante/Provider(CLASSES)/classe_global.dart';
import 'package:provider/provider.dart'; // Exemplo

class PgInicial extends StatefulWidget {

  const PgInicial({super.key,});

  @override
  State<StatefulWidget> createState() => pginicialstage();
}



class pginicialstage extends State<PgInicial> {
  String nomeUsuario = '';

  @override
  Widget build(BuildContext context) {

    final classeglobal = Provider.of<ClasseGlobal>(context);

    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          Barra_pesquisa(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Bem Vindo, ${classeglobal.nome}",
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Column(
                    children: [
                      Text(
                        "Atalhos",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  // =============== ATALHOS CLICÁVEIS ===============
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ATALHO 1: ÚLTIMOS PEDIDOS
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PgRelatorioPedidosMes(), // Substitua pela sua tela
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/tempo.png', width: 80),
                              const Text(
                                "Últimos pedidos",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ATALHO 2: PEDIDOS PENDENTES

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PgPedidosAbertos(), // Substitua pela sua tela
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/pendente.png',
                                  width: 80),
                              const Text(
                                "Pedidos pendentes",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  // =============== ATALHOS CLICÁVEIS ===============
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ATALHO 3: PREÇOS
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                          },
                         
                          child: Column(
                            children: [
                              Image.asset('assets/images/comissao.png',
                                  width: 80),
                              const Text(
                                "Comissão",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 30),

                  Container(
                    child: Column(
                      children: [
                        const Divider(thickness: 2, color: Colors.black),
                        const SizedBox(height: 10),
                        const Text(
                          'Resumo do mês',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Total de\npedidos',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '25',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 50,
                                    color: Colors.green[200],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Pedidos em\naberto',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '12',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 50,
                                    color: Colors.green[200],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Pedidos\nentregues',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '13',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 50,
                                    color: Colors.green[200],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
      bottomNavigationBar: barra_inferior(),
    );
  }
}