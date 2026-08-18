import '../models/disciplina.dart';
import '../models/revisao.dart';
import 'storage_service.dart';

class CicloService {
  final List<Disciplina> disciplinas;

  final List<Revisao> revisoes = [];

  CicloService(this.disciplinas);

  // ============================================================
  // CICLO ATUAL
  // ============================================================

  int get cicloAtual => StorageService.cicloAtual;

  // ============================================================
  // PRÓXIMA DISCIPLINA
  // ============================================================

  Disciplina proximaDisciplina() {
    // Apenas procura a primeira disciplina ainda não concluída.
    //
    // IMPORTANTE:
    // Este método NÃO altera o ciclo.
    for (final disciplina in disciplinas) {
      if (!disciplina.concluida) {
        return disciplina;
      }
    }

    // Se todas estiverem concluídas, retorna a primeira.
    //
    // A virada do ciclo acontece em concluirDisciplina(),
    // no momento em que a última disciplina é encerrada.
    return disciplinas.first;
  }

  // ============================================================
  // CONCLUIR DISCIPLINA
  // ============================================================

  void concluirDisciplina(Disciplina disciplina) {
    if (disciplina.concluida) {
      return;
    }

    // Marca a disciplina como concluída.
    disciplina.concluida = true;

    // Cria a revisão para o dia seguinte.
    revisoes.add(
      Revisao(
        disciplina: disciplina.nome,
        data: DateTime.now().add(
          const Duration(days: 1),
        ),
      ),
    );

    // ============================================================
    // VERIFICA SE ESTA FOI A ÚLTIMA DISCIPLINA DO CICLO
    // ============================================================

    final todasConcluidas = disciplinas.every(
      (disciplina) => disciplina.concluida,
    );

    if (todasConcluidas) {
      // Terminou o ciclo atual.
      StorageService.cicloAtual++;

      // Libera todas as disciplinas para o novo ciclo.
      for (final disciplina in disciplinas) {
        disciplina.concluida = false;
      }
    }
  }

  // ============================================================
  // PROGRESSO
  // ============================================================

  double progresso() {
    if (disciplinas.isEmpty) {
      return 0;
    }

    final concluidas = disciplinas.where(
      (disciplina) => disciplina.concluida,
    ).length;

    return concluidas / disciplinas.length;
  }

  // ============================================================
  // DISCIPLINAS CONCLUÍDAS
  // ============================================================

  int concluidas() {
    return disciplinas.where(
      (disciplina) => disciplina.concluida,
    ).length;
  }

  // ============================================================
  // TEMPO TOTAL
  // ============================================================

  int tempoTotalSegundos() {
    return disciplinas.fold(
      0,
      (total, disciplina) =>
          total + disciplina.segundosEstudados,
    );
  }

  // ============================================================
  // REVISÕES PENDENTES
  // ============================================================

  int revisoesPendentes() {
    return revisoes.where(
      (revisao) => revisao.data.isBefore(DateTime.now()),
    ).length;
  }

  // ============================================================
  // TOTAL DE QUESTÕES
  // ============================================================

  int totalQuestoes() {
  return disciplinas.fold(
    0,
    (totalDisciplinas, disciplina) {
      final totalAulas = disciplina.aulas.fold(
        0,
        (totalAulas, aula) =>
            totalAulas + aula.questoesResolvidas,
      );

      return totalDisciplinas + totalAulas;
    },
  );
}
}