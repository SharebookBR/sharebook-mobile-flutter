# CLAUDE.md — sharebook-mobile

App Flutter que embrulha https://www.sharebook.com.br num WebView Android.
Substitui o app Ionic legado na Play Store (package: `com.makeztec.sharebook`).

Para contexto completo do ecossistema e sobre o Raffa, ler `C:\REPOS\SHAREBOOK\CLAUDE.md`.

---

## Arquitetura

```
lib/
├── main.dart                  # MaterialApp, tema azul #29ABE2
├── config/app_config.dart     # Todas as URLs e domínios internos
├── pages/
│   ├── welcome_page.dart      # Logo largo + slogan + Entrar + Sobre
│   ├── webview_page.dart      # WebView + loading + erro + back button + câmera
│   └── about_page.dart        # Logo largo + história + links
└── widgets/error_view.dart    # Tela de erro com retry
```

---

## Decisões técnicas

- `webview_flutter` (não flutter_inappwebview) — simples e suficiente
- `image_picker` com `ImageSource.camera` — abre câmera direta pro upload de capa
- `platform=android` na baseUrl — Angular pode detectar (backlog, não implementado)
- NDK hardcoded: `ndkVersion = "27.0.12077973"` (não usar flutter.ndkVersion)
- Links externos: requer `<queries>` no AndroidManifest para Android 11+
- Cor primária: `#29ABE2`

---

## Play Store

- **Package**: `com.makeztec.sharebook`
- **Versão em revisão**: 2.0.1+20001
- **versionCode publicado (Ionic)**: 10800
- **Google Play App Signing**: ATIVO — Google assina o APK final
- **Keystore**: `android/sharebook.keystore` — NÃO commitar `android/key.properties`

---

## Ambiente

- Java: temurin-21 (IntelliJ managed JDKs em `C:\Users\brnra019\.jdks\`)
- Android SDK: `C:\Android\sdk`
- Flutter 3.29.3 stable

---

## Comandos

```bash
flutter build appbundle                      # release para Play Store
flutter build apk --debug                   # APK de teste
dart run flutter_native_splash:create       # gerar splash
flutter clean && flutter build apk --debug  # rebuild do zero
```

---

## Pendências

1. Aguardar aprovação Play Store (2.0.1)
2. Ícone adaptive — atual usa PNGs simples; Android moderno prefere adaptive icons
3. Reavaliar bottom nav Flutter — Angular já tem bottom nav própria em produção
