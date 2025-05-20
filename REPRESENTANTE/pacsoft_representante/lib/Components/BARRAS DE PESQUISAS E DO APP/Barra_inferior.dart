import 'package:flutter/material.dart';
import 'package:pacsoft_representante/HOME/CLIENTES/PgClientesLista.dart';
import 'package:pacsoft_representante/HOME/INICIAL/PG_INICIAL.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PgPedidoslista.dart';
import 'package:pacsoft_representante/HOME/RELATORIO/PgRelatorioLista.dart';

class barra_inferior extends StatefulWidget implements PreferredSizeWidget {
  const barra_inferior({super.key,});

  @override
  State<StatefulWidget> createState() {
    return baixo();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class baixo extends State<barra_inferior> {
  int index_selecionado = 0;

  // Lista de telas correspondentes a cada item da barra de navegação
  List<Widget> get screens => [
    PgInicial(),
    PgClientesLista(), // Substitua pela sua tela de clientes
    PgPedidosLista(),  // Substitua pela sua tela de pedidos
    PgRelatorioLista(), // Substitua pela sua tela de relatórios
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: index_selecionado,
      onDestinationSelected: (int index) {
        setState(() {
          index_selecionado = index;
        });
        
        // Navega para a tela correspondente
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screens[index]),
        );
      },
      destinations: [
        NavigationDestination(
          icon: Image.asset('assets/images/inicio.png', width: 40),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Image.asset('assets/images/cliente.png', width: 40),
          label: 'Clientes',
        ),
        NavigationDestination(
          icon: Image.asset('assets/images/pedidos.png', width: 40),
          label: 'Pedidos',
        ),
        NavigationDestination(
          icon: Image.asset('assets/images/relatorio.png', width: 40),
          label: 'Relatórios',
        ),
      ],
    );
  }
}