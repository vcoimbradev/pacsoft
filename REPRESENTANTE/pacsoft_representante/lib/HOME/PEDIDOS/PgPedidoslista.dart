import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_superior.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PG_PEDIDOS.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PG_PEDIDOSEMABERTO.dart';
import 'package:pacsoft_representante/HOME/CLIENTES/PG_TODOSOSCLIENTES.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PG_TODOSOSPEDIDOS';

class PgPedidosLista extends StatelessWidget {
  const PgPedidosLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          // Barra de pesquisa
          Barra_pesquisa(),
          // Lista de opções
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.add_box, color: Colors.green),
                  title: const Text('Novo pedido'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgPedidos(),
                      ),
                    );
                    // Navegar para a tela de novo pedido
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory, color: Colors.green),
                  title: const Text('Todos os pedidos'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgTodosPedidos(),
                      ),
                    );
                    // Navegar para a tela de todos os pedidos
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pending_actions, color: Colors.green),
                  title: const Text('Pedidos em aberto'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgPedidosAbertos(),
                      ),
                    );
                    // Navegar para a tela de pedidos em aberto
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: barra_inferior()
      );
  }
}