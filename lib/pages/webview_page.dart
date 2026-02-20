import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../config/app_config.dart';
import '../widgets/error_view.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame ?? true) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
          onNavigationRequest: (request) {
            if (AppConfig.isInternalUrl(request.url)) {
              return NavigationDecision.navigate;
            }
            _openExternalUrl(request.url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConfig.baseUrl));

    _configureAndroidFileSelector();
  }

  void _configureAndroidFileSelector() {
    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setOnShowFileSelector(_handleFileSelector);
    }
  }

  Future<List<String>> _handleFileSelector(FileSelectorParams params) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return [];
    return [Uri.file(image.path).toString()];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBackButton();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              if (_hasError)
                ErrorView(onRetry: _retry)
              else
                WebViewWidget(controller: _controller),
              if (_isLoading)
                const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBackButton() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return;
    }

    if (!mounted) return;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      Navigator.pop(context);
    }
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller.loadRequest(Uri.parse(AppConfig.baseUrl));
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
