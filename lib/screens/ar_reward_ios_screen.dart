import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

class ARRewardIosScreen extends StatefulWidget {
  const ARRewardIosScreen({super.key});

  @override
  State<ARRewardIosScreen> createState() => _ARRewardIosScreenState();
}

class _ARRewardIosScreenState extends State<ARRewardIosScreen> {
  ARKitController? arkitController;
  String? nodeName;
  bool mammothAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ваш мамонт (iOS)')),
      body: Stack(
        children: [
          ARKitSceneView(
            onARKitViewCreated: _onARKitViewCreated,
            enableTapRecognizer: true,
          ),
          if (!mammothAdded)
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Тапните по экрану, чтобы добавить мамонта!')),
                  );
                },
                child: const Text('Добавить мамонта'),
              ),
            ),
          if (mammothAdded)
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: ElevatedButton(
                onPressed: _removeMammoth,
                child: const Text('Удалить мамонта'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  void _onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController?.onARTap = (List<ARKitTestResult> hits) {
      if (!mammothAdded && hits.isNotEmpty) {
        final hit = hits.first;
        final position = hit.worldTransform.getTranslation();
        _addMammothAt(position);
      }
    };
  }

  void _addMammothAt(vmath.Vector3 position) {
    if (arkitController == null || mammothAdded) return;
    try {
      final node = ARKitReferenceNode(
        name: 'mammoth',
        url: 'mammoth.usdz',
        position: position,
        scale: vmath.Vector3(0.08, 0.08, 0.08),
        eulerAngles: vmath.Vector3(0, -1.5708, -1.5708),
      );
      arkitController!.add(node);
      setState(() {
        nodeName = node.name;
        mammothAdded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Модель мамонта добавлена!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении модели: $e')),
      );
    }
  }

  void _removeMammoth() {
    if (arkitController != null && nodeName != null) {
      arkitController!.remove(nodeName!);
    }
    setState(() {
      mammothAdded = false;
      nodeName = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Мамонт удалён!')),
    );
  }

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }
} 