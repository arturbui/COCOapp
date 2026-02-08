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
    super.key,
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
  });

  @override
  State<OnboardingQuestionScreen> createState() => _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState extends State<OnboardingQuestionScreen> {
  String? _selectedValue;
  List<String> _selectedCheckboxes = [];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    _selectedCheckboxes = widget.selectedCheckboxes ?? [];
  }

  @override
  Widget build(BuildContext context) {
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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.title.split(' ').first} ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: widget.title.split(' ').skip(1).join(' '),
                      style: const TextStyle(
                        color: Color(0xFF00FF00),
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Question
              Text(
                widget.question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              // Dropdown
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedValue,
                    hint: const Text(
                      'Select an option',
                      style: TextStyle(color: Colors.grey),
                    ),
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1a1a1a),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    items: widget.options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedValue = newValue;
                        });
                        widget.onSelected(newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Checkboxes (if applicable)
              if (widget.showCheckboxes && widget.checkboxOptions != null) ...[
                const Text(
                  'If yes, which social media?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: widget.checkboxOptions!.map((platform) {
                      return CheckboxListTile(
                        title: Text(
                          platform,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        value: _selectedCheckboxes.contains(platform),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedCheckboxes.add(platform);
                            } else {
                              _selectedCheckboxes.remove(platform);
                            }
                          });
                          if (widget.onCheckboxChanged != null) {
                            widget.onCheckboxChanged!(_selectedCheckboxes);
                          }
                        },
                        activeColor: const Color(0xFF00FF00),
                        checkColor: Colors.black,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const Spacer(),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedValue != null ? widget.onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF00),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[800],
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
