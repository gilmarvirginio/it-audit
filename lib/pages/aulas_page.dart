import 'package:flutter/material.dart';

import '../models/aula.dart';
import '../models/disciplina.dart';
import 'estudo_aula_page.dart';

class AulasPage extends StatefulWidget {
  final Disciplina disciplina;

  const AulasPage({
    super.key,
    required this.disciplina,
  });

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  void adicionarAula() {
    final nomeController = TextEditingController();
    final paginasController = TextEditingController();
    final videosController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar aula"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome da aula",
                    hintText: "Ex.: Aula 00",
                    prefixIcon: Icon(Icons.menu_book),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: paginasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Páginas do PDF",
                    prefixIcon: Icon(Icons.picture_as_pdf),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: videosController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantidade de vídeos",
                    prefixIcon: Icon(Icons.video_library),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("CANCELAR"),
            ),

            FilledButton(
              onPressed: () {
                final nome = nomeController.text.trim();

                final paginas =
                    int.tryParse(paginasController.text) ?? 0;

                final videos =
                    int.tryParse(videosController.text) ?? 0;

                if (nome.isEmpty || paginas <= 0) {
                  return;
                }

                final aula = Aula(
                  nome: nome,
                  totalPaginas: paginas,
                  totalVideos: videos,
                );

                setState(() {
                  widget.disciplina.adicionarAula(aula);
                });

                Navigator.pop(context, true);
              },
              child: const Text("ADICIONAR"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final aulas = widget.disciplina.aulas;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.disciplina.nome),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: aulas.isEmpty
            ? const Center(
                child: Text(
                  "Nenhuma aula cadastrada.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: aulas.length,
                itemBuilder: (context, index) {
                  final aula = aulas[index];

                  return Card(
  margin: const EdgeInsets.only(bottom: 12),

  child: ListTile(
    leading: const CircleAvatar(
      child: Icon(Icons.menu_book),
    ),

    title: Text(
      aula.nome,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),

    subtitle: Text(
      "${aula.totalPaginas} páginas  •  "
      "${aula.totalVideos} vídeos",
    ),

    trailing: const Icon(
      Icons.arrow_forward_ios,
      size: 18,
    ),

    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EstudoAulaPage(
            aula: aula,
            disciplinaNome: widget.disciplina.nome,
          ),
        ),
      );
    },
  ),
);
                },
              ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: adicionarAula,
        icon: const Icon(Icons.add),
        label: const Text("ADICIONAR AULA"),
      ),
    );
  }
}