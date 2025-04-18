import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/PG_LOGIN.dart';
import 'package:pacsoft_representante/HOME/PG_INICIAL.dart';
import 'package:pacsoft_representante/HOME/PG_PEDIDOS.dart';
import 'package:pacsoft_representante/HOME/PG_PERFIL.dart';

class Pacsoft extends StatelessWidget {
  const Pacsoft({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PgPedidos(),
      
    );
  }
}