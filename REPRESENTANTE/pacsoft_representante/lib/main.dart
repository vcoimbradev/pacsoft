import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pacsoft_representante/HOME/LOGIN/PG_LOGIN.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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