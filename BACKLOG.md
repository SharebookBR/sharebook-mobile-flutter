# Backlog — Bottom Navigation Bar

## Contexto

O app Ionic antigo tinha uma bottom bar nativa com 4 abas (Vitrine, Pedidos, Doações, Mais opções) — sem hamburguer. Os usuários estavam acostumados com essa UX. O objetivo é replicar isso no novo app Flutter.

## Visão geral da solução

1. O Flutter abre o WebView com `?platform=android` na URL
2. O Angular detecta esse parâmetro e esconde o header/navbar do site
3. O Flutter exibe uma `BottomNavigationBar` nativa com 4 abas
4. Cada aba navega o WebView para uma URL específica do site

---

## Tarefa 1 — Frontend Angular: modo app

**Arquivo**: `sharebook-frontend/src/app/components/header/header.component.ts` (e `.html`)

### O que fazer
- Ao inicializar o componente, verificar se `window.location.search` contém `platform=android`
- Se sim, adicionar uma classe CSS (ex: `app-mode`) no `<body>` ou no próprio header
- Essa classe esconde o `<nav>` inteiro via CSS

### Critérios de aceite
- [ ] Acessar `https://www.sharebook.com.br?platform=android` esconde o header
- [ ] Acessar `https://www.sharebook.com.br` (sem parâmetro) mantém o header normal
- [ ] O parâmetro `platform=android` persiste na navegação interna (verificar se Angular Router preserva query params)
- [ ] Testar nas 4 rotas principais

### Atenção
- O parâmetro deve ser propagado nas navegações internas (Angular Router). Avaliar se é necessário usar `queryParamsHandling: 'preserve'` nas rotas ou setar um flag em memória/localStorage na primeira carga.
- Sugestão: ao detectar `platform=android`, salvar em `sessionStorage` para não depender da query string em todas as rotas.
- **Cuidado com o spacer**: logo após o `</nav>` existe um `<div style="height: 118px">` que compensa o `fixed-top`. Ao esconder o nav em modo app, esse spacer também precisa ser escondido — senão fica 118px de branco no topo de cada página.

---

## Tarefa 2 — Flutter: BottomNavigationBar

**Arquivo**: `lib/pages/webview_page.dart` (refatorar) + novo `lib/widgets/app_bottom_nav.dart`

### URLs das abas
| Aba | Ícone sugerido | URL |
|-----|---------------|-----|
| Vitrine | `menu_book` | `https://www.sharebook.com.br?platform=android` |
| Pedidos | `inbox` | `https://www.sharebook.com.br/book/requesteds?platform=android` |
| Doações | `volunteer_activism` | `https://www.sharebook.com.br/book/donations?platform=android` |
| Mais opções | `settings` | `https://www.sharebook.com.br/configuracoes?platform=android` |

### O que fazer
- Adicionar `BottomNavigationBar` com as 4 abas na `WebViewPage`
- Ao trocar de aba, carregar a URL correspondente no WebView (`_controller.loadRequest(...)`)
- Manter a aba selecionada destacada visualmente
- Ajustar o `app_config.dart` com as URLs das abas

### Critérios de aceite
- [ ] Bottom bar visível na tela do WebView
- [ ] Trocar aba navega para a URL correta
- [ ] Aba selecionada fica destacada
- [ ] Back button do Android ainda funciona corretamente (navegar no histórico do WebView, não trocar aba)
- [ ] Pedidos e Doações requerem login — se não logado, o site redireciona para login normalmente

### Atenção
- Avaliar se a bottom bar deve ficar **abaixo** do `SafeArea` ou dentro dela (depende do dispositivo)
- No Fold aberto, a bottom bar pode ocupar muito espaço horizontal — considerar `NavigationRail` para telas largas

---

## Tarefa 3 — Flutter: ajuste do app_config.dart

Adicionar as URLs das abas em `AppConfig`:

```dart
static const String vitrineUrl = 'https://www.sharebook.com.br?platform=android';
static const String pedidosUrl = 'https://www.sharebook.com.br/book/requesteds?platform=android';
static const String doacoesUrl = 'https://www.sharebook.com.br/book/donations?platform=android';
static const String configuracoesUrl = 'https://www.sharebook.com.br/configuracoes?platform=android';
```

E atualizar o `baseUrl` padrão do WebView para incluir `?platform=android`.

---

## Ordem de implementação sugerida

1. **Tarefa 1** (Angular) → buildar e deployar o frontend primeiro
2. **Tarefa 3** (config Flutter) → rápido, sem dependências
3. **Tarefa 2** (Flutter) → depende do frontend estar no ar com o modo app funcionando

---

---

## Tarefa 4 — Flutter: suporte a upload de PDF (livros digitais)

**Contexto**: feature futura de livros em PDF vai exigir que o usuário selecione e envie um arquivo `.pdf` pelo WebView.

### Problema técnico
Hoje o `_handleFileSelector` em `webview_page.dart` abre câmera direto (`ImageSource.camera`). Isso vai precisar ser generalizado: quando o `FileSelectorParams` indicar `application/pdf`, abrir um file picker; quando for imagem, manter câmera.

### O que fazer
- Avaliar `FileSelectorParams.acceptTypes` para detectar o tipo esperado
- Para PDF: usar `file_selector` (flutter/packages oficial) ou `open_filepicker` com filtro `application/pdf`
- Para imagem: manter `ImagePicker` com câmera
- Atenção: `READ_MEDIA_IMAGES` foi explicitamente removido do manifest (Google Play policy). Para acesso a arquivos genéricos, verificar se `READ_MEDIA_VISUAL_USER_SELECTED` (Android 14+) ou `READ_EXTERNAL_STORAGE` (legado) é necessário — e se justifica a política da Play Store.
- Alternativa mais simples: abrir `MediaStore` via `file_selector` com filtro de MIME type; não requer permissão explícita no Android 13+.

### Critérios de aceite
- [ ] Campo de upload de PDF no WebView abre seletor de arquivos filtrando por `.pdf`
- [ ] Campo de upload de imagem continua abrindo câmera
- [ ] App passa na verificação do Play Store sem uso indevido de permissões de mídia

---

## Tarefa 5 — Frontend: corrigir tremido do menu fixo no WebView Android

**Contexto**: `position: fixed` treme levemente ao scrollar no WebView Android. No Chrome desktop não acontece. Mover `overflow-x: hidden` de `html` para `body` (já feito) não resolveu.

**Possíveis causas:**
- WebView Android tem comportamento diferente do Chrome para `position: fixed` com scroll
- Dynamic toolbar do browser causando reflow (menos provável no WebView)
- Algum `transform` ou `will-change` nos ancestrais criando novo stacking context

**Caminhos a investigar:**
- Adicionar `transform: translateZ(0)` ou `will-change: transform` nos elementos fixos (força GPU layer)
- Usar `-webkit-overflow-scrolling: touch` no scroll container
- Checar se algum componente pai tem `transform` que quebre o `fixed`

**Severidade:** baixa — funcional, apenas cosmético.

---

## Observações finais

- As rotas `/book/requesteds` e `/book/donations` têm `canActivate: [AuthGuardUser]` — usuário não logado é redirecionado para login automaticamente pelo Angular. Não precisamos tratar isso no Flutter.
- A aba "Mais opções" pode apontar para `/configuracoes` inicialmente. Avaliar se faz mais sentido apontar para `/myaccount` ou criar uma página agregadora no Angular.
