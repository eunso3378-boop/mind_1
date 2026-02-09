import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'gallery_screen.dart';

class MaumBomHome extends StatelessWidget {
  const MaumBomHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Stack(
        children: [
          ListView(
            children: [
              _buildHeader(), // 상단 타이틀
              const SizedBox(height: 30),
              _buildStatusButtons(), // 주간/야간 버튼
              const SizedBox(height: 30),
              _buildElderlyList(context), // 어르신 카드들
            ],
          ),
          _buildBottomBar(context), // 하단 네비게이션
        ],
      ),
    );
  }

  // --- 위젯 조각들 (메모리 관리 및 가독성을 위해 나눔) ---
  Widget _buildHeader() {
    return Container(
      height: 172,
      decoration: const BoxDecoration(
        color: Color(0xFFFF9F80),
        boxShadow: [BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: const Center(child: Text('마음봄', style: TextStyle(color: Colors.white, fontSize: 36))),
    );
  }

  Widget _buildStatusButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['주간', '야간'].map((text) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 100, height: 50,
        decoration: BoxDecoration(color: const Color(0xFFFF9F80), borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 16))),
      )).toList(),
    );
  }

  Widget _buildElderlyList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _elderlyCard(context, '김ㅇㅇ 어르신', 'assets/kim.jpg'),
          _elderlyCard(context, '이ㅇㅇ 어르신', 'assets/lee.jpg'),
        ],
      ),
    );
  }

  Widget _elderlyCard(BuildContext context, String name, String imagePath) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryScreen(userName: name))),
      child: Container(
        width: 170, height: 250,
        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80)))),
            Padding(padding: const EdgeInsets.all(10), child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      left: 0, bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width, height: 70,
        color: const Color(0xFFFF9F80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScreen()))),
            const Icon(Icons.home, color: Colors.white, size: 30),
            const Icon(Icons.share, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}