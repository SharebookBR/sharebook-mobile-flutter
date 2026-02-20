import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/logo.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 8),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final info = snapshot.data!;
                return Text(
                  'Versão ${info.version}+${info.buildNumber}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              AppConfig.appDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Nossa história',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Meu nome é Raffaello Damgaard, sou desenvolvedor há mais de '
              '20 anos e sempre tive o sonho de colaborar num projeto gratuito '
              'e de código aberto que pudesse ajudar as pessoas.\n\n'
              'Tudo começou quando o Vagner Nunes ajudou um cara humilde que '
              'nunca tinha ganhado um livro na vida. Pode até parecer pouco, '
              'mas tem muita gente pra quem esse simples gesto faz uma grande '
              'diferença.\n\n'
              'Inspirados no modelo do Uber — que não tem carro próprio, mas '
              'junta as pontas — criamos o Sharebook. O livro não passa pela '
              'nossa mão. O doador cadastra, nós avaliamos e aprovamos, e o '
              'livro vai para a vitrine. Simples assim.\n\n'
              'O Sharebook é um projeto livre, gratuito e de código aberto. '
              'Feito por voluntários que acreditam que compartilhar '
              'conhecimento transforma vidas.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Divider(),
            _LinkTile(
              icon: Icons.people_outlined,
              label: 'Conheça o time',
              url: AppConfig.aboutUrl,
            ),
            _LinkTile(
              icon: Icons.language,
              label: 'Abrir site no navegador',
              url: AppConfig.baseUrl,
            ),
            _LinkTile(
              icon: Icons.privacy_tip_outlined,
              label: 'Política de Privacidade',
              url: AppConfig.privacyUrl,
            ),
            _LinkTile(
              icon: Icons.description_outlined,
              label: 'Termos de Uso',
              url: AppConfig.termsUrl,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _LinkTile({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}
