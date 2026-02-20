import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const SharebookApp());
}

class SharebookApp extends StatelessWidget {
  const SharebookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF29ABE2),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
