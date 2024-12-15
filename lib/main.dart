import 'package:flutter/material.dart';
import 'package:untitled/utils/common.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  hideStatusBar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100.0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              progress = 1.0;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://radio.santasa.org/'))
      ..enableZoom(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          bool canGoBack = await controller.canGoBack();
          if (canGoBack) {
            controller.goBack();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (progress < 1.0)
              Center(
                child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
