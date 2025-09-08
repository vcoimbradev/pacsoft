import 'package:flutter/material.dart';

class TamanhoPacote extends StatefulWidget {

final String? produtoSelecionado; // Recebe o produto selecionado

const TamanhoPacote({super.key, required this.produtoSelecionado});

  @override
  State<StatefulWidget> createState() {
    return tamanhosstate();
  }
}

class tamanhosstate extends State<TamanhoPacote> {
  String? tamanhoselecionado;

  @override
  void didUpdateWidget(covariant TamanhoPacote oldWidget){
    super.didUpdateWidget(oldWidget);
    if (oldWidget.produtoSelecionado != widget.produtoSelecionado) {
      setState(() {
        tamanhoselecionado = null; // Reseta o tamanho selecionado ao mudar o produto
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TamanhosPacoteCompleto();
    final tamanhos = TamanhosPacoteCompleto().tamanhosPorProduto[widget.produtoSelecionado] ?? [];

    return Column(
      children: [
        Text(
          'Tamanho:',
          style: TextStyle(
              fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
        ),
        DropdownButton<String>(
        hint: Text('Selecione'),
        value: tamanhoselecionado,
        items: tamanhos.map((tamanho){
          return DropdownMenuItem<String>(
            value: tamanho,
            child: Text(tamanho),
          );
        }).toList(),
         onChanged: (value){
          setState(() {
            tamanhoselecionado = value;
          });
         })
      ],
    );
  }
}

class TamanhosPacoteCompleto {
  final Map<String, List<String>> tamanhosPorProduto = {
    'Bobina Picotada Fosca': [
      '20x30',
      '25x35',
      '30x40',
      '35x50',
      '40x60',
      '50x70',
      '60x80',
      '80x100',
      '80x120',
      '90x120',
    ],
    'Bobina Picotada Fosca Especial': [
      '20x30',
      '25x35',
      '30x40',
      '35x50',
      '40x60',
      '50x70',
    ],
    'Bobina Picotada Transparente': [
      '20x30',
      '25x35',
      '30x40',
      '35x50',
      '40x60',
      '50x70',
    ],
    'Sacola de KG Branca': [
      '25x35',
      '30x40',
      '35x50',
      '40x50',
      '40x60',
      '50x60',
      '50x70',
      '60x80',
      '80x100',
    ],
    'Sacola de KG Transparente': [
      '25x35',
      '30x40',
      '40x50',
      '50x60',
    ],
    'Sacola de Milhero Verde': [
      '30x40',
      '40x50',
    ],
  };
}
