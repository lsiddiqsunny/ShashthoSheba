import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import './mainPage.dart';

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
    // final path = '371052594';
    return Scaffold(
      appBar: AppBar(
        title: Text("ShasthoSheba"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName(MainPage.routeName));
            },
            icon: Icon(Icons.cancel),
          ),
        ],
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
