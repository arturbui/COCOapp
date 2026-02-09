import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'video_editor_screen.dart';

class CreateScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Project',
                style: TextStyle(
                  color: Color(0xFF94FFA6),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Record a video or import existing media',
                style: TextStyle(
                  color: Color(0xFFC3ECCA),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Create',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildActionButton(
                          context,
                          icon: Icons.camera_alt,
                          title: 'Take Photo or Video',
                          onTap: () {
                            _navigateToEditor(
                              context,
                              'dummy_video_path',
                              true,
                            );
                          },
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.photo_library,
                          title: 'Select from Gallery',
                          onTap: () {
                            _navigateToEditor(
                              context,
                              'dummy_gallery_path',
                              true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, false, () {
            Navigator.pushNamed(context, '/home');
          }),
          _buildNavItem(Icons.chat_bubble_outline, false, () {
            Navigator.pushNamed(context, '/chat');
          }),
          _buildNavItem(Icons.add_box_outlined, true, () {}),
          _buildNavItem(Icons.bar_chart_rounded, false, () {
            Navigator.pushNamed(context, '/dashboard');
          }),
          _buildNavItem(Icons.person_outline, false, () {
            Navigator.pushNamed(context, '/profile');
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFFC3ECCA), size: 22),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFC3ECCA),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditor(BuildContext context, String filePath, bool isVideo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoEditorScreen(filePath: filePath, isVideo: isVideo),
      ),
    );
  }
}