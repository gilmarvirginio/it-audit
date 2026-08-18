import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class ProgressoPage extends StatefulWidget {
  const ProgressoPage({super.key});

  @override
  State<ProgressoPage> createState() =>
      _ProgressoPageState();
}

class _ProgressoPageState
    extends State<ProgressoPage> {
  String _formatarTempo(int segundos) {
    final horas = segundos ~/ 3600;
    final minutos =
        (segundos % 3600) ~/ 60;

    if (horas > 0) {
      return '${horas}h ${minutos.toString().padLeft(2, '0')}min';
    }

    return '${minutos}min';
  }

  String _variacao(int atual, int anterior) {
    if (anterior == 0) {
      if (atual == 0) return '—';
      return 'NOVO';
    }

    final percentual =
        ((atual - anterior) / anterior) * 100;

    final sinal =
        percentual >= 0 ? '+' : '';

    return '$sinal${percentual.toStringAsFixed(0)}%';
  }

  Color _corVariacao(
    int atual,
    int anterior,
  ) {
    if (anterior == 0) {
      return Colors.grey;
    }

    return atual >= anterior
        ? Colors.greenAccent
        : Colors.redAccent;
  }

  Widget _card({
    required Widget child,
  }) {
    return Card(
      color: const Color(0xFF20232B),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }

  Widget _variacaoWidget(
    int atual,
    int anterior,
  ) {
    final texto =
        _variacao(atual, anterior);

    final positivo =
        anterior == 0
            ? null
            : atual >= anterior;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (positivo != null)
          Icon(
            positivo
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            size: 16,
            color: _corVariacao(
              atual,
              anterior,
            ),
          ),
        Text(
          texto,
          style: TextStyle(
            color: _corVariacao(
              atual,
              anterior,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _diaNome(int indice) {
    const dias = [
      'Seg',
      'Ter',
      'Qua',
      'Qui',
      'Sex',
      'Sáb',
      'Dom',
    ];

    return dias[indice];
  }

  @override
  Widget build(BuildContext context) {
    final hoje =
        StorageService.tempoDeHoje();

    final ontem =
        StorageService.tempoDeOntem();

    final semana =
        StorageService.tempoDaSemana();

    final semanaAnterior =
        StorageService.tempoDaSemanaAnterior();

    final tempos =
        StorageService.temposDaSemana();

    final temposAnteriores =
        StorageService.temposDaSemanaAnterior();

    final maiorTempo =
        tempos.fold<int>(
      0,
      (maior, atual) =>
          atual > maior ? atual : maior,
    );

    final melhorDia = tempos.indexWhere(
      (tempo) =>
          tempo ==
          maiorTempo,
    );

    final menorTempoPositivo =
        tempos
            .where((tempo) => tempo > 0)
            .fold<int>(
              0,
              (menor, atual) {
                if (menor == 0) return atual;
                return atual < menor
                    ? atual
                    : menor;
              },
            );

    final piorDia =
        menorTempoPositivo == 0
            ? -1
            : tempos.indexWhere(
                (tempo) =>
                    tempo ==
                    menorTempoPositivo,
              );

    return Scaffold(
      backgroundColor:
          const Color(0xFF181A20),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF181A20),
        elevation: 0,
        title: const Text('Progresso'),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },

        child: ListView(
          padding:
              const EdgeInsets.all(20),

          children: [
            const Text(
              'TEMPO DE ESTUDO',
              style: TextStyle(
                fontSize: 14,
                color: Colors.greenAccent,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _card(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hoje',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatarTempo(hoje),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        'vs. ontem  ',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      _variacaoWidget(
                        hoje,
                        ontem,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _card(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Esta semana',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatarTempo(semana),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        'vs. semana anterior  ',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      _variacaoWidget(
                        semana,
                        semanaAnterior,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'SEMANA',
              style: TextStyle(
                fontSize: 14,
                color: Colors.greenAccent,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _card(
              child: Column(
                children: List.generate(
                  7,
                  (index) {
                    final tempo =
                        tempos[index];

                    final anterior =
                        temposAnteriores[
                            index];

                    final largura =
                        maiorTempo == 0
                            ? 0.0
                            : tempo /
                                maiorTempo;

                    return Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 7,
                      ),

                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 38,
                                child: Text(
                                  _diaNome(
                                    index,
                                  ),
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    10,
                                  ),
                                  child:
                                      LinearProgressIndicator(
                                    value:
                                        largura,
                                    minHeight:
                                        10,
                                    backgroundColor:
                                        Colors
                                            .white12,
                                    color: Colors
                                        .greenAccent,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              SizedBox(
                                width: 72,
                                child: Text(
                                  _formatarTempo(
                                    tempo,
                                  ),
                                  textAlign:
                                      TextAlign
                                          .right,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 3,
                          ),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .end,
                            children: [
                              _variacaoWidget(
                                tempo,
                                anterior,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'Melhor dia',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          melhorDia >= 0
                              ? _diaNome(
                                  melhorDia,
                                )
                              : '—',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        if (melhorDia >= 0)
                          Text(
                            _formatarTempo(
                              maiorTempo,
                            ),
                            style:
                                const TextStyle(
                              color: Colors
                                  .greenAccent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'Menor dia',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          piorDia >= 0
                              ? _diaNome(
                                  piorDia,
                                )
                              : '—',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        if (piorDia >= 0)
                          Text(
                            _formatarTempo(
                              menorTempoPositivo,
                            ),
                            style:
                                const TextStyle(
                              color:
                                  Colors.orangeAccent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Os dados mostram seu tempo real de estudo. '
              'Não existe uma meta fixa de horas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}