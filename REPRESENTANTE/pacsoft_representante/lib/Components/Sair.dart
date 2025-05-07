import 'package:flutter/material.dart';

class Sair extends StatelessWidget {
  const Sair({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sair'),
      ),
      body: Center(
        child: Text('This is the Sair page'),
      ),
    );
  }
}