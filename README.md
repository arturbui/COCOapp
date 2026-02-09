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
<pre> git clone https://github.com/arturbui/COCOapp.git </pre>
Navigate into the project directory:
<pre>cd COCOapp</pre>

## Running the project locally
### Backend setup
Create a `.env`file in `COCOapp` with the following contents:
<pre>ANTHROPIC_API_KEY=your_api_key_here</pre>
Navigate to the backend directory:
<pre>cd COCOapp/coco-backend</pre>
Install dependencies:
<pre>npm install</pre>
Create a `.env`file in `coco-backend` with the following contents:
<pre>ANTHROPIC_API_KEY=your_api_key_here</pre>
Start the backend server in coco-backend:
<pre>npm start</pre>

### Frontend setup
1. Open the project in Android Studio
2. Ensure Flutter and Dart are installed
3. Connect an Android device or start an emulator
4. Run the application:
<pre>flutter run</pre>
## Api base URL configuration

To get the backend to run you will need to make to changes based on your environment. 
#### backend_service.dart

```dart
class BackendService {
  // Change this to your computer's IP address when testing on phone
  // For web: use localhost:3000
  // For android: use http://192.168.2.33:3000/api
  static const String baseUrl = 'http://localhost:3000/api';

  String? _token;

```
- `10.0.2.2` is used for Android Emulators
- `localhost` is used for browser testing
- If you're using an android device, a local IPv4 adress is required

#### claude_service.dart
```dart
class ClaudeService {
  static const String _baseUrl = 'http://localhost:3000/api/claude';

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Please login first');
    }
    return token;
  }

```
- `10.0.2.2` is used for Android Emulators
- `localhost` is used for browser testing
- If you're using an android device, a local IPv4 adress is required
## Contributors
- Artur Buivydis (https://github.com/arturbui)
- Mantas Grusauskas (https://github.com/MantasGrusa)
