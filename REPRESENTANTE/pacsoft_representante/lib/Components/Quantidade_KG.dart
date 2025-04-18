import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/PG_PEDIDOS.dart';

class QuantidadeKg extends StatefulWidget {
  const QuantidadeKg({super.key});

  @override
  State<StatefulWidget> createState() {
    return quantidadekgstate();
  }
}

class quantidadekgstate extends State<QuantidadeKg> {
  String? mostrartamanho; // Variável para armazenar o valor selecionado
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Quantidade em KG::',
          style: TextStyle(
              fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              hintText: 'Digite aqui',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
      ],
    );
  }
}
