import 'package:flutter/material.dart';

class Preco extends StatefulWidget {
  const Preco({super.key});

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
        'Preço em MIL:',
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
