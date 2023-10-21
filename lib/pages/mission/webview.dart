import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/models/action.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/providers/localstorage.dart';
import 'package:together_online/providers/missions_provider.dart' as Provider;
import 'package:together_online/widgets/myRaisedButton.dart';

import '../../app_localizations.dart';

class Webview extends StatefulWidget {
  final Mission? mission;
  final bool? createYoutubeChannel;
  final dynamic args;

  Webview({this.mission, this.createYoutubeChannel, this.args});

  @override
  _WebviewState createState() => new _WebviewState();
}

class _WebviewState extends State<Webview> {
  late InAppWebViewController webView;
  Mission? mission;
  double progress = 0;
  bool? canEndMission = false;
  String? currentUrl;

  Map<String, dynamic> performedActions = {
    'like': {
      'status': false,
    },
    'dislike': {
      'status': false,
    },
    'rate': {'status': false, 'value': -1},
    'comment': {'status': false, 'value': ''},
    'report': {
      'status': false,
    },
    'retweet': {'status': false},
    'post': {'status': false}
  };

  List<dynamic>? subs;

  @override
  void initState() {
    super.initState();
    if (widget.mission != null) {
      print(widget.mission!.target!.name);
      this.mission = widget.mission;
    }

    /*Future.delayed(Duration(seconds: 5))
        .then((value) => setState(() => canEndMission = true));*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  missionCompleted() async {
    Map<String, bool> actions = {};
    performedActions.forEach((key, val) {
      actions[key] = (val['status'] == "true" || val['status'] == true);
    });
    Navigator.of(context).pop(actions);
  }

  handler(List<dynamic> args) {
    print(args[0] + ' ' + args[1]);
    final String? action = args[0];
    final String actionName = args[1].toString().split(".")[0];
    bool tmpCanEndMission = true;
//    final String value = args[1].toString().split(".")[1];

    setState(() {
      mission!.actions!.forEach((action) {
        if (action!.name == actionName) {
          action.done = true; //value.trim() != '' && value != 'false';
        }

        if(action.done == false)
          tmpCanEndMission = false;
      });

      canEndMission = tmpCanEndMission;

      // canEndMission = mission!.actions!
      //     .reduce((value, element) => value!..done &= element!.done)!
      //     .done;
    });

//    if (this.mission.getMissionTarget().id == 2) {
//      if (action == 'click') {
//        if (value == 'post') {
//          performedActions['post'] = {
//            'status': true,
//          };
//        } else {
//          final star = int.parse(value.replaceAll('star.', ''));
//          if (performedActions['rate']['value'] == star) {
//            performedActions['rate'] = {
//              'status': false,
//              'value': performedActions['rate']['value'] - 1
//            };
//          } else {
//            performedActions['rate'] = {'status': true, 'value': star};
//          }
//        }
//      } else if (action == 'text') {
//        if (value != null && value.trim() != '') {
//          performedActions['comment'] = {'status': true, 'value': value};
//        } else {
//          performedActions['comment'] = {'status': false, 'value': ''};
//        }
//      }
//
//      bool completed = true;
//
//      if (widget.args['hasComment'] &&
//          performedActions['comment']['status'] == false) {
//        completed = false;
//      }
//      if ((widget.args['hasRate'] &&
//              performedActions['rate']['status'] == false) ||
//          performedActions['post']['status'] == false) {
//        completed = false;
//      }
//
//      ;
//    } else if (this.mission.getMissionTarget().id == 1) {
//      if (action == 'click') {
//        if (value == 'report') {
//          performedActions['report'] = {
//            'status': true,
//          };
//        } else if (value == 'like.true') {
//          performedActions['like']['status'] = true;
//        } else if (value == 'like.false') {
//          performedActions['like']['status'] = false;
//        } else if (value == 'like_page') {
//          performedActions['like']['status'] =
//              !performedActions['like']['status'];
//        } else if (value == 'terrorism' ||
//            value == 'hate' ||
//            value == 'inappropriate') {
//          //TODO: Check pressed report option
//        } else if (value == 'post') {
//          performedActions['post'] = {'status': true};
//        }
//      } else if (action == 'text') {
//        if (value != null && value.trim() != '') {
//          performedActions['comment'] = {'status': true, 'value': value};
//        } else {
//          performedActions['comment'] = {'status': false, 'value': ''};
//        }
//      }
//
//      bool completed = true;
//
//      if (widget.args['hasLike'] &&
//          performedActions['like']['status'] == false) {
//        completed = false;
//      }
//      if (widget.args['hasComment'] &&
//              (performedActions['comment']['status'] == false) ||
//          performedActions['post']['status'] == false) {
//        completed = false;
//      }
//      if (widget.args['hasReport'] &&
//          performedActions['report']['status'] == false) {
//        completed = false;
//      }
//
//      setState(() {
//        canEndMission = completed;
//      });
//    } else if (this.mission.getMissionTarget().id == 5) {
//      if (action == 'click') {
//        if (value == 'report') {
//          performedActions['report'] = {
//            'status': true,
//          };
//        } else if (value == 'like') {
//          performedActions['like']['status'] =
//              !performedActions['like']['status'];
//        } else if (value == 'retweet') {
//          performedActions['retweet']['status'] = true;
//        } else if (value == 'unretweet') {
//          performedActions['retweet']['status'] = false;
//        } else if (value == 'post') {
//          performedActions['post'] = {'status': true};
//        }
//      } else if (action == 'text') {
//        if (value != null && value.trim() != '') {
//          performedActions['comment'] = {'status': true, 'value': value};
//        } else {
//          performedActions['comment'] = {'status': false, 'value': ''};
//        }
//      }
//
//      bool completed = true;
//
//      if (widget.args['hasLike'] &&
//          performedActions['like']['status'] == false) {
//        completed = false;
//      }
//      if ((widget.args['hasComment'] &&
//              performedActions['comment']['status'] == false) &&
//          performedActions['post']['status'] == false) {
//        completed = false;
//      }
//      if (widget.args['hasReport'] &&
//          performedActions['report']['status'] == false) {
//        completed = false;
//      }
//      if (widget.args['hasRetweet'] &&
//          performedActions['retweet']['status'] == false) {
//        completed = false;
//      }
//
//      setState(() {
//        canEndMission = completed;
//      });
//    } else if (this.mission.getMissionTarget().id == 4) {
//      if (currentUrl.indexOf('https://www.instagram.com/accounts/') != -1)
//        return;
//
//      if (action == 'click') {
//        if (value == 'report') {
//          performedActions['report'] = {
//            'status': true,
//          };
//        } else if (value == 'like') {
//          performedActions['like']['status'] =
//              !performedActions['like']['status'];
//        } else if (value == 'post') {
//          performedActions['post'] = {'status': true};
//        }
//      } else if (action == 'text') {
//        if (value != null && value.trim() != '') {
//          performedActions['comment'] = {'status': true, 'value': value};
//        } else {
//          performedActions['comment'] = {'status': false, 'value': ''};
//        }
//      }
//
//      bool completed = true;
//
//      if (widget.args['hasLike'] &&
//          performedActions['like']['status'] == false) {
//        completed = false;
//      }
//      if ((widget.args['hasComment'] &&
//              performedActions['comment']['status'] == false) &&
//          performedActions['post']['status'] == false) {
//        completed = false;
//      }
//      if (widget.args['hasReport'] &&
//          performedActions['report']['status'] == false) {
//        completed = false;
//      }
//
//      setState(() {
//        canEndMission = completed;
//      });
//    }
  }

  loadScript() async {
    String? script =
        await LocalStorageProvider.getScript(this.mission!.target!.name!);
    if (script != null) {
      webView.evaluateJavascript(source: script);
      print('Evaluated script');
      return;
    }

    switch (this.mission!.target!.id) {
      case 1:
        await webView.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/scripts/facebook.js');
        break;
      case 2:
        await webView.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/scripts/google.js');
        break;
      case 3:
        await webView.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/scripts/youtube.js');
        break;
      case 4:
        await webView.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/scripts/instagram.js');
        break;
      case 5:
        await webView.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/scripts/twitter.js');
        break;
    }
    print('Loaded script file');
  }

  reload() {
    this
        .webView
        .loadUrl(urlRequest: URLRequest(url: Uri.parse(this.mission!.url!)));
  }

  @override
  Widget build(BuildContext context) {
    /*
    if (Platform.isIOS) {
      final MyInAppBrowser browser = MyInAppBrowser();
      browser.setMission(mission);
      browser.openUrl(
        url: this.mission.url,
        options: InAppBrowserClassOptions(
          ios: IOSInAppBrowserOptions(),
          inAppWebViewWidgetOptions: InAppWebViewWidgetOptions(
            crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true, useOnLoadResource: true),
          ),
          crossPlatform: InAppBrowserOptions(toolbarTop: true),
        ),
      );
      webView = browser.webViewController;
      webView.addJavaScriptHandler(handlerName: 'handler', callback: handler);

      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back'),
            )
          ],
          title: Text('iOS WebView'),
        ),
        body: Center(
          child: Text('WebView'),
        ),
      );
    }*/
    int counter = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.mission!.url ?? '',
          style: TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: reload,
            child: Icon(
              Icons.refresh,
            ),
          ),
          Container(
            width: 5,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 15,
              child: Container(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse('about:blank')),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        userAgent: Platform.isAndroid ?
                        "Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36":
                        "Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Mobile/15E148 Safari/604.1"
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                    if (widget.createYoutubeChannel == true) {
                      webView.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(Provider
                                  .endpoints['youtube']!['createChannel']!)));
                    } else {
                      webView.loadUrl(
                          urlRequest:
                              URLRequest(url: Uri.parse(mission!.url!)));
                    }
                  },
                  onLoadStop:
                      (InAppWebViewController controller, Uri? url) async {
                    print('stopped ' + url.toString());
                    currentUrl = url.toString();
                    if (widget.createYoutubeChannel != null &&
                        widget.createYoutubeChannel!) {
                      if (url.toString().indexOf(Provider
                              .endpoints['youtube']!['createChannelDone']!) !=
                          -1) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      if (url == 'https://www.instagram.com/') {
                        controller.loadUrl(
                            urlRequest:
                                URLRequest(url: Uri.parse(mission!.url!)));
                        return;
                      }

                      webView.addJavaScriptHandler(
                          handlerName: 'handler', callback: handler);

                      await loadScript();

                      print('Loaded');
                    }
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {},
                ),
              ),
            ),
            mission != null
                ? Flexible(
                    flex: 5,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: globalHeight * .012),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ...mission!.actions!.map((a) {
                                counter++;
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      //horizontal: globalWidth * .05,
                                      vertical: globalHeight * .01),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            child: a!.done
                                                ? SvgPicture.asset(
                                                    'assets/icons/actions/web_view/green_check.svg')
                                                : SvgPicture.asset(
                                                    'assets/icons/actions/web_view/outlined_check.svg'),
                                          ),
                                          counter ==
                                                  mission!.actions!
                                                      .length //Para nao imprimir uma linha apos o ultimo
                                              ? SizedBox()
                                              : mission!.actions!.length >
                                                      1 //Se so tiver uma action nao imprime numcaF
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          top: 9),
                                                      color: Color.fromRGBO(
                                                          0, 239, 141, 1),
                                                      height: 1,
                                                      width: globalWidth /
                                                              mission!.actions!
                                                                  .length -
                                                          ((globalWidth * .05)),
                                                    )
                                                  : SizedBox(),
                                        ],
                                      ),
                                      Text(AppLocalizations.of(context)!
                                          .translate(a.name)!),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        MyRaisedButton(
                          isEnabled: canEndMission,
                          margin: globalWidth * .2,
                          title: AppLocalizations.of(context)!
                              .translate('MISSION COMPLETED'),
                          noContextCallback:
                              canEndMission! ? missionCompleted : null,
                        )
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
