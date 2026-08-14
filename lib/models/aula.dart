class Aula {
  final String nome;

  // PDF
  final int totalPaginas;
  int paginasLidas;

  // Vídeos
  final int totalVideos;
  int videosAssistidos;

  // Questões
  int questoesResolvidas;
  int acertos;
  int erros;

  // Tempo de estudo
  int segundosEstudados;

  // Revisões
  final List<bool> revisoes;

  // Estado da aula
  bool concluida;

  Aula({
    required this.nome,
    required this.totalPaginas,
    this.paginasLidas = 0,
    this.totalVideos = 0,
    this.videosAssistidos = 0,
    this.questoesResolvidas = 0,
    this.acertos = 0,
    this.erros = 0,
    this.segundosEstudados = 0,
    List<bool>? revisoes,
    this.concluida = false,
  }) : revisoes = revisoes ?? [false, false, false];

  // Progresso do PDF
  double get progressoPaginas {
    if (totalPaginas == 0) return 0;
    return paginasLidas / totalPaginas;
  }

  // Progresso dos vídeos
  double get progressoVideos {
    if (totalVideos == 0) return 0;
    return videosAssistidos / totalVideos;
  }

  // Percentual de acertos
  double get percentualAcertos {
    if (questoesResolvidas == 0) return 0;
    return acertos / questoesResolvidas;
  }

  // Quantidade de revisões concluídas
  int get revisoesConcluidas {
    return revisoes.where((revisao) => revisao).length;
  }
}