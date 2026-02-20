import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import 'about_page.dart';
import 'webview_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/logo.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 8),
              const Text(
                AppConfig.appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WebViewPage()),
                  ),
                  child: const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutPage()),
                  ),
                  child: const Text('Sobre'),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _openInBrowser(AppConfig.privacyUrl),
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text(
                  'Política de Privacidade',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
