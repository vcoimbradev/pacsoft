import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/LOGIN/PG_LOGIN.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Pacsoft());
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