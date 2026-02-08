import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

class VideoEditorScreen extends StatefulWidget {
  final String filePath;
  final bool isVideo;

  const VideoEditorScreen({
    super.key,
    required this.filePath,
    required this.isVideo,
  });

  @override
  _VideoEditorScreenState createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  VideoPlayerController? _controller;
  bool isPlaying = false;
  double currentPosition = 0.0;
  double totalDuration = 21.0;

  double trimStart = 0.0;
  double trimEnd = 21.0;

  List<TextOverlay> textOverlays = [];

  String? audioTrackPath;

  String selectedFilter = 'None';

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.isVideo) {
      String videoPath = '/storage/emulated/0/Download/test_video.mp4';

      _controller = VideoPlayerController.file(File(videoPath))
        ..initialize()
            .then((_) {
              setState(() {
                totalDuration = _controller!.value.duration.inSeconds
                    .toDouble();
                trimEnd = totalDuration;
              });

              // Update position as video plays
              _controller!.addListener(() {
                if (_controller!.value.isPlaying) {
                  setState(() {
                    currentPosition = _controller!.value.position.inSeconds
                        .toDouble();
                  });
                }
              });
            })
            .catchError((error) {
              print('Error loading video: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading video: $error')),
              );
            });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFC3ECCA),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  GestureDetector(
                    onTap: _exportVideo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF5EFF79),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Video preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Actual video player
                      if (_controller != null &&
                          _controller!.value.isInitialized)
                        FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller!.value.size.width,
                            height: _controller!.value.size.height,
                            child: VideoPlayer(_controller!),
                          ),
                        )
                      else
                        Container(
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF5EFF79),
                            ),
                          ),
                        ),

                      Center(
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),

                      ...textOverlays.map(
                        (overlay) => Positioned(
                          left: 50,
                          top: 50,
                          child: Text(
                            overlay.text,
                            style: TextStyle(
                              color: overlay.color,
                              fontSize: overlay.fontSize,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (selectedFilter != 'None')
                        Container(color: _getFilterColor()),
                    ],
                  ),
                ),
              ),
            ),

            if (widget.isVideo) _buildTimeline(),

            if (audioTrackPath != null)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.music_note,
                      color: Color(0xFF5EFF79),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Audio Track Added',
                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          audioTrackPath = null;
                        });
                      },
                    ),
                  ],
                ),
              ),

            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Stack(
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 40,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color:
                              index >= (trimStart / totalDuration * 10) &&
                                  index <= (trimEnd / totalDuration * 10)
                              ? Color(0xFF5EFF79)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  _formatDuration(currentPosition),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value: currentPosition,
                    max: totalDuration,
                    activeColor: Color(0xFF5EFF79),
                    inactiveColor: Colors.grey[600],
                    onChanged: (value) {
                      setState(() {
                        currentPosition = value;
                      });
                      _controller?.seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Text(
                  _formatDuration(totalDuration),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(Icons.content_cut, 'Trim', _showTrimDialog),
          _buildControlButton(Icons.audio_file, 'Audio', _addAudioTrack),
          _buildControlButton(Icons.text_fields, 'Text', _showTextDialog),
          _buildControlButton(Icons.tune, 'Filter', _showFilterDialog),
          _buildControlButton(
            Icons.subtitles,
            'Captions',
            _showCaptionsPlaceholder,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF5EFF79), size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (_controller != null && _controller!.value.isInitialized) {
      if (isPlaying) {
        _controller!.play();
      } else {
        _controller!.pause();
      }
    }
  }

  void _showTrimDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Trim Video',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Start: ${_formatDuration(trimStart)}',
                style: TextStyle(color: Colors.grey[300]),
              ),
              Slider(
                value: trimStart,
                max: totalDuration,
                activeColor: Color(0xFF5EFF79),
                onChanged: (value) {
                  setDialogState(() {
                    if (value < trimEnd) {
                      trimStart = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                'End: ${_formatDuration(trimEnd)}',
                style: TextStyle(color: Colors.grey[300]),
              ),
              Slider(
                value: trimEnd,
                max: totalDuration,
                activeColor: Color(0xFF5EFF79),
                onChanged: (value) {
                  setDialogState(() {
                    if (value > trimStart) {
                      trimEnd = value;
                    }
                  });
                },
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
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Video trimmed: ${_formatDuration(trimStart)} - ${_formatDuration(trimEnd)}',
                    ),
                    backgroundColor: Color(0xFF5EFF79),
                  ),
                );
              },
              child: const Text(
                'Apply',
                style: TextStyle(color: Color(0xFF5EFF79)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addAudioTrack() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        audioTrackPath = result.files.single.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio track added!'),
          backgroundColor: Color(0xFF5EFF79),
        ),
      );
    }
  }

  void _showTextDialog() {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Add Text', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter text',
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
              if (textController.text.isNotEmpty) {
                setState(() {
                  textOverlays.add(
                    TextOverlay(
                      text: textController.text,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Text overlay added!'),
                    backgroundColor: Color(0xFF5EFF79),
                  ),
                );
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Select Filter',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('None'),
            _buildFilterOption('Grayscale'),
            _buildFilterOption('Sepia'),
            _buildFilterOption('Warm'),
            _buildFilterOption('Cool'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filterName) {
    return ListTile(
      title: Text(filterName, style: const TextStyle(color: Colors.white)),
      trailing: selectedFilter == filterName
          ? const Icon(Icons.check, color: Color(0xFF5EFF79))
          : null,
      onTap: () {
        setState(() {
          selectedFilter = filterName;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$filterName filter applied!'),
            backgroundColor: Color(0xFF5EFF79),
          ),
        );
      },
    );
  }

  void _showCaptionsPlaceholder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Auto Captions',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.smart_toy, color: Color(0xFF5EFF79), size: 60),
            const SizedBox(height: 20),
            Text(
              'AI-powered auto captions will be available soon!',
              style: TextStyle(color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'This feature will use our AI chatbot to generate captions automatically.',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: Color(0xFF5EFF79)),
            ),
          ),
        ],
      ),
    );
  }

  void _exportVideo() {
    // This will handle the final video export with all edits applied
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Export Video',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF5EFF79)),
            const SizedBox(height: 20),
            Text(
              'Exporting your video...',
              style: TextStyle(color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );

    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close export dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video exported successfully!'),
          backgroundColor: Color(0xFF5EFF79),
        ),
      );
    });
  }

  Color _getFilterColor() {
    switch (selectedFilter) {
      case 'Grayscale':
        return Colors.grey.withOpacity(0.5);
      case 'Sepia':
        return Colors.brown.withOpacity(0.3);
      case 'Warm':
        return Colors.orange.withOpacity(0.2);
      case 'Cool':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.transparent;
    }
  }

  String _formatDuration(double seconds) {
    int minutes = (seconds / 60).floor();
    int secs = (seconds % 60).floor();
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

// Text overlay model
class TextOverlay {
  final String text;
  final Color color;
  final double fontSize;

  TextOverlay({
    required this.text,
    required this.color,
    required this.fontSize,
  });
}
