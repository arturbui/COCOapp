import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScheduleScreen extends StatefulWidget {
  final String videoPath;

  const PostScheduleScreen({
    super.key,
    required this.videoPath,
  });

  @override
  State<PostScheduleScreen> createState() => _PostScheduleScreenState();
}

class _PostScheduleScreenState extends State<PostScheduleScreen> {
  int currentStep = 0;
  
  String hashtagMode = 'Generate with AI';
  List<String> customHashtags = [];
  List<String> generatedHashtags = [
    '#business',
    '#entrepreneur',
    '#success',
    '#motivation',
    '#work'
  ];
  
  List<String> selectedPlatforms = [];
  final List<String> availablePlatforms = [
    'Instagram',
    'TikTok',
    'Facebook',
    'YouTube',
    'Twitter'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              flex: 2,
              child: currentStep == 0 ? _buildHashtagStep() : _buildPlatformStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashtagStep() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hashtags',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildHashtagButton(
            'Generate with AI',
            hashtagMode == 'Generate with AI',
            () {
              setState(() {
                hashtagMode = 'Generate with AI';
              });
            },
          ),
          
          const SizedBox(height: 10),
          
          _buildHashtagButton(
            'Custom',
            hashtagMode == 'Custom',
            () {
              setState(() {
                hashtagMode = 'Custom';
              });
              _showCustomHashtagDialog();
            },
          ),
          
          const Spacer(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Platform',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              Row(
                children: [
                  const Text(
                    'Hashtags',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: () {
              setState(() {
                currentStep = 1;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformStep() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showPlatformPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedPlatforms.isEmpty 
                          ? 'Platform' 
                          : selectedPlatforms.join(', '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              Row(
                children: [
                  const Text(
                    'Hashtags',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: _postVideo,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF5EFF79),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashtagButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: const Color(0xFF5EFF79), width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showCustomHashtagDialog() {
    TextEditingController hashtagController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Add Custom Hashtags',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hashtagController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter hashtags (comma separated)',
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5EFF79)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (hashtagController.text.isNotEmpty) {
                setState(() {
                  customHashtags = hashtagController.text
                      .split(',')
                      .map((tag) => tag.trim())
                      .where((tag) => tag.isNotEmpty)
                      .toList();
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xFF5EFF79)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlatformPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Select Platforms',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availablePlatforms.map((platform) {
            final isSelected = selectedPlatforms.contains(platform);
            return CheckboxListTile(
              title: Text(
                platform,
                style: const TextStyle(color: Colors.white),
              ),
              value: isSelected,
              activeColor: const Color(0xFF5EFF79),
              checkColor: Colors.black,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedPlatforms.add(platform);
                  } else {
                    selectedPlatforms.remove(platform);
                  }
                });
                Navigator.pop(context);
                _showPlatformPicker();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(color: Color(0xFF5EFF79)),
            ),
          ),
        ],
      ),
    );
  }

  void _postVideo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF5EFF79)),
            const SizedBox(height: 20),
            Text(
              'Posting your video...',
              style: TextStyle(color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('latest_ad_views', '1234');
    await prefs.setString('latest_ad_clicks', '87');
    await prefs.setString('latest_ad_ctr', '7.1');
    await prefs.setBool('has_posted_ad', true);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Posted!',
            style: TextStyle(color: Color(0xFF5EFF79)),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF5EFF79),
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                'Your video has been posted successfully!',
                style: TextStyle(color: Colors.grey[300]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: const Text(
                'Go to Home',
                style: TextStyle(color: Color(0xFF5EFF79)),
              ),
            ),
          ],
        ),
      );
    });
  }
}