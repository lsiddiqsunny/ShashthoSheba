import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class OngoingCall extends StatefulWidget {
  static final routeName = '/ongoingCall';
  @override
  _OngoingCallState createState() => _OngoingCallState();
}

class _OngoingCallState extends State<OngoingCall> {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    final path = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("ShasthoSheba"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
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
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
