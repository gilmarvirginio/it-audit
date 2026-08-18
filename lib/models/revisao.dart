class Revisao {
  final String disciplina;
  final String tipo;
  final String assunto;
  final int quantidade;
  final DateTime data;
  final int segundosEstudados;

  Revisao({
    this.disciplina = '',
    this.tipo = '',
    this.assunto = '',
    this.quantidade = 0,
    required this.data,
    this.segundosEstudados = 0,
  });
}