import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all screens
import 'start_screen.dart';
import 'signup_screen.dart';
import 'onboarding_questions.dart';
import 'recommendation_screen.dart';
import 'onboarding_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: MaterialApp(
        title: 'COCO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF00FF00),
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Inter', // You can add a custom font
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const StartScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/onboarding/question1': (context) => const Question1Screen(),
          '/onboarding/question2': (context) => const Question2Screen(),
          '/onboarding/question3': (context) => const Question3Screen(),
          '/onboarding/question4': (context) => const Question4Screen(),
          '/onboarding/question5': (context) => const Question5Screen(),
          '/onboarding/recommendation': (context) => const RecommendationScreen(),
          '/home': (context) => const HomeScreen(), // Placeholder for now
        },
      ),
    );
  }
}

// Placeholder Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to COCO!',
              style: TextStyle(
                color: Color(0xFF00FF00),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Onboarding Complete ✓',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Back to Start',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
