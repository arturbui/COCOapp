import 'package:flutter/material.dart';
import '../backend_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BackendService _backendService = BackendService();
  
  String username = 'James';
  bool _isLoading = true;
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _adPerformance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  final isAuth = await _backendService.isAuthenticated();
  
  if (!isAuth) {
    // Instead of redirecting, show default data
    if (mounted) {
      setState(() {
        username = 'Guest';
        _isLoading = false;
      });
    }
    return;
  }

  // Load data as before...
  final results = await Future.wait([
    _backendService.getUserProfile(),
    _backendService.getUserStats(),
    _backendService.getLatestAdPerformance(),
  ]);
  
  if (mounted) {
    setState(() {
      if (results[0] != null) {
        username = results[0]!['username'] ?? 'James';
      }
      _stats = results[1];
      _adPerformance = results[2];
      _isLoading = false;
    });
  }
}

  Future<void> _refreshData() async {
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF94FFA6),
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                color: const Color(0xFF94FFA6),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back $username',
                          style: const TextStyle(
                            color: Color(0xFF94FFA6),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _adPerformance != null
                              ? 'while you were away\nyour latest ad got ${_adPerformance!['views'] ?? '0'} views...'
                              : 'while you were away\nyour latest ad...',
                          style: const TextStyle(
                            color: Color(0xFFC3ECCA),
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildAdPerformanceCard(),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 140,
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: _buildNewIdeasCard()),
                              const SizedBox(width: 12),
                              Expanded(flex: 2, child: _buildTutorialsCard()),
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
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildAdPerformanceCard() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D2818), Color(0xFF061705)],
          stops: [0.2, 0.35],
        ),
      ),
      child: _adPerformance != null
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Latest Ad Performance',
                    style: TextStyle(
                      color: Color(0xFF94FFA6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Views',
                        _adPerformance!['views']?.toString() ?? '0',
                      ),
                      _buildStatItem(
                        'Clicks',
                        _adPerformance!['clicks']?.toString() ?? '0',
                      ),
                      _buildStatItem(
                        'CTR',
                        '${_adPerformance!['ctr']?.toString() ?? '0'}%',
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
                'No ad data available',
                style: TextStyle(
                  color: Color(0xFF94FFA6),
                  fontSize: 14,
                ),
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC3ECCA),
            fontSize: 12,
          ),
        ),
      ],
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
        border: Border.all(color: const Color(0xFF5EFF79), width: 5),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=400',
          ),
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
    final totalViews = _stats?['total_views']?.toString() ?? '1.2k';
    final newFollowers = _stats?['new_followers']?.toString() ?? '300';
    
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
                'Over the last month you\'ve gained a total of $totalViews views across all your social media platforms, $newFollowers of which net you new followers...',
                style: const TextStyle(
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
                'Over the last month you\'ve gained a total of $totalViews views across all your social media platforms, $newFollowers of which net you new followers...',
                style: const TextStyle(
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
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, true, () {}),
          _buildNavItem(Icons.smart_display_outlined, false, () {
            Navigator.pushNamed(context, '/chat');
          }),
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
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}