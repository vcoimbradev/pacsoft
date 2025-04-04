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
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(100)),
                      child: TextField(
                        enabled: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintText: 'Prazo de pagamento',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Selecione o tipo:',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 15),
                    ),
                    Container(
                        width: 300,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            hintText: 'Selecione o tipo de pedido',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Bobina Picotada Fosca',
                              child: Text('Bobina Picotada Fosca'),
                            ),
                            DropdownMenuItem(
                              value: 'Bobina Picotada Fosca Especial',
                              child: Text('Bobina Picotada Fosca Especial'),
                            ),
                            DropdownMenuItem(
                              value: 'Bobina Picotada Transparente',
                              child: Text('Bobina Picotada Transparente'),
                            ),
                            DropdownMenuItem(
                              value: 'Sacola de KG Branca',
                              child: Text('Sacola de KG Branca'),
                            ),
                            DropdownMenuItem(
                              value: 'Sacola de KG Transparente',
                              child: Text('Sacola de KG Transparente'),
                            ),
                            DropdownMenuItem(
                              value: 'Sacola de Milhero Verde',
                              child: Text('Sacola de Milhero Verde'),
                            ),
                          ],
                          onChanged: (value) {
                            // Ação ao selecionar um cliente
                          },
                        ))
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
