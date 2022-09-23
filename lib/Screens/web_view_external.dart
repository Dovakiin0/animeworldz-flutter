import "package:webview_flutter/webview_flutter.dart";
import "package:flutter/material.dart";

class WebViewExternal extends StatefulWidget {
  const WebViewExternal({super.key});

  @override
  State<WebViewExternal> createState() => _WebViewExternalState();
}

class _WebViewExternalState extends State<WebViewExternal> {
  Map args = {};

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text("External Browser")),
      body: WebView(
        initialUrl: args["uri"],
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
