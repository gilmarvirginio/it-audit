import 'dart:async';
import 'package:flutter/material.dart';

import '../models/aula.dart';

class EstudoAulaPage extends StatefulWidget {
  final Aula aula;
  final String disciplinaNome;

  const EstudoAulaPage({
    super.key,
    required this.aula,
    required this.disciplinaNome,
  });

  @override
  State<EstudoAulaPage> createState() => _EstudoAulaPageState();
}

class _EstudoAulaPageState extends State<EstudoAulaPage> {
  Timer? _timer;
  @override
void initState() {
  super.initState();

  _timer = Timer.periodic(
    const Duration(seconds: 1),
    (timer) {
      setState(() {
        widget.aula.segundosEstudados++;
      });
    },
  );
}
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
  void alterarPaginas(int valor) {
    setState(() {
      widget.aula.paginasLidas += valor;

      if (widget.aula.paginasLidas < 0) {
        widget.aula.paginasLidas = 0;
      }

      if (widget.aula.paginasLidas > widget.aula.totalPaginas) {
        widget.aula.paginasLidas = widget.aula.totalPaginas;
      }
    });
  }

  void alterarVideos(int valor) {
    setState(() {
      widget.aula.videosAssistidos += valor;

      if (widget.aula.videosAssistidos < 0) {
        widget.aula.videosAssistidos = 0;
      }

      if (widget.aula.videosAssistidos > widget.aula.totalVideos) {
        widget.aula.videosAssistidos = widget.aula.totalVideos;
      }
    });
  }

  void alterarQuestoes(int valor) {
    setState(() {
      widget.aula.questoesResolvidas += valor;

      if (widget.aula.questoesResolvidas < 0) {
        widget.aula.questoesResolvidas = 0;
      }

      final minimo =
          widget.aula.acertos + widget.aula.erros;

      if (widget.aula.questoesResolvidas < minimo) {
        widget.aula.questoesResolvidas = minimo;
      }
    });
  }

 void alterarAcertos(int valor) {
  setState(() {
    widget.aula.acertos += valor;

    if (widget.aula.acertos < 0) {
      widget.aula.acertos = 0;
    }

    widget.aula.questoesResolvidas =
        widget.aula.acertos + widget.aula.erros;
  });
}

  void alterarErros(int valor) {
  setState(() {
    widget.aula.erros += valor;

    if (widget.aula.erros < 0) {
      widget.aula.erros = 0;
    }

    widget.aula.questoesResolvidas =
        widget.aula.acertos + widget.aula.erros;
  });
}
String _formatarTempo(int segundos) {
  final horas = segundos ~/ 3600;
  final minutos = (segundos % 3600) ~/ 60;
  final segundosRestantes = segundos % 60;

  return '${horas.toString().padLeft(2, '0')}:'
      '${minutos.toString().padLeft(2, '0')}:'
      '${segundosRestantes.toString().padLeft(2, '0')}';
}
  @override
  Widget build(BuildContext context) {
    final aula = widget.aula;

    final progressoPaginas = aula.totalPaginas == 0
        ? 0.0
        : aula.paginasLidas / aula.totalPaginas;

    final progressoVideos = aula.totalVideos == 0
        ? 0.0
        : aula.videosAssistidos / aula.totalVideos;

    return Scaffold(
      appBar: AppBar(
        title: Text(aula.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.disciplinaNome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              aula.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),
const SizedBox(height: 15),

Text(
  _formatarTempo(aula.segundosEstudados),
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 5),

const Text(
  'Tempo estudado',
  textAlign: TextAlign.center,
  style: TextStyle(
    color: Colors.grey,
  ),
),

const SizedBox(height: 20),
            _tituloSecao(
              Icons.picture_as_pdf,
              'PDF',
              Colors.red,
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: progressoPaginas.clamp(0.0, 1.0),
              minHeight: 10,
            ),

            const SizedBox(height: 8),

            Text(
              '${aula.paginasLidas} / ${aula.totalPaginas} páginas',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            _contador(
              valor: aula.paginasLidas,
              diminuir: () => alterarPaginas(-1),
              aumentar: () => alterarPaginas(1),
            ),

            const SizedBox(height: 25),

            _tituloSecao(
              Icons.video_library,
              'VÍDEO-AULAS',
              Colors.blue,
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: progressoVideos.clamp(0.0, 1.0),
              minHeight: 10,
              color: Colors.blue,
            ),

            const SizedBox(height: 8),

            Text(
              '${aula.videosAssistidos} / ${aula.totalVideos} vídeos',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            _contador(
              valor: aula.videosAssistidos,
              diminuir: () => alterarVideos(-1),
              aumentar: () => alterarVideos(1),
            ),

            const SizedBox(height: 25),

            _tituloSecao(
              Icons.quiz,
              'QUESTÕES',
              Colors.orange,
            ),

            const SizedBox(height: 8),

            Text(
  '${aula.questoesResolvidas} resolvidas',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

            
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _contadorResultado(
                  icone: Icons.check_circle,
                  cor: Colors.green,
                  valor: aula.acertos,
                  diminuir: () => alterarAcertos(-1),
                  aumentar: () => alterarAcertos(1),
                ),

                _contadorResultado(
                  icone: Icons.cancel,
                  cor: Colors.red,
                  valor: aula.erros,
                  diminuir: () => alterarErros(-1),
                  aumentar: () => alterarErros(1),
                ),
              ],
            ),

            const SizedBox(height: 25),

            _tituloSecao(
              Icons.refresh,
              'REVISÕES',
              Colors.purple,
            ),

            const SizedBox(height: 8),

            ...List.generate(
              aula.revisoes.length,
              (index) {
                return CheckboxListTile(
                  value: aula.revisoes[index],
                  title: Text(
                    'Revisão ${index + 1}',
                  ),
                  secondary: Icon(
                    aula.revisoes[index]
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: aula.revisoes[index]
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onChanged: (valor) {
                    setState(() {
                      aula.revisoes[index] =
                          valor ?? false;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: () {
                widget.aula.concluida = true;

                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.check),
              label: const Text('CONCLUIR AULA'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _tituloSecao(
    IconData icone,
    String titulo,
    Color cor,
  ) {
    return Row(
      children: [
        Icon(
          icone,
          color: cor,
        ),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ],
    );
  }

  Widget _contador({
    required int valor,
    required VoidCallback diminuir,
    required VoidCallback aumentar,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: diminuir,
          icon: const Icon(
            Icons.remove_circle,
          ),
          iconSize: 38,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            '$valor',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        IconButton(
          onPressed: aumentar,
          icon: const Icon(
            Icons.add_circle,
          ),
          iconSize: 38,
        ),
      ],
    );
  }

  Widget _contadorResultado({
    required IconData icone,
    required Color cor,
    required int valor,
    required VoidCallback diminuir,
    required VoidCallback aumentar,
  }) {
    return Row(
      children: [
        Icon(
          icone,
          color: cor,
        ),

        IconButton(
          onPressed: diminuir,
          icon: const Icon(
            Icons.remove_circle_outline,
          ),
        ),

        Text(
          '$valor',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        IconButton(
          onPressed: aumentar,
          icon: const Icon(
            Icons.add_circle_outline,
          ),
        ),
      ],
    );
  }
}