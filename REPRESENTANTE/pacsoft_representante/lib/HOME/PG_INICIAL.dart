import 'package:flutter/material.dart';

class PgInicial  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return pginicialstage();
  }
  
}

class pginicialstage extends State<PgInicial>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar( //BARRA SUPERIOR
        titleSpacing: 30,
        toolbarHeight: 100,
        title: Image.asset('assets/images/logo.png', height: 60),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 30),
          child:  SizedBox(
            child: IconButton(onPressed:(){}, icon: Icon(Icons.account_circle_outlined,size: 40,)),
          )
        )
        ],
        backgroundColor: Colors.green[200],
      ),

      body: Container( //MENU DE ATALHO
        child: Align(
          alignment: Alignment(0, -1),
          
        child: Column(

          children: [
            Padding(padding: EdgeInsets.only(top: 5)),

            Text("Bem Vindo, !"),
            Text("Atalhos"),
            Text("Últimos pedidos"),
            Text("Pedidos pendentes"),
            Text("Preços"),
            Text("Comissão"),
            

            Expanded( //LINHA DEBAIXO
              child: Column(
              children: [
              Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 2,color: Colors.black,),
                Text('Resumo do mês'),
                Text('Total de pedidos'),
                Text('25'),
                Text('Pedidos em aberto'),
                Text('12'),
                Text('Pedidos entregues'),
                Text('13'),
              ],
            )),
          ],
        ),
      ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: 'teste'),
        NavigationDestination(icon: Icon(Icons.home), label: 'teste'),
      ]) ,

    );
  }

}