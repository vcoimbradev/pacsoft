import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

Future<MySqlConnection> conectarBanco() async {
  final config = jsonDecode(await File('config.json').readAsString());

  var settings = ConnectionSettings(
    host: config['db_host'],
    port: config['db_port'],
    user: config['db_user'],
    password: config['db_password'],
    db: config['db_name'],
  );

  return MySqlConnection.connect(settings);
}

Future<Response> inserirDados(Request request) async {
  final conn = await conectarBanco();
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final razaoSocial = data['razao_social'];
    final cnpj = data['cnpj'];
    final inscricaoEstadual = data['inscricao_estadual'];
    final endereco = data['endereco'];
    final bairro = data['bairro'];
    final cidade = data['cidade'];
    final estado = data['estado'];
    final cep = data['cep'];
    final email = data['email'];
    final contato = data['contato'];

    await conn.query(
      'INSERT INTO clientes (razao_social, cnpj, inscricao_estadual, endereco, bairro, cidade, estado, cep, email, telefone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [razaoSocial, cnpj, inscricaoEstadual, endereco, bairro, cidade, estado, cep, email, contato],
    );

    return Response.ok(jsonEncode({'status': 'sucesso'}), headers: {
      'Content-Type': 'application/json',
    });
  } catch (e) {
    return Response.internalServerError(body: 'Erro ao inserir dados: $e');
  } finally {
    await conn.close();
  }
}

shelf_router.Router criarRotaInserir() {
  final router = shelf_router.Router();

  router.post('/inserir_cliente', inserirDados);

  return router;
}