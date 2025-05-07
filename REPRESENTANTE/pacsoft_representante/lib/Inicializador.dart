import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/INICIAL/PG_INICIAL.dart';



class Pacsoft extends StatelessWidget {
  const Pacsoft({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  PgInicial(),
    );
  }
}