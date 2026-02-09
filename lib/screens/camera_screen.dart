import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../main.dart'; // 전역 변수 cameras를 쓰기 위해 필요

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          _buildCameraOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraOverlay() {
    return Column(
      children: [
        Container(
          height: 120, width: double.infinity, color: Colors.black45,
          alignment: Alignment.bottomCenter, padding: const EdgeInsets.only(bottom: 20),
          child: const Text("카메라에 얼굴을 인식해주세요", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        const Spacer(),
        _captureButton(),
      ],
    );
  }

  Widget _captureButton() {
    return Container(
      height: 180, width: double.infinity, color: Colors.black45,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            await controller!.takePicture();
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("촬영 완료!")));
          },
          child: Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(child: Container(width: 70, height: 70, decoration: const BoxDecoration(color: Color(0xFFFF9F80), shape: BoxShape.circle))),
          ),
        ),
      ),
    );
  }
}