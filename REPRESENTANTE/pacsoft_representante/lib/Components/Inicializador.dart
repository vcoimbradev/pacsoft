import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/PG_LOGIN.dart';
import 'package:pacsoft_representante/HOME/PG_INICIAL.dart';
import 'package:pacsoft_representante/HOME/PG_PERFIL.dart';

class Pacsoft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PgInicial(),
      
    );
  }
}