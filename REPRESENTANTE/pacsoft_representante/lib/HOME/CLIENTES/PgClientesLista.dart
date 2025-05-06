import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_superior.dart';

class PgClientesLista extends StatelessWidget {
  const PgClientesLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          Barra_pesquisa(),
          // Lista de opções
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.green),
                  title: const Text('Cadastrar novo cliente'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navegar para a tela de cadastro de cliente
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group, color: Colors.green),
                  title: const Text('Todos os clientes'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navegar para a tela de todos os clientes
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.green),
                  title: const Text('Clientes sem pedidos em 30 dias'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navegar para a tela de clientes sem pedidos
                  },
                ),
              ],
            ),
          ),
        ],
          ),
    bottomNavigationBar: barra_inferior(),
    );
  }
}