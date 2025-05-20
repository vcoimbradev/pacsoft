import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pacsoft_representante/BANCODEDADOS.dart';
import 'package:pacsoft_representante/HOME/LOGIN/PG_LOGIN.dart';
import 'package:pacsoft_representante/Provider(CLASSES)/classe_global.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await DBHelper.inicializar();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ClasseGlobal()),
  ], child: const Pacsoft()));
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      home: Login(),
    );
  }
}
