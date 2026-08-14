import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/disciplinas.dart';
import '../models/aula.dart';
import '../models/disciplina.dart';

class StorageService {
  static const String _chaveDisciplinas = 'disciplinas_salvas';
  static const String _chaveCicloAtual = 'ciclo_atual';
    // ============================================================
  // AUTO SAVE
  // ============================================================

  static Timer? _timerAutoSave;
  static String _ultimoEstado = '';

  static void iniciarAutoSave() {
    _timerAutoSave?.cancel();

    _timerAutoSave = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final estadoAtual = jsonEncode(
          listaDisciplinas
              .map(_disciplinaParaMap)
              .toList(),
        );

        if (estadoAtual != _ultimoEstado) {
          _ultimoEstado = estadoAtual;
          await salvarTudo();
        }
      },
    );
  }

  static void pararAutoSave() {
    _timerAutoSave?.cancel();
    _timerAutoSave = null;
  }

  // ============================================================
  // CICLO ATUAL
  // ============================================================

  static int _cicloAtual = 0;

  static int get cicloAtual => _cicloAtual;

  static set cicloAtual(int valor) {
    _cicloAtual = valor;
  }

  // ============================================================
  // SALVAR TODO O ESTADO DO APLICATIVO
  // ============================================================

  static Future<void> salvarTudo() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = listaDisciplinas.map((disciplina) {
      return _disciplinaParaMap(disciplina);
    }).toList();

    await prefs.setString(
      _chaveDisciplinas,
      jsonEncode(dados),
    );

    await prefs.setInt(
      _chaveCicloAtual,
      _cicloAtual,
    );
  }

  // ============================================================
  // CARREGAR TODO O ESTADO DO APLICATIVO
  // ============================================================

  static Future<void> carregarTudo() async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega o número do ciclo.
    _cicloAtual = prefs.getInt(_chaveCicloAtual) ?? 0;

    final String? dadosSalvos =
        prefs.getString(_chaveDisciplinas);

    // Se nunca houve dados salvos,
    // mantém os dados iniciais de disciplinas.dart.
    if (dadosSalvos == null || dadosSalvos.isEmpty) {
      return;
    }

    final List<dynamic> dados =
        jsonDecode(dadosSalvos) as List<dynamic>;

    final disciplinasSalvas = dados.map((item) {
      return _disciplinaDeMap(
        Map<String, dynamic>.from(item),
      );
    }).toList();

    listaDisciplinas
      ..clear()
      ..addAll(disciplinasSalvas);
  }

  // ============================================================
  // CONVERTER DISCIPLINA PARA DADOS SALVÁVEIS
  // ============================================================

  static Map<String, dynamic> _disciplinaParaMap(
    Disciplina disciplina,
  ) {
    return {
      'nome': disciplina.nome,
      'descricao': disciplina.descricao,
      'peso': disciplina.peso,
      'paginas': disciplina.paginas,
      'categoria': disciplina.categoria,

      'paginasLidas': disciplina.paginasLidas,
      'horasEstudadas': disciplina.horasEstudadas,
      'questoesResolvidas': disciplina.questoesResolvidas,
      'acertos': disciplina.acertos,
      'concluida': disciplina.concluida,
      'segundosEstudados': disciplina.segundosEstudados,
      'indiceAulaAtual': disciplina.indiceAulaAtual,

      'aulas': disciplina.aulas
          .map(_aulaParaMap)
          .toList(),
    };
  }

  // ============================================================
  // RECRIAR DISCIPLINA
  // ============================================================

  static Disciplina _disciplinaDeMap(
    Map<String, dynamic> dados,
  ) {
    final aulasSalvas =
        (dados['aulas'] as List<dynamic>? ?? []);

    final aulas = aulasSalvas.map((item) {
      return _aulaDeMap(
        Map<String, dynamic>.from(item),
      );
    }).toList();

    return Disciplina(
      nome: dados['nome'] as String,
      descricao: dados['descricao'] as String,
      peso: (dados['peso'] as num?)?.toInt() ?? 0,
      paginas: (dados['paginas'] as num?)?.toInt() ?? 0,

      categoria:
          dados['categoria'] as String? ?? '',

      aulas: aulas,

      paginasLidas:
          (dados['paginasLidas'] as num?)?.toInt() ?? 0,

      horasEstudadas:
          (dados['horasEstudadas'] as num?)?.toInt() ?? 0,

      questoesResolvidas:
          (dados['questoesResolvidas'] as num?)?.toInt() ?? 0,

      acertos:
          (dados['acertos'] as num?)?.toInt() ?? 0,

      concluida:
          dados['concluida'] as bool? ?? false,

      segundosEstudados:
          (dados['segundosEstudados'] as num?)?.toInt() ?? 0,

      indiceAulaAtual:
          (dados['indiceAulaAtual'] as num?)?.toInt() ?? 0,
    );
  }

  // ============================================================
  // CONVERTER AULA PARA DADOS SALVÁVEIS
  // ============================================================

  static Map<String, dynamic> _aulaParaMap(
    Aula aula,
  ) {
    return {
      'nome': aula.nome,
      'totalPaginas': aula.totalPaginas,
      'paginasLidas': aula.paginasLidas,
      'totalVideos': aula.totalVideos,
      'videosAssistidos': aula.videosAssistidos,
      'questoesResolvidas': aula.questoesResolvidas,
      'acertos': aula.acertos,
      'erros': aula.erros,
      'segundosEstudados': aula.segundosEstudados,
      'revisoes': aula.revisoes,
      'concluida': aula.concluida,
    };
  }

  // ============================================================
  // RECRIAR AULA
  // ============================================================

  static Aula _aulaDeMap(
    Map<String, dynamic> dados,
  ) {
    final revisoesSalvas =
        (dados['revisoes'] as List<dynamic>? ?? []);

    return Aula(
      nome: dados['nome'] as String,

      totalPaginas:
          (dados['totalPaginas'] as num?)?.toInt() ?? 0,

      paginasLidas:
          (dados['paginasLidas'] as num?)?.toInt() ?? 0,

      totalVideos:
          (dados['totalVideos'] as num?)?.toInt() ?? 0,

      videosAssistidos:
          (dados['videosAssistidos'] as num?)?.toInt() ?? 0,

      questoesResolvidas:
          (dados['questoesResolvidas'] as num?)?.toInt() ?? 0,

      acertos:
          (dados['acertos'] as num?)?.toInt() ?? 0,

      erros:
          (dados['erros'] as num?)?.toInt() ?? 0,

      segundosEstudados:
          (dados['segundosEstudados'] as num?)?.toInt() ?? 0,

      revisoes:
          revisoesSalvas
              .map((item) => item as bool)
              .toList(),

      concluida:
          dados['concluida'] as bool? ?? false,
    );
  }

  // ============================================================
  // APAGAR TODOS OS DADOS SALVOS
  // ============================================================

  static Future<void> apagarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_chaveDisciplinas);
    await prefs.remove(_chaveCicloAtual);

    // Também volta o ciclo em memória para o início.
    _cicloAtual = 0;
  }
}