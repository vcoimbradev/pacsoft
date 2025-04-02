import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/Barra_superior.dart';

class PgPedidos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return pginicialstate();
  }
}

class pginicialstate extends State<PgPedidos> {
  String? pagamentoselecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          Barra_pesquisa(),
          Flexible(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Novo Pedido',
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forma de Pagamento'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                            value: "avista",
                            groupValue: pagamentoselecionado,
                            onChanged: (value) {
                              pagamentoselecionado = value;
                            }),
                        Text(
                          'À vista',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Radio<String>(
                            value: 'boleto',
                            groupValue: pagamentoselecionado,
                            onChanged: (value) {
                              pagamentoselecionado = value;
                            }),
                        Text(
                          'Boleto',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Radio<String>(
                            value: 'cheque',
                            groupValue: pagamentoselecionado,
                            onChanged: (value) {
                              pagamentoselecionado = value;
                            }),
                        Text(
                          'Cheque',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        enabled: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
      bottomNavigationBar: barra_inferior(),
    );
  }
}
