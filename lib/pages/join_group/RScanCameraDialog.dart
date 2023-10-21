import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'scanImageView.dart';

class RScanCameraDialog extends StatefulWidget {
  @override
  _RScanCameraDialogState createState() => _RScanCameraDialogState();
}

class _RScanCameraDialogState extends State<RScanCameraDialog> {
  Barcode? result;
  QRViewController? _controller;
  bool isFirst = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flash = false;

  void initCamera() async {
    // if (rScanCameras == null || rScanCameras!.length == 0) {
    //   var status = await Permission.camera.status;
    //   if (status.isPermanentlyDenied) openAppSettings();
    //
    //   if ( !status.isGranted) {
    //     status = await Permission.camera.request();
    //   }
    //   if (status.isGranted) {
    //     rScanCameras = [];
    //     rScanCameras!.addAll(await availableRScanCameras());
    //   }
    // }
    // if (rScanCameras != null && rScanCameras!.length > 0) {
    //   _controller = RScanCameraController(
    //       rScanCameras![0], RScanCameraResolutionPreset.high)
    //     ..addListener(() {
    //       final result = _controller!.result;
    //       if (result != null) {
    //         if (isFirst) {
    //           Navigator.of(context).pop(result);
    //           isFirst = false;
    //         }
    //       }
    //     })
    //     ..initialize().then((_) {
    //       if (!mounted) {
    //         return;
    //       }
    //       setState(() {});
    //     });
    // }
  }
  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    // if (rScanCameras == null || rScanCameras!.length == 0) {
    //   return Scaffold(
    //     body: Container(
    //       alignment: Alignment.center,
    //       child: Text('not have available camera'),
    //     ),
    //   );
    // }
    // if (!_controller.s.isInitialized!) {
    //   return Container();
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: (c) => _controller = c
              ..scannedDataStream.listen((scanData) {
                setState(() {
                  if (result == null) {
                    result = scanData;

                    Navigator.of(context).pop(result?.code);
                  }
                });
              }),
            overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300),
            // onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFlashBtn(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildFlashBtn() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: 24 + MediaQuery.of(context).padding.bottom),
      child: IconButton(
          icon: Icon(flash ? Icons.flash_on : Icons.flash_off),
          color: Colors.white,
          iconSize: 46,
          onPressed: () {
            _controller!.toggleFlash();
            setState(() {
              this.flash = !this.flash;
            });
          }),
    );
  }
}
