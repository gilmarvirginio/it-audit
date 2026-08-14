import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),

      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        title: const Text("Configurações"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),

                title: const Text(
                  "Zerar aplicativo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  "Apagar todo o progresso salvo",
                ),

                onTap: () async {
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Zerar aplicativo?",
                        ),

                        content: const Text(
                          "Todos os dados de estudo serão apagados. "
                          "Essa ação não poderá ser desfeita.",
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("CANCELAR"),
                          ),

                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("ZERAR TUDO"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmar == true) {
                    await StorageService.apagarDados();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}