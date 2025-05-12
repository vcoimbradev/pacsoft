import 'package:flutter/material.dart';

class TamanhoPacote extends StatelessWidget {
  final String? produtoSelecionado;
  final String? tamanhoSelecionado;
  final ValueChanged<String?> onChanged;

  const TamanhoPacote({
    super.key,
    required this.produtoSelecionado,
    required this.tamanhoSelecionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tamanhos = TamanhosPacoteCompleto().tamanhosPorProduto[produtoSelecionado] ?? [];

    return Column(
      children: [
        Text(
          'Tamanho:',
          style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
        ),
        DropdownButton<String>(
          hint: Text('Selecione'),
          value: tamanhoSelecionado,
          items: tamanhos.map((tamanho) {
            return DropdownMenuItem<String>(
              value: tamanho,
              child: Text(tamanho),
            );
          }).toList(),
          onChanged: onChanged,
        ),
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
      '30x45',
      '35x45',
      '40x50',
      '45x60',
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
    'Sacola de Milheiro Verde': [
      '30x40',
      '40x50',
    ],
  };
}
