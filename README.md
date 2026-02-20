# Sharebook Shell

App Android que embrulha o site responsivo do [Sharebook](https://www.sharebook.com.br) num WebView, com telas nativas de entrada e sobre para cumprir as diretrizes da Google Play.

## Fluxo do app

```
Splash → Welcome (nativa) → WebView (site) ou About (nativa)
```

1. **Splash**: tela branca com logo (configurável via `flutter_native_splash`)
2. **Welcome**: logo + texto + botões "Entrar", "Abrir no navegador" e "Sobre"
3. **WebView**: carrega o site. Links internos (`sharebook.com.br`) ficam no WebView; links externos abrem no browser do sistema
4. **About**: versão do app + links (site, privacidade, termos de uso)

### Back button (Android)

- Se o WebView tem histórico → volta a página
- Se não tem → exibe diálogo "Sair do app?" com Cancelar / Sair

### Erro de carregamento

Tela amigável com botão "Tentar novamente" que recarrega a URL base.

## Como rodar

```bash
flutter pub get
flutter run
```

## Como gerar AAB (para Play Store)

```bash
flutter build appbundle
```

O arquivo `.aab` será gerado em `build/app/outputs/bundle/release/`.

### Versão

A versão do app é definida no `pubspec.yaml` na linha `version:`:

```yaml
version: 1.0.0+1
#         │       └── buildNumber (versionCode no Android)
#         └────────── versionName
```

Para atualizar antes de publicar, basta alterar esse valor. Exemplo: `1.1.0+2`.

### Assinatura de release

Para publicar na Play Store, você precisa assinar o app:

1. Gere uma keystore (uma vez só):
   ```bash
   keytool -genkey -v -keystore ~/sharebook-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sharebook
   ```

2. Crie o arquivo `android/key.properties` (NÃO comite no git):
   ```properties
   storePassword=SUA_SENHA
   keyPassword=SUA_SENHA
   keyAlias=sharebook
   storeFile=C:/Users/SEU_USER/sharebook-release.jks
   ```

3. O `build.gradle.kts` precisa ser configurado para ler esse arquivo. Consulte a [documentação oficial](https://docs.flutter.dev/deployment/android#sign-the-app).

## Configuração

Todas as URLs e domínios internos ficam em um único arquivo:

**`lib/config/app_config.dart`**

| Constante         | Valor atual                                              |
|--------------------|----------------------------------------------------------|
| `baseUrl`          | `https://www.sharebook.com.br`                           |
| `privacyUrl`       | `https://www.sharebook.com.br/politica-privacidade`      |
| `termsUrl`         | `https://www.sharebook.com.br/termos-de-uso`             |
| `internalDomains`  | `['sharebook.com.br']` (inclui subdomínios automaticamente) |

## Como trocar o logo / splash

1. Substitua `assets/images/logo.png` pelo novo logo (recomendado: 1152x1152 px, PNG com transparência)
2. Rode:
   ```bash
   dart run flutter_native_splash:create
   ```

## Como trocar o ícone do app

Opção manual: substitua os PNGs em `android/app/src/main/res/mipmap-*/ic_launcher.png`.

Opção automatizada: use o package [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons):
1. Adicione ao `dev_dependencies` do `pubspec.yaml`
2. Configure e rode `dart run flutter_launcher_icons`

## Estrutura do projeto

```
lib/
├── main.dart                  # Entry point, MaterialApp
├── config/
│   └── app_config.dart        # URLs, domínios internos, helpers
├── pages/
│   ├── welcome_page.dart      # Tela de entrada nativa
│   ├── webview_page.dart      # WebView + loading + erro + back
│   └── about_page.dart        # Tela "Sobre" nativa
└── widgets/
    └── error_view.dart        # Widget de erro com retry
```

## Dependências

| Package              | Motivo                          |
|----------------------|---------------------------------|
| `webview_flutter`    | WebView oficial do Flutter      |
| `url_launcher`       | Abrir links no browser          |
| `package_info_plus`  | Ler versão do app               |
| `flutter_native_splash` | Splash screen customizado (dev) |

## Fora do escopo (por enquanto)

- Push notifications
- Modo offline
- Login nativo
- iOS (só Android nesta fase)
