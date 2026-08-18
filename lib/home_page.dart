import 'package:flutter/material.dart';
import 'data/disciplinas.dart';
import 'services/ciclo_service.dart';
import 'pages/estudo_page.dart';
import 'pages/config_page.dart';
import 'pages/progresso_page.dart';
import 'services/storage_service.dart';
import 'pages/organograma_page.dart';
import 'pages/revisao_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CicloService ciclo = CicloService(listaDisciplinas);

  int _indiceSelecionado = 0;   


   
   Widget card(
  BuildContext context, {
  required IconData icon,
  required String titulo,
  required String subtitulo,
  required Color cor,
  VoidCallback? onTap,
}){
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: cor,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),

      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        centerTitle: true,
        title: const Text("IT Audit"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "SISTEMA DE ESTUDOS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Auditor Fiscal de TI",
              style: TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
              ),
            ),
          ),

          const SizedBox(height: 30),

          const SizedBox(height: 8),

        Center(
          child: Text(
            "Ciclo atual: ${ciclo.cicloAtual.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
        ),

          card(
            context,
            icon: Icons.play_circle_fill,
            titulo: "Próxima disciplina",
            subtitulo: ciclo.proximaDisciplina().nome,
            cor: Colors.green,
          ),

          card(
            context,
            icon: Icons.bar_chart,
            titulo: "Progresso Geral",
            subtitulo:  
            "${ciclo.concluidas()}/${listaDisciplinas.length} disciplinas",
            cor: Colors.orange,
          ),
                    card(
            context,
            icon: Icons.timer,
            titulo: "Tempo Estudado",
            subtitulo:
                "${StorageService.tempoTotalHistorico() ~/ 3600}h "
                "${((StorageService.tempoTotalHistorico() % 3600) ~/ 60).toString().padLeft(2, '0')}min",
            cor: Colors.green,
          ),
                    card(
            context,
            icon: Icons.account_tree,
            titulo: "Organograma",
            subtitulo: "Visualizar estrutura do ciclo",
            cor: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrganogramaPage(),
                ),
              );
            },
          ),

          card(
            context,
            icon: Icons.quiz,
            titulo: "Questões",
            subtitulo: "${ciclo.totalQuestoes()} resolvidas",
            cor: Colors.deepOrange,
          ),

          const SizedBox(height: 20),
                    const Text(
            "Disciplinas do Ciclo",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

                  ...listaDisciplinas.map(
          (disciplina) => card(
            context,
            icon: Icons.menu_book,
            titulo: disciplina.nome,
            subtitulo: disciplina.categoria,
            cor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                 builder: (_) => EstudoPage(
                disciplina: disciplina,
                cicloService: ciclo,
              ),
                ),
              );
            },
          ),
        ),

          const SizedBox(height: 30),

          FilledButton.icon(
  style: FilledButton.styleFrom(
    minimumSize: const Size(double.infinity, 55),
  ),
  onPressed: () async {
  final disciplina = ciclo.proximaDisciplina();

  final atualizou = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EstudoPage(
        disciplina: disciplina,
        cicloService: ciclo,
      ),
    ),
  );

  if (atualizou == true && mounted) {
    setState(() {});
  }
},
  icon: const Icon(Icons.play_arrow),
  label: const Text("INICIAR CICLO"),
),

          const SizedBox(height: 40),
          const SizedBox(height: 40),
        ],
      ),

    bottomNavigationBar: NavigationBar(
      selectedIndex: _indiceSelecionado,

      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
    ),
  ),

  onDestinationSelected: (index) {
  setState(() {
    _indiceSelecionado = index;
  });
        if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RevisaoPage(),
          ),
        ).then((_) {
          if (mounted) {
            setState(() {});
          }
        });
      }
  
      if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OrganogramaPage(),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }

  if (index == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProgressoPage(),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  if (index == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfigPage(),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
},  


  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: "Início",
    ),

          NavigationDestination(
        icon: Icon(Icons.style),
        label: "Revisão",
      ),

        NavigationDestination(
      icon: Icon(Icons.account_tree),
      label: "Organograma",
    ),

    NavigationDestination(
      icon: Icon(Icons.bar_chart),
      label: "Progresso",
    ),

    NavigationDestination(
      icon: Icon(Icons.settings),
      label: "Config.",
    ),
  ],
),
    );
  }
}