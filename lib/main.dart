import 'package:flutter/material.dart';
import 'home_page.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.carregarTudo();
  StorageService.iniciarAutoSave();

runApp(const ITAuditApp());
}

class ITAuditApp extends StatelessWidget {
  const ITAuditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IT Audit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

