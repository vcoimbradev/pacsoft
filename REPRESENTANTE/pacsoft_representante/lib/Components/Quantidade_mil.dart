import 'package:flutter/material.dart';

class Preco extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return precostate();
  }
}

class precostate extends State<Preco> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Quantidade em MIL:',
        style: TextStyle(
            fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
      ),
      Container(
        width: 150,
        height: 40,
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: 'Digite aqui',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ),
    ]);
  }
}
