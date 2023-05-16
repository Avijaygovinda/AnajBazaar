import 'package:anaj_bazar/Constants/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url, required this.titles});
  final String url;
  final String titles;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  String url = "";
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webView;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: scaffoldKey,
        appBar: appBar(text: widget.titles, context: context),
        body: InAppWebView(
          key: webViewKey,
          onWebViewCreated: (controller) {
            webView = controller;
            setState(() {
              isLoading = false;
            });
          },
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions()),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
        ),
      ),
    );
  }
}
