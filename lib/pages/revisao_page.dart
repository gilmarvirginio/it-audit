
import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class RevisaoPage extends StatefulWidget {
  const RevisaoPage({super.key});

  @override
  State<RevisaoPage> createState() =>
      _RevisaoPageState();
}

class _RevisaoPageState extends State<RevisaoPage> {
  int flashcards = 0;
  int ebooks = 0;
  int mapasMentais = 0;
  @override
  void initState() {
    super.initState();
    _carregarContadores();
  }

  void _carregarContadores() {
    int totalFlashcards = 0;
    int totalEbooks = 0;
    int totalMapasMentais = 0;

    for (final revisao in StorageService.revisoes) {
      if (revisao.tipo == 'Flashcards') {
        totalFlashcards += revisao.quantidade;
      } else if (revisao.tipo == 'E-books') {
        totalEbooks += revisao.quantidade;
      } else if (revisao.tipo == 'Mapas mentais') {
        totalMapasMentais += revisao.quantidade;
      }
    }

    setState(() {
      flashcards = totalFlashcards;
      ebooks = totalEbooks;
      mapasMentais = totalMapasMentais;
    });
  }

  Widget _historicoRevisoes() {
  final revisoes =
      StorageService.revisoes.reversed.toList();

  if (revisoes.isEmpty) {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Nenhuma revisão registrada ainda.',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),

      const Text(
        'HISTÓRICO DE REVISÕES',
        style: TextStyle(
          fontSize: 14,
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 14),

      ...revisoes.map(
        (revisao) => Card(
          color: const Color(0xFF20232B),
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  revisao.tipo ==
                          'Flashcards'
                      ? Icons.style
                      : revisao.tipo ==
                              'E-books'
                          ? Icons.menu_book
                          : Icons.account_tree,
                  color:
                      revisao.tipo ==
                              'Flashcards'
                          ? Colors.blueAccent
                          : revisao.tipo ==
                                  'E-books'
                              ? Colors.orangeAccent
                              : Colors.purpleAccent,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        revisao.tipo,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        revisao.assunto,
                        style:
                            const TextStyle(
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Quantidade: ${revisao.quantidade}',
                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Data: '
                        '${revisao.data.day.toString().padLeft(2, '0')}/'
                        '${revisao.data.month.toString().padLeft(2, '0')}/'
                        '${revisao.data.year}',
                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> _confirmarZerarRevisoes() async {
  final confirmar =
      await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Zerar revisões?',
        ),
        content: const Text(
          'Todas as revisões salvas serão apagadas. '
          'Essa ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              'CANCELAR',
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              'ZERAR',
            ),
          ),
        ],
      );
    },
  );

  if (confirmar != true) {
    return;
  }

  await StorageService.apagarRevisoes();

  _carregarContadores();

  if (mounted) {
    setState(() {});
  }
}
  void _abrirRegistro(String tipo) {
    final assuntoController =
        TextEditingController();

    int quantidade = 1;
    DateTime data = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF20232B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom:
                    MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    tipo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Assunto / matéria',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: assuntoController,
                    decoration: InputDecoration(
                      hintText:
                          'Ex.: Banco de Dados',
                      filled: true,
                      fillColor:
                          const Color(0xFF181A20),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Quantidade',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantidade > 1) {
                            setModalState(() {
                              quantidade--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          size: 32,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Text(
                        '$quantidade',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 20),

                      IconButton(
                        onPressed: () {
                          setModalState(() {
                            quantidade++;
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Data da revisão',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  OutlinedButton.icon(
                    onPressed: () async {
                      final escolhida =
                          await showDatePicker(
                        context: context,
                        initialDate: data,
                        firstDate:
                            DateTime(2020),
                        lastDate:
                            DateTime(2100),
                      );

                      if (escolhida != null) {
                        setModalState(() {
                          data = escolhida;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                    label: Text(
                      '${data.day.toString().padLeft(2, '0')}/'
                      '${data.month.toString().padLeft(2, '0')}/'
                      '${data.year}',
                    ),
                  ),

                  const SizedBox(height: 24),

                                   SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final assunto =
                            assuntoController.text.trim();

                        if (assunto.isEmpty) {
                          return;
                        }

                        await StorageService.registrarRevisao(
                          tipo: tipo,
                          assunto: assunto,
                          quantidade: quantidade,
                          data: data,
                          segundosEstudados: 0,
                        );

                        Navigator.pop(context);

                        _carregarContadores();
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                      label: const Text(
                        'SALVAR REVISÃO',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _card({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required int quantidade,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF20232B),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: cor,
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitulo,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  '$quantidade',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.add),
                label: const Text(
                  'REGISTRAR REVISÃO',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF181A20),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF181A20),
        elevation: 0,
        centerTitle: true,
        title: const Text('Revisão'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          const Text(
            'REVISÃO',
            style: TextStyle(
              fontSize: 14,
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Acompanhe o que você revisou.',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Registre seus flashcards, e-books e mapas mentais.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 25),

          _card(
            icon: Icons.style,
            titulo: 'Flashcards',
            subtitulo:
                'Flashcards revisados',
            quantidade: flashcards,
            cor: Colors.blueAccent,
            onTap: () =>
                _abrirRegistro('Flashcards'),
          ),

          const SizedBox(height: 14),

          _card(
            icon: Icons.menu_book,
            titulo: 'E-books',
            subtitulo: 'Sessões de leitura',
            quantidade: ebooks,
            cor: Colors.orangeAccent,
            onTap: () =>
                _abrirRegistro('E-books'),
          ),

          const SizedBox(height: 14),

          _card(
            icon: Icons.account_tree,
            titulo: 'Mapas mentais',
            subtitulo: 'Mapas revisados',
            quantidade: mapasMentais,
            cor: Colors.purpleAccent,
            onTap: () =>
                _abrirRegistro(
                    'Mapas mentais'),
          ),

          const SizedBox(height: 30),

_historicoRevisoes(),

const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  height: 52,
  child: OutlinedButton.icon(
    onPressed:
        _confirmarZerarRevisoes,
    icon: const Icon(
      Icons.delete_outline,
    ),
    label: const Text(
      'ZERAR TODAS AS REVISÕES',
    ),
  ),
),

const SizedBox(height: 20),
        ],
      ),
    );
  }
}


