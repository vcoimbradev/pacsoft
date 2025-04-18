import 'package:flutter/material.dart';

class Pesomedio extends StatefulWidget {
  const Pesomedio({super.key});

  @override
  State<StatefulWidget> createState() {
    return pesomediostate();
  }
}

class pesomediostate extends State<Pesomedio> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Peso médio total do pedido em KG:',
        style: TextStyle(
            fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(100)),
        child: TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            hintText: '',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ),
    ]);
  }
}
