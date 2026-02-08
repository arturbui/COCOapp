import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_provider.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    final recommendations = provider.getRecommendations();
    final targetAudience = provider.data.targetAudience ?? 'your audience';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title
              const Text(
                'No worries, that means we can build your presence from the ground up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              // Recommendation text
              Text(
                'First things first, we need to setup your social media accounts, for your audience We\'d recommend ${_formatPlatformList(recommendations)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              // Platform cards
              Expanded(
                child: ListView.builder(
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return _buildPlatformCard(recommendations[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Meta Business Account Section
              const Text(
                'To setup for Instagram/Facebook we have to create a Meta business account, this can be done by clicking on this link.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              // Meta button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Open Meta business account link
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/meta_logo.png', // You'll need to add this asset
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.business, color: Colors.blue);
                        },
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Meta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This will allow you to post on the business account through our application',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPlatformList(List<String> platforms) {
    if (platforms.isEmpty) return 'social media platforms';
    if (platforms.length == 1) return platforms.first;
    if (platforms.length == 2) return '${platforms[0]} and ${platforms[1]}';
    
    String result = '';
    for (int i = 0; i < platforms.length; i++) {
      if (i == platforms.length - 1) {
        result += 'and ${platforms[i]}';
      } else {
        result += '${platforms[i]}, ';
      }
    }
    return result;
  }

  Widget _buildPlatformCard(String platform) {
    IconData icon;
    Color color;

    switch (platform) {
      case 'Instagram':
        icon = Icons.camera_alt;
        color = const Color(0xFFE4405F);
        break;
      case 'Facebook':
        icon = Icons.facebook;
        color = const Color(0xFF1877F2);
        break;
      case 'TikTok':
        icon = Icons.music_note;
        color = Colors.black;
        break;
      case 'LinkedIn':
        icon = Icons.business;
        color = const Color(0xFF0A66C2);
        break;
      case 'Twitter':
        icon = Icons.flutter_dash;
        color = const Color(0xFF1DA1F2);
        break;
      case 'YouTube':
        icon = Icons.play_circle_filled;
        color = const Color(0xFFFF0000);
        break;
      default:
        icon = Icons.public;
        color = const Color(0xFF00FF00);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00FF00), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            platform,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
