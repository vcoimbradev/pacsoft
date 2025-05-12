import 'package:flutter/material.dart';

class Valormedio extends StatelessWidget {
  final double valorTotal;
  const Valormedio({super.key, required this.valorTotal});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Valor médio total do pedido em R\$:',
        style: TextStyle(
            fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
      ),
      SizedBox(height: 10),
      Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(100)),
        child: TextField(
          enabled: false,
          textAlign: TextAlign.center,
          controller: TextEditingController(text: valorTotal.toStringAsFixed(2)),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ),
    ]);
  }
}
