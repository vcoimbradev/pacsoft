import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/Barra_superior.dart';
import 'package:pacsoft_representante/Components/Observacoes.dart';
import 'package:pacsoft_representante/Components/Peso_medio.dart';
import 'package:pacsoft_representante/Components/Preco.dart';
import 'package:pacsoft_representante/Components/Quantidade_KG.dart';
import 'package:pacsoft_representante/Components/Quantidade_fardo.dart';
import 'package:pacsoft_representante/Components/Tamanho_Pacote.dart';
import 'package:pacsoft_representante/Components/valor_medio.dart';

class PgPedidos extends StatefulWidget {
  const PgPedidos({super.key});

  String? get tamanhoselecionado => null;

  set tamanhoselecionadoValue(String? tamanhoselecionadoValue) {}

  @override
  State<StatefulWidget> createState() {
    return pginicialstate();
  }
}

class pginicialstate extends State<PgPedidos> {
  String? pagamentoselecionado;
  List<Map<String, dynamic>> pedidos = [
    {'produto': null, 'tamanho': null, } // Conjunto inicial de campos
  ];

  bool mostrartamanho(String? produtoselecionado) =>
      produtoselecionado == 'Bobina Picotada Fosca' ||
      produtoselecionado == 'Bobina Picotada Fosca Especial' ||
      produtoselecionado == 'Bobina Picotada Transparente' ||
      produtoselecionado == 'Sacola de KG Branca' ||
      produtoselecionado == 'Sacola de KG Transparente' ||
      produtoselecionado == 'Sacola de Milhero Verde';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          Barra_pesquisa(),
          Flexible(
              child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
              Text(
                'Novo Pedido',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Column(children: [
                Text('Forma de Pagamento'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "avista",
                      groupValue: pagamentoselecionado,
                      onChanged: (value) {
                        setState(() {
                          pagamentoselecionado = value;
                        });
                      },
                    ),
                    Text(
                      'À vista',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 20),
                    Radio<String>(
                      value: 'boleto',
                      groupValue: pagamentoselecionado,
                      onChanged: (value) {
                        setState(() {
                          pagamentoselecionado = value;
                        });
                      },
                    ),
                    Text(
                      'Boleto',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 20),
                    Radio<String>(
                      value: 'cheque',
                      groupValue: pagamentoselecionado,
                      onChanged: (value) {
                        setState(() {
                          pagamentoselecionado = value;
                        });
                      },
                    ),
                    Text(
                      'Cheque',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextField(
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      hintText: 'Prazo de pagamento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ...pedidos.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> pedido = entry.value;

                  return Column(
                    key: ValueKey(index), // Chave única para cada item
                    children: [
                      Text(
                        'Selecione o tipo:',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        height: 50,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            hintText: 'Selecione o tipo de pedido',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Bobina Picotada Fosca',
                              child: Text('Bobina Picotada Fosca'),
                            ),
                            DropdownMenuItem(
                              value: 'Bobina Picotada Fosca Especial',
                              child: Text('Bobina Picotada Fosca Especial'),
                            ),
                            DropdownMenuItem(
                              value: 'Bobina Picotada Transparente',
                              child: Text('Bobina Picotada Transparente'),
                            ),
                            DropdownMenuItem(
                              value: 'Sacola de KG Branca',
                              child: Text('Sacola de KG Branca'),
                            ),
                            DropdownMenuItem(
                              value: 'Sacola de KG Transparente',
                              child: Text('Sacola de KG Transparente'),
                            ),
                            DropdownMenuItem(
                              value: 'Sacola de Milhero Verde',
                              child: Text('Sacola de Milhero Verde'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              pedido['produto'] = value;
                            });
                          },
                        ),
                      ),
                      if (mostrartamanho(pedido['produto'])) ...[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TamanhoPacote(
                              produtoSelecionado: pedido['produto'],
                            ),
                            QuantidadeKg(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            QuantidadeFardo(),
                            Preco(),
                          ],
                        ),
                      ],
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pedidos.add({'produto': null, 'tamanho': null});
                    });
                  },
                  child: Text('Adicionar mais produtos'),
                ),
                SizedBox(height: 20),
                Observacoes(),
                SizedBox(height: 20),
                Pesomedio(),
                Valormedio(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        botao_confirmar(),
                      ],
                    ),
                    Column(
                      children: [
                        botao_guardar(),
                      ],
                    ),
                    Column(
                      children: [
                        botao_cancelar(),
                      ],
                    ),
                  ],
                ),
              ]),
            ]),
          ))
        ],
      ),
      bottomNavigationBar: barra_inferior(),
    );
  }
}

class botao_confirmar extends StatelessWidget {
  const botao_confirmar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 10),
            foregroundColor: Color.fromARGB(255, 0, 0, 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/confirmar.png', width: 50),
            Text(
              "Confirmar Pedido",
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ));
  }
}

class botao_guardar extends StatelessWidget {
  const botao_guardar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 10),
            foregroundColor: Color.fromARGB(255, 0, 0, 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/guardar.png', width: 50),
            Text(
              "Guardar Pedido",
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ));
  }
}

class botao_cancelar extends StatelessWidget {
  const botao_cancelar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 10),
            foregroundColor: Color.fromARGB(255, 0, 0, 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/cancelar.png', width: 50),
            Text(
              "Cancelar Pedido",
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ));
  }
}
