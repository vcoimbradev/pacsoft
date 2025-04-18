import 'package:flutter/material.dart';

class Valormedio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return valormediostate();
  }
}

class valormediostate extends State<Valormedio> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Valor médio total do pedido em KG:',
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
