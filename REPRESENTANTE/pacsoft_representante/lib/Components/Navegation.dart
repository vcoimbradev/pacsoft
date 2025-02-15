import 'package:flutter/material.dart';

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