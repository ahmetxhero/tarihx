import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/ad_service.dart';
import 'widgets/banner_ad_widget.dart';

class WikiWebViewPage extends StatelessWidget {
  final String url;
  const WikiWebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia'),
      ),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controller)),
          BannerAdWidget(adUnitId: AdService.bannerAdUnitId),
        ],
      ),
    );
  }
}
