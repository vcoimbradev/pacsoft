class ItemPedido {
  final String produto;
  final String? tamanho;
  final double? quantidadeKg;
  final int? quantidadeFardo;
  final int? quantidadeMilheiro;
  final double precoUnitario;

  ItemPedido({
    required this.produto,
    this.tamanho,
    this.quantidadeKg,
    this.quantidadeFardo,
    this.quantidadeMilheiro,
    required this.precoUnitario,
  });

  // Método para criar cópia com valores atualizados
  ItemPedido copyWith({
    String? produto,
    String? tamanho,
    double? quantidadeKg,
    int? quantidadeFardo,
    int? quantidadeMilheiro,
    double? precoUnitario,
  }) {
    return ItemPedido(
      produto: produto ?? this.produto,
      tamanho: tamanho ?? this.tamanho,
      quantidadeKg: quantidadeKg ?? this.quantidadeKg,
      quantidadeFardo: quantidadeFardo ?? this.quantidadeFardo,
      quantidadeMilheiro: quantidadeMilheiro ?? this.quantidadeMilheiro,
      precoUnitario: precoUnitario ?? this.precoUnitario,
    );
  }

  // Converter para Map (útil para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'produto': produto,
      'tamanho': tamanho,
      'quantidadeKg': quantidadeKg,
      'quantidadeFardo': quantidadeFardo,
      'quantidadeMilheiro': quantidadeMilheiro,
      'precoUnitario': precoUnitario,
    };
  }

  // Criar a partir de Map (útil para ler do banco de dados)
  factory ItemPedido.fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      produto: map['produto'],
      tamanho: map['tamanho'],
      quantidadeKg: map['quantidadeKg'],
      quantidadeFardo: map['quantidadeFardo'],
      quantidadeMilheiro: map['quantidadeMilheiro'],
      precoUnitario: map['precoUnitario'],
    );
  }
}