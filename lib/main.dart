import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_data.dart';           // 같은 lib 폴더에 있는 파일을 불러옵니다.
import 'screens/home_screen.dart';   // screens 폴더 안의 홈 화면을 불러옵니다.

Future<void> main() async {
  // 앱 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 카메라 목록 가져오기
    cameras = await availableCameras();
  } catch (e) {
    // 에러 발생 시 로그 출력 (print 대신 debugPrint 권장)
    debugPrint("카메라 초기화 에러: $e");
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
        fontFamily: 'Jua', 
        useMaterial3: true,
      ),
      // 이제 home_screen.dart를 정상적으로 불러올 수 있습니다.
      home: const MaumBomHome(), 
    );
  }
}