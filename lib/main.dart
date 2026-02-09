import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// 전역 변수로 카메라 리스트 저장
List<CameraDescription> cameras = [];

Future<void> main() async {
  // 앱 시작 전 카메라 및 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    print("카메라를 찾을 수 없습니다: $e");
  }
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마음봄',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jua', // 폰트 설정 (없으면 기본 폰트 적용)
        useMaterial3: true,
      ),
      home: const MaumBomHome(),
    );
  }
}

// --- [1] 메인 홈 화면 ---
class MaumBomHome extends StatelessWidget {
  const MaumBomHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Stack(
        children: [
          // 스크롤 가능한 콘텐츠
          ListView(
            children: [
              // 상단 타이틀 (피그마 디자인)
              Container(
                width: double.infinity,
                height: 172,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9F80),
                  boxShadow: [BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4))],
                ),
                child: const Center(
                  child: Text('마음봄', style: TextStyle(color: Colors.white, fontSize: 36)),
                ),
              ),
              const SizedBox(height: 30),
              // 버튼 영역 (주간/야간)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statusButton('주간'),
                  const SizedBox(width: 20),
                  _statusButton('야간'),
                ],
              ),
              const SizedBox(height: 30),
              // 어르신 리스트 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _elderlyCard(context, '김ㅇㅇ 어르신', 'assets/kim.jpg'),
                    _elderlyCard(context, '이ㅇㅇ 어르신', 'assets/lee.jpg'),
                  ],
                ),
              ),
            ],
          ),
          // 하단 네비게이션 바 (피그마 디자인)
          Positioned(
            left: 0,
            bottom: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _statusButton(String text) {
    return Container(
      width: 100, height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFF9F80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 16))),
    );
  }

  Widget _elderlyCard(BuildContext context, String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryScreen(userName: name)),
        );
      },
      child: Container(
        width: 170, height: 250,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(imagePath, fit: BoxFit.cover, 
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 80)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: const BoxDecoration(color: Color(0xFFFF9F80)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen())),
          ),
          const Icon(Icons.home, color: Colors.white, size: 30),
          const Icon(Icons.share, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}

// --- [2] 카메라 화면 (실제 기능 연동) ---
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
          // 피그마 가이드 레이어
          _buildCameraOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraOverlay() {
    return Column(
      children: [
        Container(
          height: 120, width: double.infinity,
          color: Colors.black45,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 20),
          child: const Text("카메라에 얼굴을 인식해주세요", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        const Spacer(),
        // 촬영 버튼 영역
        Container(
          height: 180, width: double.infinity,
          color: Colors.black45,
          child: Center(
            child: GestureDetector(
              onTap: () async {
                final image = await controller!.takePicture();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("사진 촬영 완료!")));
              },
              child: Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(child: Container(width: 70, height: 70, decoration: const BoxDecoration(color: Color(0xFFFF9F80), shape: BoxShape.circle))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- [3] 갤러리 화면 (실제 기능 연동) ---
class GalleryScreen extends StatefulWidget {
  final String userName;
  const GalleryScreen({super.key, required this.userName});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final List<XFile> selected = await _picker.pickMultiImage();
    if (selected.isNotEmpty) {
      setState(() => _images.addAll(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        title: Text('${widget.userName} 갤러리'),
        backgroundColor: const Color(0xFFFF9F80),
        actions: [IconButton(onPressed: _pickImage, icon: const Icon(Icons.add_a_photo))],
      ),
      body: _images.isEmpty
          ? const Center(child: Text("기록된 사진이 없습니다."))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: _images.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(_images[index].path), fit: BoxFit.cover),
              ),
            ),
    );
  }
}