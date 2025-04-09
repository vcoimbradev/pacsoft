import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/PG_PEDIDOS.dart';

class TamanhosPacote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return tamanhosstate();
  }
}

class tamanhosstate extends State<TamanhosPacote> {
  String? tamanhoselecionado; // Variável para armazenar o valor selecionado

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: DropdownButton<String>(
            hint: Text('Tamanho'),
            value: tamanhoselecionado, // Define o valor selecionado
            items: [
              DropdownMenuItem(
                value: '20x30',
                child: Text('20x30'),
              ),
              DropdownMenuItem(
                value: '25x35',
                child: Text('25x35'),
              ),
              DropdownMenuItem(
                value: '30x40',
                child: Text('30x40'),
              ),
              DropdownMenuItem(
                value: '35x50',
                child: Text('35x50'),
              ),
              DropdownMenuItem(
                value: '40x60',
                child: Text('40x60'),
              ),
              DropdownMenuItem(
                value: '50x70',
                child: Text('50x70'),
              ),
              DropdownMenuItem(
                value: '60x80',
                child: Text('60x80'),
              ),
              DropdownMenuItem(
                value: '80x100',
                child: Text('80x100'),
              ),
              DropdownMenuItem(
                value: '80x120',
                child: Text('80x120'),
              ),
              DropdownMenuItem(
                value: '90x120',
                child: Text('90x120'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                tamanhoselecionado = value; // Atualiza o valor selecionado
              });
              PgPedidos().tamanhoselecionadoValue =
                  value; // Atualiza o valor na classe PgPedidos
              print(tamanhoselecionado);
            }));
  }
}
