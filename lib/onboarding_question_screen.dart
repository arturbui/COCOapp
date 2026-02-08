import 'package:flutter/material.dart';

class OnboardingQuestionScreen extends StatefulWidget {
  final String title;
  final String question;
  final List<String> options;
  final String? selectedValue;
  final Function(String) onSelected;
  final VoidCallback onNext;
  final bool showCheckboxes;
  final List<String>? checkboxOptions;
  final List<String>? selectedCheckboxes;
  final Function(List<String>)? onCheckboxChanged;

  const OnboardingQuestionScreen({
    Key? key,
    required this.title,
    required this.question,
    required this.options,
    this.selectedValue,
    required this.onSelected,
    required this.onNext,
    this.showCheckboxes = false,
    this.checkboxOptions,
    this.selectedCheckboxes,
    this.onCheckboxChanged,
  }) : super(key: key);

  @override
  State<OnboardingQuestionScreen> createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState extends State<OnboardingQuestionScreen> {
  String? _selectedValue;
  List<String> _selectedCheckboxes = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    _selectedCheckboxes = widget.selectedCheckboxes ?? [];
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _selectOption(String value) {
    setState(() {
      _selectedValue = value;
      _isDropdownOpen = false;
    });
    widget.onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Match home screen
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title with green highlight
              _buildTitle(),
              const SizedBox(height: 40),
              // Question
              Text(
                widget.question,
                style: const TextStyle(
                  color: Color(0xFFC3ECCA), // Match home screen text
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              // Custom Dropdown
              _buildCustomDropdown(),
              const SizedBox(height: 24),
              // Checkboxes (if applicable)
              if (widget.showCheckboxes && widget.checkboxOptions != null) ...[
                const Text(
                  'If yes, which social media?',
                  style: TextStyle(
                    color: Color(0xFFC3ECCA),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCheckboxes(),
              ],
              const Spacer(),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedValue != null ? widget.onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF94FFA6,
                    ), // Match home screen green
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: const Color(0xFF2A2A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    // Split title to highlight certain words in green
    final words = widget.title.split(' ');
    final List<TextSpan> spans = [];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      // Highlight specific words in green
      final isGreen =
          word.toLowerCase().contains('yourself') ||
          word.toLowerCase().contains('coco') ||
          word.toLowerCase().contains('we') ||
          word.toLowerCase().contains('you');

      spans.add(
        TextSpan(
          text: word + (i < words.length - 1 ? ' ' : ''),
          style: TextStyle(
            color: isGreen ? const Color(0xFF94FFA6) : const Color(0xFFC3ECCA),
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildCustomDropdown() {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF5EFF79), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedValue ?? 'Select an option',
                    style: TextStyle(
                      color: _selectedValue != null
                          ? const Color(0xFFC3ECCA)
                          : const Color(0xFF5C6E5F),
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF94FFA6),
                ),
              ],
            ),
            if (_isDropdownOpen) ...[
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF2A2A2A), thickness: 1),
              const SizedBox(height: 8),
              ...widget.options.map((option) {
                final isSelected = _selectedValue == option;
                return InkWell(
                  onTap: () => _selectOption(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF94FFA6)
                            : const Color(0xFFC3ECCA),
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        border: Border.all(color: const Color(0xFF5EFF79), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: widget.checkboxOptions!.map((platform) {
          final isChecked = _selectedCheckboxes.contains(platform);
          return InkWell(
            onTap: () {
              setState(() {
                if (isChecked) {
                  _selectedCheckboxes.remove(platform);
                } else {
                  _selectedCheckboxes.add(platform);
                }
              });
              if (widget.onCheckboxChanged != null) {
                widget.onCheckboxChanged!(_selectedCheckboxes);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    platform,
                    style: const TextStyle(
                      color: Color(0xFFC3ECCA),
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isChecked
                          ? const Color(0xFF94FFA6)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFF94FFA6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 18, color: Colors.black)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
