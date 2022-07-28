import 'dart:async';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class RotationPage extends StatefulWidget {
  @override
  _RotationPageState createState() => _RotationPageState();
}

class _RotationPageState extends State<RotationPage> {
  ArCoreController? arkitController;

  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    arkitController?.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Wimtorq Sample AR'),
          backgroundColor: Color.fromRGBO(119, 181, 54, 1),
        ),
        body: ArCoreView(
          onArCoreViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ArCoreController controller) {
    arkitController = controller;
    _addSphere();
  }

  Future _addSphere() async {
    final ByteData textureBytes = await rootBundle.load('assets/logoW.png');

    final material = ArCoreMaterial(
      color: Color.fromRGBO(119, 181, 54, 1),
      textureBytes: textureBytes.buffer.asUint8List(),
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ArCoreRotatingNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -0.5),
      rotation: vector.Vector4(0, 0, 0, 0),
    );
    arkitController?.addArCoreNode(node);

    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      node.degreesPerSecond.value += 0.01;
    });
  }
}
