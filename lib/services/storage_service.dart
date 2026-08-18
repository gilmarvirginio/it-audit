import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/disciplinas.dart';
import '../models/aula.dart';
import '../models/disciplina.dart';
import '../models/revisao.dart';

class StorageService {
  static const String _chaveDisciplinas = 'disciplinas_salvas';
  static const String _chaveCicloAtual = 'ciclo_atual';
  static const String _chaveHistoricoTempo = 'historico_tempo_estudo';
  static const String _chaveRevisoes = 'revisoes';

  static Timer? _timerAutoSave;
  static String _ultimoEstado = '';

  static int _cicloAtual = 0;

  // Histórico diário:
  // '2026-08-15' -> segundos estudados naquele dia
  static Map<String, int> _historicoTempo = {};
  static List<Revisao> _revisoes = [];

static List<Revisao> get revisoes => _revisoes;

  static int get cicloAtual => _cicloAtual;

  static set cicloAtual(int valor) {
    _cicloAtual = valor;
  }

  // ============================================================
  // HISTÓRICO DE TEMPO
  // ============================================================

  static String _chaveDia([DateTime? data]) {
    final agora = data ?? DateTime.now();

    return '${agora.year.toString().padLeft(4, '0')}-'
        '${agora.month.toString().padLeft(2, '0')}-'
        '${agora.day.toString().padLeft(2, '0')}';
  }

  static void registrarSegundoEstudo() {
    final chave = _chaveDia();

    _historicoTempo[chave] =
        (_historicoTempo[chave] ?? 0) + 1;
  }

  static int tempoDoDia(DateTime data) {
    return _historicoTempo[_chaveDia(data)] ?? 0;
  }
  static int tempoTotalHistorico() {
  return _historicoTempo.values.fold(
    0,
    (total, segundos) => total + segundos,
  );
}

  static int tempoDeHoje() {
    return tempoDoDia(DateTime.now());
  }

  static int tempoDeOntem() {
    final ontem = DateTime.now().subtract(
      const Duration(days: 1),
    );

    return tempoDoDia(ontem);
  }

  static int tempoDaSemana([DateTime? referencia]) {
    final data = referencia ?? DateTime.now();

    // Segunda-feira = início da semana.
    final inicioSemana =
        data.subtract(Duration(days: data.weekday - 1));

    var total = 0;

    for (var i = 0; i < 7; i++) {
      final dia = inicioSemana.add(Duration(days: i));
      total += tempoDoDia(dia);
    }

    return total;
  }

  static int tempoDaSemanaAnterior(
      [DateTime? referencia]) {
    final data = referencia ?? DateTime.now();

    final inicioSemanaAtual =
        data.subtract(Duration(days: data.weekday - 1));

    final inicioSemanaAnterior =
        inicioSemanaAtual.subtract(
      const Duration(days: 7),
    );

    var total = 0;

    for (var i = 0; i < 7; i++) {
      final dia =
          inicioSemanaAnterior.add(Duration(days: i));

      total += tempoDoDia(dia);
    }

    return total;
  }

  static List<int> temposDaSemana(
      [DateTime? referencia]) {
    final data = referencia ?? DateTime.now();

    final inicioSemana =
        data.subtract(Duration(days: data.weekday - 1));

    return List.generate(7, (index) {
      final dia =
          inicioSemana.add(Duration(days: index));

      return tempoDoDia(dia);
    });
  }

  static List<int> temposDaSemanaAnterior(
      [DateTime? referencia]) {
    final data = referencia ?? DateTime.now();

    final inicioSemana =
        data.subtract(Duration(days: data.weekday - 1));

    final inicioAnterior =
        inicioSemana.subtract(
      const Duration(days: 7),
    );

    return List.generate(7, (index) {
      final dia =
          inicioAnterior.add(Duration(days: index));

      return tempoDoDia(dia);
    });
  }

  // ============================================================
  // AUTO SAVE
  // ============================================================

  static void iniciarAutoSave() {
    _timerAutoSave?.cancel();

    _timerAutoSave = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final estadoAtual = jsonEncode({
          'disciplinas': listaDisciplinas
              .map(_disciplinaParaMap)
              .toList(),
          'historicoTempo': _historicoTempo,
        });

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
  // SALVAR TUDO
  // ============================================================
static Future<void> registrarRevisao({
  required String tipo,
  required String assunto,
  required int quantidade,
  required DateTime data,
  required int segundosEstudados,
}) async {
  _revisoes.add(
    Revisao(
      tipo: tipo,
      assunto: assunto,
      quantidade: quantidade,
      data: data,
      segundosEstudados: segundosEstudados,
    ),
  );

  await salvarTudo();
}

  static Future<void> salvarTudo() async {
    final prefs =
        await SharedPreferences.getInstance();

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

    await prefs.setString(
      _chaveHistoricoTempo,
      jsonEncode(_historicoTempo),
    );
    await prefs.setString(
  _chaveRevisoes,
  jsonEncode(
    _revisoes.map((revisao) {
      return {
        'tipo': revisao.tipo,
        'assunto': revisao.assunto,
        'quantidade': revisao.quantidade,
        'data': revisao.data.toIso8601String(),
        'segundosEstudados':
            revisao.segundosEstudados,
      };
    }).toList(),
  ),
);
  }

  // ============================================================
  // CARREGAR TUDO
  // ============================================================

  static Future<void> carregarTudo() async {
  final prefs =
      await SharedPreferences.getInstance();

  _cicloAtual =
      prefs.getInt(_chaveCicloAtual) ?? 0;

  // ============================================================
  // HISTÓRICO DE TEMPO
  // ============================================================

  final historicoSalvo =
      prefs.getString(_chaveHistoricoTempo);

  if (historicoSalvo != null &&
      historicoSalvo.isNotEmpty) {
    final dados =
        jsonDecode(historicoSalvo)
            as Map<String, dynamic>;

    _historicoTempo = dados.map(
      (chave, valor) => MapEntry(
        chave,
        (valor as num).toInt(),
      ),
    );
  } else {
    _historicoTempo = {};
  }

  // ============================================================
  // REVISÕES
  // ============================================================

  final revisoesSalvas =
      prefs.getString(_chaveRevisoes);

  if (revisoesSalvas != null &&
      revisoesSalvas.isNotEmpty) {
    final dados =
        jsonDecode(revisoesSalvas)
            as List<dynamic>;

    _revisoes = dados.map((item) {
      final mapa =
          Map<String, dynamic>.from(item);

      return Revisao(
        tipo:
            mapa['tipo'] as String? ?? '',
        assunto:
            mapa['assunto'] as String? ?? '',
        quantidade:
            (mapa['quantidade'] as num?)
                    ?.toInt() ??
                0,
        data: DateTime.parse(
          mapa['data'] as String,
        ),
        segundosEstudados:
            (mapa['segundosEstudados']
                        as num?)
                    ?.toInt() ??
                0,
      );
    }).toList();
  } else {
    _revisoes = [];
  }

  // ============================================================
  // DISCIPLINAS
  // ============================================================

  final dadosSalvos =
      prefs.getString(_chaveDisciplinas);

  if (dadosSalvos == null ||
      dadosSalvos.isEmpty) {
    return;
  }

  final dados =
      jsonDecode(dadosSalvos)
          as List<dynamic>;

  final disciplinasSalvas =
      dados.map((item) {
    return _disciplinaDeMap(
      Map<String, dynamic>.from(item),
    );
  }).toList();

  listaDisciplinas
    ..clear()
    ..addAll(disciplinasSalvas);
}

  // ============================================================
  // DISCIPLINA -> MAP
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
      'questoesResolvidas':
          disciplina.questoesResolvidas,
      'acertos': disciplina.acertos,
      'concluida': disciplina.concluida,
      'segundosEstudados':
          disciplina.segundosEstudados,
      'indiceAulaAtual':
          disciplina.indiceAulaAtual,
      'aulas': disciplina.aulas
          .map(_aulaParaMap)
          .toList(),
    };
  }

  // ============================================================
  // MAP -> DISCIPLINA
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
  // AULA -> MAP
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
      'questoesResolvidas':
          aula.questoesResolvidas,
      'acertos': aula.acertos,
      'erros': aula.erros,
      'segundosEstudados':
          aula.segundosEstudados,
      'revisoes': aula.revisoes,
      'concluida': aula.concluida,
    };
  }

  // ============================================================
  // MAP -> AULA
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
      revisoes: revisoesSalvas
          .map((item) => item as bool)
          .toList(),
      concluida:
          dados['concluida'] as bool? ?? false,
    );
  }

  // ============================================================
  // APAGAR DADOS
  // ============================================================
  // ============================================================
  // APAGAR REVISÕES
  // ============================================================

  static Future<void> apagarRevisoes() async {
    final prefs =
        await SharedPreferences.getInstance();

    _revisoes.clear();

    await prefs.remove(_chaveRevisoes);
  }

  // ============================================================
  // ZERAR TODO O APLICATIVO
  // ============================================================

  static Future<void> apagarDados() async {
    final prefs =
        await SharedPreferences.getInstance();

    // ----------------------------------------------------------
    // ZERA TODAS AS DISCIPLINAS E AULAS
    // ----------------------------------------------------------

    for (final disciplina in listaDisciplinas) {
      disciplina.paginasLidas = 0;
      disciplina.horasEstudadas = 0;
      disciplina.questoesResolvidas = 0;
      disciplina.acertos = 0;
      disciplina.concluida = false;
      disciplina.segundosEstudados = 0;
      disciplina.indiceAulaAtual = 0;

      // Remove todas as aulas cadastradas.
      disciplina.aulas.clear();
    }

    // ----------------------------------------------------------
    // ZERA O HISTÓRICO DE TEMPO
    // ----------------------------------------------------------

    _historicoTempo = {};

    // ----------------------------------------------------------
    // ZERA O CICLO
    // ----------------------------------------------------------

    _cicloAtual = 0;

    // ----------------------------------------------------------
    // ZERA TODAS AS REVISÕES
    // ----------------------------------------------------------

    _revisoes.clear();

    // ----------------------------------------------------------
    // REMOVE OS DADOS ANTIGOS SALVOS
    // ----------------------------------------------------------

    await prefs.remove(_chaveDisciplinas);
    await prefs.remove(_chaveCicloAtual);
    await prefs.remove(_chaveHistoricoTempo);
    await prefs.remove(_chaveRevisoes);

    // ----------------------------------------------------------
    // SALVA O ESTADO LIMPO
    // ----------------------------------------------------------

    await salvarTudo();

    // Atualiza o estado usado pelo AutoSave.
    _ultimoEstado = jsonEncode({
      'disciplinas':
          listaDisciplinas
              .map(_disciplinaParaMap)
              .toList(),
      'historicoTempo': _historicoTempo,
    });
  }
}