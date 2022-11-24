import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {


  late WebViewController controllerGlobal;

  String _webSiteTitle='Health Active';
  String _webSiteUrl="https://ha-leipzig.de/";
  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  Future<bool> browserBack(BuildContext context) async{
    print('activated');
    if (await controllerGlobal.canGoBack()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Loading....")),
      );
      print("onwill goback");
      controllerGlobal.goBack();
    }
    else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(false);
     }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => browserBack(context),
      child: SafeArea(
        child: new Scaffold(
            body: IndexedStack(
              index: _stackToView,
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                        child: WebView(
                          initialUrl: _webSiteUrl,
                          javascriptMode: JavascriptMode.unrestricted,
                          onPageFinished: _handleLoad,
                          onWebViewCreated: (WebViewController webViewController) {
                            controllerGlobal = webViewController;
                          },
                        )),
                  ],
                ),
                Container(
                    child: Center(child: CircularProgressIndicator(),)
                ),
              ],
            )),
      ),
    );
  }
}