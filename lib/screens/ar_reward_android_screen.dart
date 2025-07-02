import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';

class ARRewardAndroidScreen extends StatefulWidget {
  const ARRewardAndroidScreen({super.key});

  @override
  State<ARRewardAndroidScreen> createState() => _ARRewardAndroidScreenState();
}

class _ARRewardAndroidScreenState extends State<ARRewardAndroidScreen> {
  ArCoreController? arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ваш мамонт (Android)')),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    final node = ArCoreReferenceNode(
      name: 'Mammoth',
      object3DFileName: 'mammoth.glb',
      position: Vector3(0, 0, -1),
      scale: Vector3(0.5, 0.5, 0.5),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
} 