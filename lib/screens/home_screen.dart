import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back James',
                  style: TextStyle(
                    color: Color(0xFF94FFA6),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'while you were away\nyour latest ad...',
                  style: TextStyle(
                    color: Color(0xFFC3ECCA),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0D2818),
                      Color(0xFF061705),
                    ],
                    stops: [0.2, 0.35],
                  ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                SizedBox(
                  height: 140,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildNewIdeasCard(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _buildTutorialsCard(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(true),
                    _buildDot(false),
                    _buildDot(false),
                    _buildDot(false),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                _buildNewsSection(),
                
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildNewIdeasCard() {
  return Align(
    alignment: Alignment.topLeft, 
    child: Container(
      width: 190,
      height: 136,
      decoration: BoxDecoration(
        color: const Color(0xFFC3ECCA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Boil up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'New Ideas',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildTutorialsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF5EFF79),
          width: 5,
        ),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=400'),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tutorials',
              style: TextStyle(
                color: Color(0xFFC3ECCA),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[700],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNewsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'News',
                style: TextStyle(
                  color: Color(0xFFC5E8B7),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Over the last month you\'ve gained a total of 1.2k views across all your social media platforms, 300 of which net you new followers...',
                style: TextStyle(
                  color: Color(0xFFC5E8B7),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'News',
                style: TextStyle(
                  color: Color(0xFF5C6E5F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Over the last month you\'ve gained a total of 1.2k in across all your social media platforms, 300 of which net you new followers...',
                style: TextStyle(
                  color: Color(0xFF5C6E5F),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, true, () {}),
          _buildNavItem(Icons.smart_display_outlined, false, () {}),
          _buildNavItem(Icons.add_box_outlined, false, () {
            Navigator.pushNamed(context, '/create');
          }),
          _buildNavItem(Icons.notifications_outlined, false, () {}),
          _buildNavItem(Icons.person_outline, false, () {}),
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
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}