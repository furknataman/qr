// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/global_veriable/events_info.dart';
import 'package:qr/global/globalveriable.dart';
import 'package:qr/main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../global/global_veriable/user_info.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch<UserInfo>(userInfoConfig);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _buildQrView(context)),
          Positioned(
              child: Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0),
              ],
            )),
          )),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(left: 80, right: 59, top: 80, bottom: 40),
              child: Text(
                textAlign: TextAlign.center,
                "Scan the QR code of \nyour event.",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            child: Padding(
              padding: const EdgeInsets.only(left: 80, right: 59),
              child: result != null
                  ? Text(
                      '  Data: ${result!.code}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )
                  : const Text('Scan a code'),
            ),
          ),

          /* Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color(0xff485FFF),
          borderRadius: 30,
          borderLength: 30,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      controller.pauseCamera();
      dialogAlert();
    });
  }

  Future<dynamic> dialogAlert() {
    final userInfo = ref.watch<UserInfo>(userInfoConfig);
    String? title;
    String? body;
    bool register = false;
    for (int i = 0; i < eventss.length; i++) {
      if (events[i].key!.contains(result!.code.toString()) == true) {
        int id = events[i].id!;

        if (userInfo.user!.registeredEvents!.contains(id)) {
          register = true;
          title = "Atending to ${events[i].name} ";
          body = "You are about to attend to${events[i].name}, are you sure?";
          break;
        } else {
          title = "Non-registered";
          body =
              "You are not registered the event that you have scanned. Please try one of that you are. You can see them on your home page. ";
          break;
        }
      } else {
        title = "Unrecognized Code";
        body =
            "The code you have scanned cannot be recognized by our system. Please scan only the codes printed on doors.";
        break;
      }
    }

    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: 277,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.25,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Container(
                        height: 5.0,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2.5)),
                            color: Color(0xff828282)),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(title!, style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(body!, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (register == true)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.disable,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            controller!.resumeCamera();
                          },
                          child: Text("Cancel ",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).floatingActionButtonTheme.backgroundColor,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                        onPressed: () {
                          if (register == false) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Okay",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
