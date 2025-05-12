import 'package:uuid/uuid.dart';
import 'item_pedido.dart';

class Pedido {
  final String id;
  final String representanteId;
  final String formaPagamento;
  final String? prazoPagamento;
  final List<ItemPedido> itens;
  final String observacoes;
  final double pesoTotal;
  final double valorTotal;
  final DateTime data;
  final String status; // 'confirmado', 'guardado', 'cancelado'

  Pedido({
    String? id,
    required this.representanteId,
    required this.formaPagamento,
    this.prazoPagamento,
    required this.itens,
    required this.observacoes,
    required this.pesoTotal,
    required this.valorTotal,
    DateTime? data,
    required this.status,
  }) : 
    id = id ?? const Uuid().v4(),
    data = data ?? DateTime.now();

  // Método para criar cópia com valores atualizados
  Pedido copyWith({
    String? id,
    String? representanteId,
    String? formaPagamento,
    String? prazoPagamento,
    List<ItemPedido>? itens,
    String? observacoes,
    double? pesoTotal,
    double? valorTotal,
    DateTime? data,
    String? status,
  }) {
    return Pedido(
      id: id ?? this.id,
      representanteId: representanteId ?? this.representanteId,
      formaPagamento: formaPagamento ?? this.formaPagamento,
      prazoPagamento: prazoPagamento ?? this.prazoPagamento,
      itens: itens ?? this.itens,
      observacoes: observacoes ?? this.observacoes,
      pesoTotal: pesoTotal ?? this.pesoTotal,
      valorTotal: valorTotal ?? this.valorTotal,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  // Converter para Map (útil para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'representanteId': representanteId,
      'formaPagamento': formaPagamento,
      'prazoPagamento': prazoPagamento,
      'itens': itens.map((item) => item.toMap()).toList(),
      'observacoes': observacoes,
      'pesoTotal': pesoTotal,
      'valorTotal': valorTotal,
      'data': data.toIso8601String(),
      'status': status,
    };
  }

  // Criar a partir de Map (útil para ler do banco de dados)
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      representanteId: map['representanteId'],
      formaPagamento: map['formaPagamento'],
      prazoPagamento: map['prazoPagamento'],
      itens: List<ItemPedido>.from(
        map['itens']?.map((item) => ItemPedido.fromMap(item))),
      observacoes: map['observacoes'],
      pesoTotal: map['pesoTotal'],
      valorTotal: map['valorTotal'],
      data: DateTime.parse(map['data']),
      status: map['status'],
    );
  }
}