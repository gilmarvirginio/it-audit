import 'package:flutter/material.dart';

import '../models/disciplina.dart';
import '../services/ciclo_service.dart';
import 'aulas_page.dart';
import 'estudo_aula_page.dart';

class EstudoPage extends StatefulWidget {
  final Disciplina disciplina;
  final CicloService cicloService;

  const EstudoPage({
    super.key,
    required this.disciplina,
    required this.cicloService,
  });

  @override
  State<EstudoPage> createState() => _EstudoPageState();
}

class _EstudoPageState extends State<EstudoPage> {

  // Abre a aula atual.
  Future<void> iniciarCiclo() async {
  final disciplina = widget.disciplina;

  // ============================================================
  // PRIMEIRO ACESSO OU PRÓXIMA AULA AINDA NÃO CADASTRADA
  // ============================================================

  if (disciplina.aulas.isEmpty ||
      disciplina.indiceAulaAtual >= disciplina.aulas.length) {
    final resultadoCadastro = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AulasPage(
          disciplina: disciplina,
        ),
      ),
    );

    // Se nenhuma aula foi cadastrada, não continua.
    if (resultadoCadastro != true ||
        disciplina.aulas.isEmpty ||
        !mounted) {
      return;
    }
  }

  // ============================================================
  // PEGA A AULA ATUAL
  // ============================================================

  final aula = disciplina.aulaAtual;

  if (aula == null) {
    return;
  }

  // ============================================================
  // ABRE A AULA
  // ============================================================

  final resultado = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EstudoAulaPage(
        aula: aula,
        disciplinaNome: disciplina.nome,
      ),
    ),
  );

  // ============================================================
  // SE CONCLUIU A AULA:
  // AVANÇA PARA A PRÓXIMA
  // ============================================================

  if (resultado == true) {
    disciplina.concluirAulaAtual();
  }

  if (mounted) {
    setState(() {});
  }
}

  void concluirDisciplina() {
    widget.cicloService.concluirDisciplina(
      widget.disciplina,
    );

    Navigator.pop(context, true);
  }

    @override
  Widget build(BuildContext context) {
    final disciplina = widget.disciplina;

    return Scaffold(
      appBar: AppBar(
        title: Text(disciplina.nome),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            const SizedBox(height: 40),

            Text(
              disciplina.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            FilledButton.icon(
              onPressed: iniciarCiclo,

              icon: const Icon(
                Icons.play_arrow,
              ),

              label: const Text(
                'INICIAR CICLO',
              ),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: concluirDisciplina,

              icon: const Icon(
                Icons.check,
              ),

              label: const Text(
                'CONCLUIR DISCIPLINA',
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}