import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pacsoft_representante/BANCODEDADOS.dart';
import 'package:pacsoft_representante/HOME/LOGIN/PG_LOGIN.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await DBHelper.inicializar();
  runApp(const Pacsoft());
}

class Pacsoft extends StatelessWidget {
  const Pacsoft({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pacsoft',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Lato',
      ),
      home:  Login(),
    );
  }
}