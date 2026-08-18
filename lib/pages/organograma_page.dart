import 'package:flutter/material.dart';

class OrganogramaPage extends StatefulWidget {
  const OrganogramaPage({super.key});

  @override
  State<OrganogramaPage> createState() =>
      _OrganogramaPageState();
}

class _OrganogramaPageState
    extends State<OrganogramaPage> {
  // ============================================================
  // SENHA DO ORGANOGRAMA
  // ============================================================

  static const String _senhaCorreta = '1035';

  final TextEditingController _senhaController =
      TextEditingController();

  bool _senhaIncorreta = false;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  void _verificarSenha() {
    if (_senhaController.text == _senhaCorreta) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _ImagemOrganogramaPage(),
        ),
      );

      return;
    }

    setState(() {
      _senhaIncorreta = true;
    });

    _senhaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        title: const Text('Organograma'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: const Color(0xFF20232B),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_tree,
                    size: 64,
                    color: Colors.greenAccent,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Organograma do ciclo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Digite a senha de 4 dígitos para acessar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: _senhaController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      letterSpacing: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••',
                      errorText: _senhaIncorreta
                          ? 'Senha incorreta'
                          : null,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    onChanged: (_) {
                      if (_senhaIncorreta) {
                        setState(() {
                          _senhaIncorreta = false;
                        });
                      }
                    },
                    onSubmitted: (_) {
                      _verificarSenha();
                    },
                  ),

                  const SizedBox(height: 20),

                  FilledButton.icon(
                    onPressed: _verificarSenha,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('ACESSAR'),
                    style: FilledButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 52),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagemOrganogramaPage extends StatelessWidget {
  const _ImagemOrganogramaPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Organograma'),
        centerTitle: true,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.asset(
                'assets/organograma.png',
            fit: BoxFit.contain,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  'Imagem do organograma não encontrada.\n\n'
                  'Adicione o arquivo:\n'
                  'assets/organograma.png',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}