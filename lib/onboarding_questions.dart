import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_question_screen.dart';
import 'onboarding_provider.dart';

// Question 1: What feels hardest about marketing today?
class Question1Screen extends StatelessWidget {
  const Question1Screen({super.key});

  static const List<String> options = [
    "I don't know what to post",
    "I don't have enough time",
    "I'm not getting customers",
    "My content isn't engaging",
    "I don't understand marketing",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingQuestionScreen(
      title: "Tell us more about yourself",
      question: "What feels hardest about marketing today?",
      options: options,
      selectedValue: provider.data.marketingChallenge,
      onSelected: (value) => provider.setMarketingChallenge(value),
      onNext: () => Navigator.pushNamed(context, '/onboarding/question2'),
    );
  }
}

// Question 2: How established is your social media presence
class Question2Screen extends StatelessWidget {
  const Question2Screen({super.key});

  static const List<String> options = [
    "No accounts yet",
    "Accounts created, but inactive",
    "I post occasionally",
    "I post consistently",
    "I actively use social media for business",
  ];

  static const List<String> platformOptions = [
    "Instagram",
    "TikTok",
    "Facebook",
    "LinkedIn",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingQuestionScreen(
      title: "Perfect, that's why We at COCO are here!",
      question: "Now, to get started, How established is your social media presence",
      options: options,
      selectedValue: provider.data.socialMediaPresence,
      onSelected: (value) => provider.setSocialMediaPresence(value),
      showCheckboxes: true,
      checkboxOptions: platformOptions,
      selectedCheckboxes: provider.data.selectedPlatforms,
      onCheckboxChanged: (platforms) => provider.setSelectedPlatforms(platforms),
      onNext: () => Navigator.pushNamed(context, '/onboarding/question3'),
    );
  }
}

// Question 3: Who are you trying to reach?
class Question3Screen extends StatelessWidget {
  const Question3Screen({super.key});

  static const List<String> options = [
    "Local customers",
    "Professionals / B2B",
    "Students / young adults",
    "Parents / families",
    "Niche community",
    "Not sure yet",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingQuestionScreen(
      title: "Tell us more about yourself",
      question: "Who are you trying to reach?",
      options: options,
      selectedValue: provider.data.targetAudience,
      onSelected: (value) => provider.setTargetAudience(value),
      onNext: () => Navigator.pushNamed(context, '/onboarding/question4'),
    );
  }
}

// Question 4: Where are you starting from?
class Question4Screen extends StatelessWidget {
  const Question4Screen({super.key});

  static const List<String> options = [
    "Local business",
    "Online store",
    "Service-based business",
    "Personal brand",
    "Startup / tech",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingQuestionScreen(
      title: "Tell us more about yourself",
      question: "Where are you starting from?",
      options: options,
      selectedValue: provider.data.businessType,
      onSelected: (value) => provider.setBusinessType(value),
      onNext: () => Navigator.pushNamed(context, '/onboarding/question5'),
    );
  }
}

// Question 5: What would success look like in the next 3 months
class Question5Screen extends StatelessWidget {
  const Question5Screen({super.key});

  static const List<String> options = [
    "Get my first customers",
    "Increase brand awareness",
    "Generate leads",
    "Sell more products",
    "Grow my audience",
    "Not sure yet",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingQuestionScreen(
      title: "Tell us more about yourself",
      question: "What would success look like in the next 3 months",
      options: options,
      selectedValue: provider.data.successGoal,
      onSelected: (value) => provider.setSuccessGoal(value),
      onNext: () => Navigator.pushNamed(context, '/onboarding/recommendation'),
    );
  }
}
