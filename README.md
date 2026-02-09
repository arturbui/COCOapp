# COCO App - 
## Project Description
This is a university project developed by **Artur Buivydis** and **Mantas Grusauskas**. The project focuses on building a symplified posting system that assists self employed users and small to medium sized enterprises in managing their social media content and marketing strategies. This achieved through the use of an AI chatbot and an extensive onboarding that provides the app with necessary data to provide the best advice to the user.

This repository contains both the Flutter mobile application and the Node.js backend used during development.

## Tools and Technologies
### Frontend
- Flutter
- Dart
- Android Studio
### Backend
- Node.js
- Express.js
- Claude AI API
## Cloning the Repository
To clone the project repository locally, run the following command:
<pre> ```git clone https://github.com/arturbui/COCOapp.git``` </pre>
## Api base URL configuration

The Flutter app switches API base URLs depending on the runtime environment. Example from AuthService:
` 
<pre> dart class AuthService {
  // Android emulator
  // static const String _baseUrl = 'http://10.0.2.2:3000/api/auth';

  // Browser or local testing
  // static const String _baseUrl = 'http://localhost:3000/api/auth';

  // Physical Android device
  static const String _baseUrl = 'http://192.168.0.100:3000/api/auth';
}  </pre>
## Contributors
- Artur Buivydis (https://github.com/arturbui)
- Mantas Grusauskas (https://github.com/MantasGrusa)
