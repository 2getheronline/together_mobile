// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:together_online/models/mission.dart';
// import 'package:together_online/providers/localstorage.dart';
//
// class MyInAppBrowser extends InAppBrowser {
//
//   dynamic mission = {
//     'target': {
//       'name': 'google'
//     }
//   };
//
//     loadScript() async {
//       String script = await LocalStorageProvider.getScript(this.mission.target.name);
//       if (script != null) {
//         this.webViewController.evaluateJavascript(source: script);
//         print('Evaluated script');
//         return;
//       }
//
//     switch (this.mission.target.name) {
//       case 'google':
//         await this.webViewController.injectJavascriptFileFromAsset(
//             assetFilePath: 'assets/scripts/google.js');
//         break;
//       case 'facebook':
//         await this.webViewController.injectJavascriptFileFromAsset(
//             assetFilePath: 'assets/scripts/facebook.js');
//         break;
//       case 'twitter':
//         await this.webViewController.injectJavascriptFileFromAsset(
//             assetFilePath: 'assets/scripts/twitter.js');
//         break;
//       case 'instagram':
//         await this.webViewController.injectJavascriptFileFromAsset(
//             assetFilePath: 'assets/scripts/instagram.js');
//         break;
//     }
//         print('Loaded script file');
//   }
//
//   void setMission(Mission mission) {
//     this.mission = mission;
//   }
//
//   @override
//   Future onBrowserCreated() async {
//     print("\n\nBrowser Created!\n\n");
//   }
//
//   @override
//   Future onLoadStart(String url) async {
//     print("$mission\n\nStarted $url\n\n");
//   }
//
//   @override
//   Future onLoadStop(String url) async {
//     print("\n\nStopped $url\n\n");
//     //await loadScript();
//   }
//
//   @override
//   void onLoadError(String url, int code, String message) {
//     print("Can't load $url.. Error: $message");
//   }
//
//   @override
//   void onProgressChanged(int progress) {
//     print("Progress: $progress");
//   }
//
//   @override
//   void onExit() {
//     print("\n\nBrowser closed!\n\n");
//   }
//
//   @override
//   Future<ShouldOverrideUrlLoadingAction> shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest shouldOverrideUrlLoadingRequest) async {
//     print("\n\n override ${shouldOverrideUrlLoadingRequest.url}\n\n");
//     this.webViewController.loadUrl(url: shouldOverrideUrlLoadingRequest.url);
//     return ShouldOverrideUrlLoadingAction.CANCEL;
//   }
//
//   @override
//   void onLoadResource(LoadedResource response) {
//     print("Started at: " +
//         response.startTime.toString() +
//         "ms ---> duration: " +
//         response.duration.toString() +
//         "ms " +
//         response.url.toString());
//   }
//
//   @override
//   void onConsoleMessage(ConsoleMessage consoleMessage) {
//     print("""
//     console output:
//       message: ${consoleMessage.message}
//       messageLevel: ${consoleMessage.messageLevel.toValue()}
//    """);
//   }
//
//   MyInAppBrowser();
// }
