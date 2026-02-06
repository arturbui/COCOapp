import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingProvider extends ChangeNotifier {
  final OnboardingData _data = OnboardingData();

  OnboardingData get data => _data;

  void setMarketingChallenge(String value) {
    _data.marketingChallenge = value;
    notifyListeners();
  }

  void setSocialMediaPresence(String value) {
    _data.socialMediaPresence = value;
    notifyListeners();
  }

  void setSelectedPlatforms(List<String> platforms) {
    _data.selectedPlatforms = platforms;
    notifyListeners();
  }

  void setTargetAudience(String value) {
    _data.targetAudience = value;
    notifyListeners();
  }

  void setBusinessType(String value) {
    _data.businessType = value;
    notifyListeners();
  }

  void setSuccessGoal(String value) {
    _data.successGoal = value;
    notifyListeners();
  }

  List<String> getRecommendations() {
    return _data.getRecommendedPlatforms();
  }

  void reset() {
    _data.marketingChallenge = null;
    _data.socialMediaPresence = null;
    _data.selectedPlatforms.clear();
    _data.targetAudience = null;
    _data.businessType = null;
    _data.successGoal = null;
    notifyListeners();
  }
}
