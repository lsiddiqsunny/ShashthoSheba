import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoChat extends StatefulWidget {
  final path;
  VideoChat({this.path});
  @override
  _VideoChatState createState() => _VideoChatState(path: path);
}

class _VideoChatState extends State<VideoChat> {
  final path;
  _VideoChatState({this.path});
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InAppWebViewPage(path: path));
  }
}

class InAppWebViewPage extends StatefulWidget {
  final path;
  InAppWebViewPage({this.path});
  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState(path: path);
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController webView;
  final path;
  _InAppWebViewPageState({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Chat room")),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              child: InAppWebView(
                  initialUrl: "https://appr.tc/r/" + path,
                  initialHeaders: {},
                  initialOptions: InAppWebViewWidgetOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: false,
                      debuggingEnabled: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart:
                      (InAppWebViewController controller, String url) {},
                  onLoadStop:
                      (InAppWebViewController controller, String url) {},
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
                    print(origin);
                    print(resources);
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  }),
            ),
          ),
        ])));
  }
}
