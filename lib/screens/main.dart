import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_screen.dart'; // 홈 화면 불러오기

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    print("카메라 오류: $e");
  }
  runApp(const MaumBomApp());
}

class MaumBomApp extends StatelessWidget {
  const MaumBomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마음봄',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jua', // 피그마에서 쓰던 폰트
        useMaterial3: true,
      ),
      home: const MaumBomHome(),
    );
  }
}