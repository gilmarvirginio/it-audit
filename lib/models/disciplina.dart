import 'aula.dart';

class Disciplina {
  final String nome;
  final String descricao;
  final int peso;
  final int paginas;
  final String categoria;

  // Aulas cadastradas nesta disciplina
  final List<Aula> aulas;

  int paginasLidas;
  int horasEstudadas;
  int questoesResolvidas;
  int acertos;
  bool concluida;
  int segundosEstudados;

  // Índice da próxima aula que deve ser estudada
  int indiceAulaAtual;

  Disciplina({
    required this.nome,
    required this.descricao,
    required this.peso,
    required this.paginas,
    required this.categoria,
    List<Aula>? aulas,
    this.paginasLidas = 0,
    this.horasEstudadas = 0,
    this.questoesResolvidas = 0,
    this.acertos = 0,
    this.concluida = false,
    this.segundosEstudados = 0,
    this.indiceAulaAtual = 0,
  }) : aulas = aulas ?? [];

  // Aula que está sendo trabalhada atualmente.
  Aula? get aulaAtual {
    if (indiceAulaAtual < 0) {
      indiceAulaAtual = 0;
    }

    if (indiceAulaAtual >= aulas.length) {
      return null;
    }

    return aulas[indiceAulaAtual];
  }

  // Indica se existe uma aula atual cadastrada.
  bool get possuiAulaAtual {
    return aulaAtual != null;
  }

  // Progresso geral da disciplina.
  double get progresso {
    if (paginas == 0) {
      return 0;
    }

    return paginasLidas / paginas;
  }

  double get percentualAcertos {
    if (questoesResolvidas == 0) {
      return 0;
    }

    return acertos / questoesResolvidas;
  }

  void registrarLeitura(int paginasHoje) {
    paginasLidas += paginasHoje;

    if (paginasLidas > paginas) {
      paginasLidas = paginas;
    }
  }

  void registrarHoras(int horas) {
    horasEstudadas += horas;
  }

  void registrarQuestoes(int total, int corretas) {
    questoesResolvidas += total;
    acertos += corretas;
  }

  void adicionarAula(Aula aula) {
    aulas.add(aula);
  }

  void removerAula(Aula aula) {
    aulas.remove(aula);
  }

  // Conclui a aula atual e avança para a próxima.
  void concluirAulaAtual() {
    final aula = aulaAtual;

    if (aula == null) {
      return;
    }

    aula.concluida = true;

    indiceAulaAtual++;
  }

  void finalizarDisciplina() {
    concluida = true;
  }
}