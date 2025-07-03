import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARRewardAndroidScreen extends StatelessWidget {
  const ARRewardAndroidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ваш мамонт (Android, AR)')),
      body: Center(
        child: ModelViewer(
          src: 'assets/models/mammoth.glb',
          alt: '3D модель мамонта',
          ar: true,
          autoRotate: true,
          cameraControls: true,
          disableZoom: false,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
} 