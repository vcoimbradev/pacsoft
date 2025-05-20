import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pacsoft_representante/BANCODEDADOS.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS DE PESQUISAS E DO APP/Barra_superior.dart';
import 'package:pacsoft_representante/Components/OBSERVA%C3%87%C3%83O/Observacoes.dart';
import 'package:pacsoft_representante/Components/PESOS%20E%20QUANTIDADES/Peso_medio.dart';
import 'package:pacsoft_representante/Components/PESOS%20E%20QUANTIDADES/Tamanho_Pacote.dart';
import 'package:pacsoft_representante/Components/PRE%C3%87OS%20E%20VALOR%20MEDIO/valor_medio.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PgPedidoslista.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:html' as html;

//import 'package:pacsoft_representante/Components/BOT%C3%95ES/Botao_cancelar.dart';


class PgPedidos extends StatefulWidget {
  final String razao_social;
  final String cnpj;
  final String cidade;
  final String idCliente;
  final String idRepresentante;
  const PgPedidos({
    super.key,
    required this.razao_social,
    required this.cnpj,
    required this.cidade,
    required this.idCliente,
    required this.idRepresentante,
  });

  String? get tamanhoselecionado => null;

  set tamanhoselecionadoValue(String? tamanhoselecionadoValue) {}
  @override

  State<StatefulWidget> createState() => pginicialstate();
}

class pginicialstate extends State<PgPedidos> {
  String? pagamentoselecionado;
  List<Map<String, dynamic>> pedidos = [
    {
      'produto': null,
      'tamanho': null,
      'preco': null,
    } // Conjunto inicial de campos
  ];

  String nomeUsuario = '';

  @override
  void initState() {
    super.initState();
    _initControllersAndFocus();
    var reps = Hive.box('representantes');
    var rep = reps.get(DBHelper.Nomedorepresentante);
    if (rep != null) {
      setState(() {
        nomeUsuario = rep['nome'];
      });
    }
  }

  final List<TextEditingController> kgControllers = [];
  final List<TextEditingController> fardoControllers = [];
  final List<TextEditingController> milheiroControllers = [];
  final List<FocusNode> kgFocusNodes = [];
  final List<FocusNode> fardoFocusNodes = [];
  final List<FocusNode> milheiroFocusNodes = [];
  final TextEditingController prazoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  DateTime? prazoSelecionado;

  void _initControllersAndFocus() {
    for (int i = 0; i < pedidos.length; i++) {
      kgControllers.add(TextEditingController());
      fardoControllers.add(TextEditingController());
      milheiroControllers.add(TextEditingController());
      kgFocusNodes.add(FocusNode());
      fardoFocusNodes.add(FocusNode());
      milheiroFocusNodes.add(FocusNode());
      kgFocusNodes[i].addListener(() => _onKgFocusChange(i));
      fardoFocusNodes[i].addListener(() => _onFardoFocusChange(i));
      milheiroFocusNodes[i].addListener(() => _onMilheiroFocusChange(i));
    }
  }

  @override
  void dispose() {
    prazoController.dispose();
    for (final c in kgControllers) {
      c.dispose();
    }
    for (final c in fardoControllers) {
      c.dispose();
    }
    for (final c in milheiroControllers) {
      c.dispose();
    }
    for (final f in kgFocusNodes) {
      f.dispose();
    }
    for (final f in fardoFocusNodes) {
      f.dispose();
    }
    for (final f in milheiroFocusNodes) {
      f.dispose();
    }
    observacoesController.dispose();
    super.dispose();
  }

  // Funções de atualização ao perder o foco
  void _onKgFocusChange(int index) {
    if (!kgFocusNodes[index].hasFocus) {
      final pedido = pedidos[index];
      final kg =
          double.tryParse(kgControllers[index].text.replaceAll(',', '.'));
      final pesoFardo = getPesoPorFardo(pedido['produto'], pedido['tamanho']);
      if (kg == null || pesoFardo == null) {
        setState(() {
          pedido['quantidadeKg'] = null;
          pedido['quantidadeFardo'] = null;
          kgControllers[index].text = '';
          fardoControllers[index].text = '';
        });
        return;
      }
      setState(() {
        pedido['quantidadeKg'] = kg;
        pedido['quantidadeFardo'] = (kg / pesoFardo).ceil();
        fardoControllers[index].text = pedido['quantidadeFardo'].toString();
      });
    }
  }

  void _onFardoFocusChange(int index) {
    if (!fardoFocusNodes[index].hasFocus) {
      final pedido = pedidos[index];
      final fardos =
          int.tryParse(fardoControllers[index].text.replaceAll(',', '.'));
      final pesoFardo = getPesoPorFardo(pedido['produto'], pedido['tamanho']);
      if (fardos == null || pesoFardo == null) {
        setState(() {
          pedido['quantidadeFardo'] = null;
          pedido['quantidadeKg'] = null;
          pedido['quantidadeMilheiro'] = null;
          fardoControllers[index].text = '';
          kgControllers[index].text = '';
          milheiroControllers[index].text = '';
        });
        return;
      }
      setState(() {
        pedido['quantidadeFardo'] = fardos;
        if (pedido['produto'] == 'Sacola de Milheiro Verde') {
          pedido['quantidadeMilheiro'] = (fardos * pesoFardo).toDouble();
          milheiroControllers[index].text =
              pedido['quantidadeMilheiro'].toString();
          kgControllers[index].text = '';
          pedido['quantidadeKg'] = null;
        } else {
          pedido['quantidadeKg'] =
              double.parse((fardos * pesoFardo).toStringAsFixed(2));
          kgControllers[index].text = pedido['quantidadeKg'].toString();
          milheiroControllers[index].text = '';
          pedido['quantidadeMilheiro'] = null;
        }
      });
    }
  }

  void _onMilheiroFocusChange(int index) {
    if (!milheiroFocusNodes[index].hasFocus) {
      final pedido = pedidos[index];
      final mil =
          double.tryParse(milheiroControllers[index].text.replaceAll(',', '.'));
      final pesoFardo = getPesoPorFardo(pedido['produto'], pedido['tamanho']);
      if (mil == null || pesoFardo == null) {
        setState(() {
          pedido['quantidadeMilheiro'] = null;
          pedido['quantidadeFardo'] = null;
          milheiroControllers[index].text = '';
          fardoControllers[index].text = '';
        });
        return;
      }
      setState(() {
        pedido['quantidadeMilheiro'] = mil;
        pedido['quantidadeFardo'] = (mil / pesoFardo).ceil();
        fardoControllers[index].text = pedido['quantidadeFardo'].toString();
      });
    }
  }

  // Função para calcular o peso total
  double getPesoTotal() {
    double total = 0.0;
    for (var pedido in pedidos) {
      if (pedido['quantidadeKg'] != null) {
        total += pedido['quantidadeKg'];
      }
    }
    return total;
  }

  // Função para calcular o valor total
  double getValorTotal() {
    double total = 0.0;
    for (var pedido in pedidos) {
      double preco = pedido['preco'] ?? 0.0;
      if (pedido['produto'] == 'Sacola de Milheiro Verde') {
        double milheiros = pedido['quantidadeMilheiro'] ?? 0.0;
        total += preco * milheiros;
      } else {
        double kg = pedido['quantidadeKg'] ?? 0.0;
        total += preco * kg;
      }
    }
    return total;
  }

  // Mapa de pesos por fardo/milheiro
  final Map<String, Map<String, double>> pesosPorFardo = {
    'Bobina Picotada Fosca': {
      '20x30': 8.2,
      '25x35': 12.2,
      '30x40': 14.2,
      '35x50': 14.2,
      '40x60': 16.2,
      '50x70': 20.2,
      '60x80': 20.2,
      '80x100': 20.2,
      '80x120': 20.2,
      '90x120': 20.2,
    },
    'Bobina Picotada Fosca Especial': {
      '20x30': 8.2,
      '25x35': 9.6,
      '30x40': 10.8,
      '35x50': 10.0,
      '40x60': 11.0,
      '50x70': 12.0,
    },
    'Bobina Picotada Transparente': {
      '20x30': 8.2,
      '25x35': 12.2,
      '30x40': 14.2,
      '35x50': 14.2,
      '40x60': 16.2,
      '50x70': 20.2,
    },
    'Sacola de KG Branca': {
      '25x35': 20.0,
      '30x40': 20.0,
      '30x45': 20.0,
      '35x45': 20.0,
      '40x50': 20.0,
      '45x60': 20.0,
      '50x60': 20.0,
      '50x70': 20.0,
      '60x80': 20.0,
      '80x100': 20.0,
    },
    'Sacola de KG Transparente': {
      '25x35': 20.0,
      '30x40': 20.0,
      '40x50': 20.0,
      '50x60': 20.0,
    },
    // Para sacola de milheiro verde, o valor é milheiros por fardo
    'Sacola de Milheiro Verde': {
      '30x40': 5.0,
      '40x50': 5.0,
    },
  };

  // Função para obter o peso por fardo/milheiro
  double? getPesoPorFardo(String? produto, String? tamanho) {
    if (produto == null || tamanho == null) return null;
    return pesosPorFardo[produto]?[tamanho];
  }

  bool mostrartamanho(String? produtoselecionado) =>
      produtoselecionado == 'Bobina Picotada Fosca' ||
      produtoselecionado == 'Bobina Picotada Fosca Especial' ||
      produtoselecionado == 'Bobina Picotada Transparente' ||
      produtoselecionado == 'Sacola de KG Branca' ||
      produtoselecionado == 'Sacola de KG Transparente' ||
      produtoselecionado == 'Sacola de Milheiro Verde';

  void limparCampos() {
    setState(() {
      pedidos.clear();
      for (var c in kgControllers) {
        c.clear();
      }
      for (var c in fardoControllers) {
        c.clear();
      }
      for (var c in milheiroControllers) {
        c.clear();
      }
      // Limpe outros campos/controladores que você tiver, como prazoController, etc.
    });
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
                    controller: prazoController,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      hintText: 'Prazo de pagamento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: prazoSelecionado ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        locale: const Locale('pt', 'BR'),
                      );
                      if (picked != null) {
                        setState(() {
                          prazoSelecionado = picked;
                          prazoController.text =
                              "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                ...pedidos.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> pedido = entry.value;

                  String? produto = pedido['produto'];
                  String? tamanho = pedido['tamanho'];
                  double? pesoFardo = getPesoPorFardo(produto, tamanho);

                  bool isMilheiro = produto == 'Sacola de Milheiro Verde';

                  // Controladores para os campos
                  TextEditingController kgController = TextEditingController(
                    text: pedido['quantidadeKg']?.toString() ?? '',
                  );
                  TextEditingController fardoController = TextEditingController(
                    text: pedido['quantidadeFardo']?.toString() ?? '',
                  );
                  TextEditingController milheiroController =
                      TextEditingController(
                    text: pedido['quantidadeMilheiro']?.toString() ?? '',
                  );

                  // Função para atualizar KG ao mudar fardo
                  void onFardoChanged(String value) {
                    double? fardos =
                        double.tryParse(value.replaceAll(',', '.'));
                    if (fardos != null && pesoFardo != null) {
                      if (isMilheiro) {
                        pedido['quantidadeMilheiro'] = fardos * pesoFardo;
                        pedido['quantidadeFardo'] = fardos;
                      } else {
                        pedido['quantidadeKg'] =
                            (fardos * pesoFardo).toStringAsFixed(2);
                        pedido['quantidadeFardo'] = fardos;
                      }
                      setState(() {});
                    }
                  }

                  // Função para atualizar fardo ao mudar KG/Milheiro
                  void onKgOrMilheiroChanged(String value) {
                    double? quantidade =
                        double.tryParse(value.replaceAll(',', '.'));
                    if (quantidade != null && pesoFardo != null) {
                      if (isMilheiro) {
                        pedido['quantidadeFardo'] =
                            (quantidade / pesoFardo).ceil();
                        pedido['quantidadeMilheiro'] = quantidade;
                      } else {
                        pedido['quantidadeFardo'] =
                            (quantidade / pesoFardo).ceil();
                        pedido['quantidadeKg'] = quantidade;
                      }
                      setState(() {});
                    }
                  }

                  return Column(key: ValueKey(index), children: [
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
                        value: pedido['produto'],
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
                            value: 'Sacola de Milheiro Verde',
                            child: Text('Sacola de Milheiro Verde'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            pedido['produto'] = value;
                            pedido['tamanho'] = null;
                            pedido['quantidadeKg'] = null;
                            pedido['quantidadeFardo'] = null;
                            pedido['quantidadeMilheiro'] = null;
                          });
                        },
                      ),
                    ),
                    if (mostrartamanho(pedido['produto'])) ...[
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TamanhoPacote(
                              produtoSelecionado: pedido['produto'],
                              tamanhoSelecionado: pedido['tamanho'],
                              onChanged: (value) {
                                setState(() {
                                  pedido['tamanho'] = value;
                                  pedido['quantidadeKg'] = null;
                                  pedido['quantidadeFardo'] = null;
                                  pedido['quantidadeMilheiro'] = null;
                                  kgControllers[index].text = '';
                                  fardoControllers[index].text = '';
                                  milheiroControllers[index].text = '';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (pedido['produto'] == 'Sacola de Milheiro Verde') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Quantidade em milheiro:",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: TextField(
                                    controller: milheiroControllers[index],
                                    focusNode: milheiroFocusNodes[index],
                                    enabled: pedido['tamanho'] !=
                                        null, // Habilita só se selecionou tamanho
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Digite aqui',
                                      filled: true,
                                      fillColor: pedido['tamanho'] != null
                                          ? Colors.white
                                          : Colors.grey[300],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  "Quantidade em fardo:",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: TextField(
                                    controller: fardoControllers[index],
                                    focusNode: fardoFocusNodes[index],
                                    enabled: pedido['tamanho'] !=
                                        null, // Habilita só se selecionou tamanho
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Digite aqui',
                                      filled: true,
                                      fillColor: pedido['tamanho'] != null
                                          ? Colors.white
                                          : Colors.grey[300],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Quantidade em KG:",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: TextField(
                                    controller: kgControllers[index],
                                    focusNode: kgFocusNodes[index],
                                    enabled: pedido['tamanho'] !=
                                        null, // Habilita só se selecionou tamanho
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Digite aqui',
                                      filled: true,
                                      fillColor: pedido['tamanho'] != null
                                          ? Colors.white
                                          : Colors.grey[300],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  "Quantidade em fardo:",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: TextField(
                                    controller: fardoControllers[index],
                                    focusNode: fardoFocusNodes[index],
                                    enabled: pedido['tamanho'] !=
                                        null, // Habilita só se selecionou tamanho
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Digite aqui',
                                      filled: true,
                                      fillColor: pedido['tamanho'] != null
                                          ? Colors.white
                                          : Colors.grey[300],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 10),
                      Text(
                        "Preço em R\$:",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: TextField(
                          enabled: pedido['tamanho'] != null,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Digite o valor',
                            filled: true,
                            fillColor: pedido['tamanho'] != null
                                ? Colors.white
                                : Colors.grey[300],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                          onChanged: (value) {
                            setState(() {
                              pedido['preco'] =
                                  double.tryParse(value.replaceAll(',', '.')) ??
                                      0.0;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ]
                  ]);
                }),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pedidos.add({'produto': null, 'tamanho': null});
                      kgControllers.add(TextEditingController());
                      fardoControllers.add(TextEditingController());
                      milheiroControllers.add(TextEditingController());
                      kgFocusNodes.add(FocusNode()
                        ..addListener(
                            () => _onKgFocusChange(pedidos.length - 1)));
                      fardoFocusNodes.add(FocusNode()
                        ..addListener(
                            () => _onFardoFocusChange(pedidos.length - 1)));
                      milheiroFocusNodes.add(FocusNode()
                        ..addListener(
                            () => _onMilheiroFocusChange(pedidos.length - 1)));
                    });
                  },
                  child: Text('Adicionar mais produtos'),
                ),
                SizedBox(height: 20),
                Observacoes(
                  controller: observacoesController,
                ),
                SizedBox(height: 20),
                Pesomedio(
                  pesoTotal: getPesoTotal(),
                ),
                Valormedio(valorTotal: getValorTotal()),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        botao_cancelar(onPressed: limparCampos),
                      ],
                    ),
                    Column(
                      children: [
                        botao_guardar(onPressed: () {
                          final clienteMap = {
                            'razaoSocial': widget.razao_social,
                            'cnpj': widget.cnpj,
                            'cidade': widget.cidade,
                            'idCliente': widget.idCliente,
                            'idRepresentante': widget.idRepresentante,
                          };

                          guardarPedido({
                            ...clienteMap,
                            'data': DateTime.now().toIso8601String(),
                            'pagamento': pagamentoselecionado,
                            'prazo': prazoController.text,
                            'produtos': pedidos,
                            'observacoes': observacoesController.text,
                            'pesoTotal': getPesoTotal(),
                            'valorTotal': getValorTotal(),
                          });
                        }),
                      ],
                    ),
                    Column(
                      children: [
                        botao_confirmar(onPressed: _confirmarPedido),
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

  Future<void> _confirmarPedido() async {
    final clienteMap = await buscarClientePorId(widget.idCliente);
    final razao = clienteMap?['razao_social'] ??
        clienteMap?['razaoSocial'] ??
        widget.razao_social;
    final cidade =
        clienteMap?['cidade'] ?? clienteMap?['cidadeUf'] ?? widget.cidade;
    // 1. Gerar PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('pedido $razao - $cidade',
                  style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Text('Forma de pagamento: $pagamentoselecionado'),
              pw.Text('Prazo de pagamento: ${prazoController.text}'),
              pw.SizedBox(height: 8),
              pw.Text('Produtos:'),
              ...pedidos.map((pedido) => pw.Text(
                  'Produto: ${pedido['produto']}, Tamanho: ${pedido['tamanho']}, '
                  'KG: ${pedido['quantidadeKg'] ?? '-'}, Fardo: ${pedido['quantidadeFardo'] ?? '-'}, '
                  'Milheiro: ${pedido['quantidadeMilheiro'] ?? '-'}, Preço: R\$ ${pedido['preco'] ?? '-'}')),
              pw.SizedBox(height: 8),
              pw.Text(
                  'Peso médio total: ${getPesoTotal().toStringAsFixed(2)} KG'),
              pw.Text(
                  'Valor médio total: R\$ ${getValorTotal().toStringAsFixed(2)}'),
              pw.Text('Observações: ${observacoesController.text}'),
            ],
          );
        },
      ),
    );

    // 2. Perguntar ao usuário
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salvar e/ou Enviar Pedido'),
        content: Text(
            'Deseja salvar o PDF no dispositivo ou enviar por e-mail para a fábrica?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'salvar'),
            child: Text('Salvar no dispositivo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'enviar'),
            child: Text('Enviar por e-mail'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancelar'),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );

    if (result == 'salvar') {
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'pedido.pdf');
      Future<void> salvar(Map<String, dynamic> pedido) async {
       // 3. Salvar o pedido localmente (Hive)
    final box = await Hive.openBox('TodosPedidos');
    await box.add(pedido);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido salvo em aberto!')));
      }
    } else if (result == 'enviar') {
      // 1. Baixar o PDF automaticamente

      print('widget.cidade: ${widget.cidade}');
      print('clienteMap: $clienteMap');
      print('cidade usada: $cidade');

      final pdfBytes = await pdf.save();
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = 'pedido $razao - $cidade .pdf'
        ..style.display = 'none';
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      // 2. Abrir o Gmail/Outlook com assunto e corpo preenchidos

      final assunto =
          Uri.encodeComponent('Pedido - $nomeUsuario - $razao - $cidade');
      final corpo = Uri.encodeComponent('Segue pedido em anexo.');
      final email = 'testebagsoft@gmail.com';

      // Abre o Gmail já preenchido
      final gmailUrl =
          'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$assunto&body=$corpo';

      final escolha = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enviar por'),
          content: Text('Escolha o serviço de e-mail:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'gmail'),
              child: Text('Gmail'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'outlook'),
              child: Text('Outlook'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'cancelar'),
              child: Text('Cancelar'),
            ),
          ],
        ),
      );

      if (escolha == 'gmail') {
        html.window.open(gmailUrl, '_blank');
      } else if (escolha == 'outlook') {
        final outlookUrl =
            'https://outlook.live.com/mail/0/deeplink/compose?to=$email&subject=$assunto&body=$corpo';
        html.window.open(outlookUrl, '_blank');
      }

      // 3. Mensagem para o usuário
      await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Email'),
          content: Text('Anexe o PDF ao e-mail que foi aberto.'),
        ),
      );
    }

    // Monte o pedido igual ao que salva em aberto
    final pedidoParaSalvar = {
      'razaoSocial': widget.razao_social,
      'cnpj': widget.cnpj,
      'cidade': widget.cidade,
      'idCliente': widget.idCliente,
      'idRepresentante': widget.idRepresentante,
      'data': DateTime.now().toIso8601String(),
      'pagamento': pagamentoselecionado,
      'prazo': prazoController.text,
      'produtos': pedidos,
      'observacoes': observacoesController.text,
      'pesoTotal': getPesoTotal(),
      'valorTotal': getValorTotal(),
    };

    // Salva em todosPedidos
    final boxTodos = await Hive.openBox('todosPedidos');
    await boxTodos.add(pedidoParaSalvar);

    // (Opcional) Mostre uma mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido salvo em Todos os Pedidos!')),
    );
  }

  Future<void> guardarPedido(Map<String, dynamic> pedido) async {
    // 1. Gerar PDF com todas as informações
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Pedido em aberto', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Text('Razão Social: ${pedido['razaoSocial']}'),
              pw.Text('CNPJ: ${pedido['cnpj']}'),
              pw.Text('Cidade: ${pedido['cidade']}'),
              pw.Text('Data: ${pedido['data']}'),
              pw.Text('Forma de pagamento: ${pedido['pagamento'] ?? '-'}'),
              pw.Text('Prazo de pagamento: ${pedido['prazo'] ?? '-'}'),
              pw.SizedBox(height: 8),
              pw.Text('Produtos:'),
              ...((pedido['produtos'] as List).map((prod) => pw.Text(
                  'Produto: ${prod['produto']}, Tamanho: ${prod['tamanho']}, '
                  'KG: ${prod['quantidadeKg'] ?? '-'}, Fardo: ${prod['quantidadeFardo'] ?? '-'}, '
                  'Milheiro: ${prod['quantidadeMilheiro'] ?? '-'}, Preço: R\$ ${prod['preco'] ?? '-'}'))),
              pw.SizedBox(height: 8),
              pw.Text('Peso médio total: ${pedido['pesoTotal'].toStringAsFixed(2)} KG'),
              pw.Text('Valor médio total: R\$ ${pedido['valorTotal'].toStringAsFixed(2)}'),
              pw.Text('Observações: ${pedido['observacoes']}'),
            ],
          );
        },
      ),
    );

    // 2. Perguntar ao usuário se deseja salvar o PDF
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salvar Pedido'),
        content: Text('Deseja salvar o PDF no dispositivo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'salvar'),
            child: Text('Salvar PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'nao'),
            child: Text('Não salvar PDF'),
          ),
        ],
      ),
    );

    if (result == 'salvar') {
      await Printing.sharePdf(
          bytes: await pdf.save(), filename: 'pedido_em_aberto.pdf');
    }

    // 3. Salvar o pedido localmente (Hive)
    final box = await Hive.openBox('pedidos_em_aberto');
    await box.add(pedido);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido salvo em aberto!')),
    );
  }
}

class botao_confirmar extends StatelessWidget {
  final VoidCallback? onPressed;

  const botao_confirmar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
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
  final VoidCallback? onPressed;

  const botao_guardar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 10),
            foregroundColor: Color.fromARGB(255, 0, 0, 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/guardar.png', width: 50),
            Text("Guardar Pedido",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ))
          ],
        ));
  }
}

class botao_cancelar extends StatelessWidget {
  final VoidCallback? onPressed;

  const botao_cancelar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!(); // Call the passed callback
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>  //TODO: Substitua por NOME DE USUARIO
                  PgPedidosLista(), // Replace with an existing page
          ),
          (route) => false, // Remove todas as telas anteriores
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/cancelar.png', width: 50),
          Text("Cancelar Pedido",
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ))
        ],
      ),
    );
  }
}

Future<Map?> buscarClientePorId(String idCliente) async {
  final box = await Hive.openBox('clientes');
  // Se o idCliente for a chave do Hive:
  final cliente = box.get(idCliente);
  // Se não encontrar, tente buscar pelo campo 'id_cliente'
  if (cliente != null) return cliente;
  return box.values.cast<Map>().firstWhere(
        (c) => c['id_cliente'] == idCliente || c['idCliente'] == idCliente,
        orElse: () => {},
      );
}
