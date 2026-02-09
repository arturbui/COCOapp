import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedPlatform = 'Instagram';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Color(0xFF5EFF79),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _buildPlatformChip('Instagram'),
                  const SizedBox(width: 12),
                  _buildPlatformChip('Facebook'),
                  const SizedBox(width: 12),
                  _buildPlatformChip('TikTok'),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                'Key metrics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

IntrinsicHeight(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch, 
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildMetricCard('1.2K', 'Total Views'),
      _buildMetricCard('2.3%', 'Engagement Rate'),
      _buildMetricCard('+67', 'Followers'),
    ],
  ),
),
              const SizedBox(height: 20),

              Row(
  mainAxisAlignment: MainAxisAlignment.center, 
  children: [
    _buildTimePeriod('1W'),
    const SizedBox(width: 8),
    _buildTimePeriod('3M'),
    const SizedBox(width: 8),
    _buildTimePeriod('6M'),
    const SizedBox(width: 8),
    _buildTimePeriod('1Y'),
  ],
),
              const SizedBox(height: 30),

              Expanded(
                child: _buildChart(),
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
          _buildNavItem(Icons.add_box_outlined, false, () {
            Navigator.pushNamed(context, '/create');
          }),
          _buildNavItem(Icons.bar_chart_rounded, true, () {}),
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

  Widget _buildPlatformChip(String platform) {
    final isSelected = selectedPlatform == platform;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlatform = platform;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC3ECCA) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          platform,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String label) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12), 
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFC3ECCA),
              fontSize: 20, 
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2, 
            overflow: TextOverflow.ellipsis, 
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              height: 1.2, 
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTimePeriod(String period) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      period,
      textAlign: TextAlign.center, 
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

  Widget _buildChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 90,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 10),
                FlSpot(1, 30),
                FlSpot(2, 25),
                FlSpot(3, 20),
                FlSpot(4, 45),
                FlSpot(5, 70),
                FlSpot(6, 85),
              ],
              isCurved: true,
              color: const Color(0xFF00FF00),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF00FF00).withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}