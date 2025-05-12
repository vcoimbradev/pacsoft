import 'package:flutter/material.dart';

class Observacoes extends StatefulWidget {
  final TextEditingController controller;
  const Observacoes({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() {
    return observacoesstate();
  }
}

class observacoesstate extends State<Observacoes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Observações',
          style: TextStyle(
              fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 15),
        ),
        SizedBox(
          width: 300,
          height: 40,
          child: TextField(
            controller: widget.controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              hintText: 'Digite aqui',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
        )
      ],
    );
  }
}
