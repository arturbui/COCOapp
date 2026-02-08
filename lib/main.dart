import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'start_screen.dart';
import 'signup_screen.dart';
import 'onboarding_questions.dart';
import 'recommendation_screen.dart';
import 'onboarding_provider.dart';
import 'screens/chat_screen.dart';

import 'screens/home_screen.dart';
import 'screens/create_screen.dart';
import 'screens/video_editor_screen.dart';

Future<void> main() async {
  // Load environment variables for Claude API (skip if file not found)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(
      'Warning: .env file not found. Claude chatbot will not work without API key.',
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),
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
          '/onboarding/recommendation': (context) =>
              const RecommendationScreen(),
          '/chat': (context) => const ChatScreen(),
          '/home': (context) => const HomeScreen(),
          '/create': (context) => CreateScreen(),
          '/editor': (context) =>
              const VideoEditorScreen(filePath: '', isVideo: true),
        },
      ),
    );
  }
}
