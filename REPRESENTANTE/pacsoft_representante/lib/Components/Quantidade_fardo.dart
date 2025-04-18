import 'package:flutter/material.dart';

class QuantidadeFardo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return quantidadestage();
  }
}

class quantidadestage extends State<QuantidadeFardo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Quantidade em Fardo:',
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
