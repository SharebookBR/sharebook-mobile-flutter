class AppConfig {
  AppConfig._();

  static const String appName = 'Sharebook';
  static const String appDescription = 'Seu app livre e gratuito para doar e ganhar livros!';

  static const String baseUrl = 'https://www.sharebook.com.br?platform=android';
  static const String privacyUrl = 'https://www.sharebook.com.br/politica-privacidade';
  static const String termsUrl = 'https://www.sharebook.com.br/termos-de-uso';
  static const String aboutUrl = 'https://www.sharebook.com.br/quem-somos';

  /// Domínios que devem abrir dentro do WebView (navegação interna).
  static const List<String> internalDomains = [
    'sharebook.com.br',
  ];

  /// Verifica se a URL deve ser tratada como navegação interna.
  static bool isInternalUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;

    final host = uri.host.toLowerCase();
    return internalDomains.any(
      (domain) => host == domain || host.endsWith('.$domain'),
    );
  }
}
