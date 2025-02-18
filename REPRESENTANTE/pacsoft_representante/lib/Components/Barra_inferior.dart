import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/PG_INICIAL.dart';

class barra_inferior extends StatefulWidget implements PreferredSizeWidget{
  @override
  State<StatefulWidget> createState() {
    return baixo();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
 
  
}

class baixo extends State<barra_inferior>{

  int index_selecionado = 0;

  final List<Widget> screens = [
    PgInicial(),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar( //BARRA DE ESCOLHA
        destinations: [
        NavigationDestination(icon: Image.asset('assets/images/inicio.png',width: 40), label: 'Inicio'),
        NavigationDestination(icon: Image.asset('assets/images/cliente.png',width: 40), label: 'Clientes'),
        NavigationDestination(icon: Image.asset('assets/images/pedidos.png',width: 40), label: 'Pedidos'),
        NavigationDestination(icon: Image.asset('assets/images/relatorio.png',width: 40), label: 'Relatórios'),
      ]) ;
  }
  

}