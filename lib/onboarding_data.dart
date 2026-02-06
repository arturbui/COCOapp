class OnboardingData {
  String? marketingChallenge;
  String? socialMediaPresence;
  List<String> selectedPlatforms = [];
  String? targetAudience;
  String? businessType;
  String? successGoal;

  // Recommendation logic
  List<String> getRecommendedPlatforms() {
    Set<String> recommendations = {};

    // Based on target audience
    if (targetAudience == 'Local customers') {
      recommendations.addAll(['Facebook', 'Instagram']);
    } else if (targetAudience == 'Professionals / B2B') {
      recommendations.add('LinkedIn');
    } else if (targetAudience == 'Students / young adults') {
      recommendations.addAll(['TikTok', 'Instagram']);
    } else if (targetAudience == 'Parents / families') {
      recommendations.addAll(['Facebook', 'Instagram']);
    } else if (targetAudience == 'Niche community') {
      recommendations.addAll(['Instagram', 'YouTube']);
    }

    // Based on business type
    if (businessType == 'Local business') {
      recommendations.addAll(['Facebook', 'Instagram']);
    } else if (businessType == 'Online store') {
      recommendations.addAll(['Instagram', 'TikTok', 'Facebook']);
    } else if (businessType == 'Service-based business') {
      recommendations.addAll(['LinkedIn', 'Facebook']);
    } else if (businessType == 'Personal brand') {
      recommendations.addAll(['Instagram', 'TikTok', 'YouTube']);
    } else if (businessType == 'Startup / tech') {
      recommendations.addAll(['LinkedIn', 'Twitter']);
    }

    // If no strong recommendations, suggest the most popular ones
    if (recommendations.isEmpty) {
      recommendations.addAll(['Instagram', 'Facebook']);
    }

    return recommendations.toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'marketingChallenge': marketingChallenge,
      'socialMediaPresence': socialMediaPresence,
      'selectedPlatforms': selectedPlatforms,
      'targetAudience': targetAudience,
      'businessType': businessType,
      'successGoal': successGoal,
    };
  }
}
