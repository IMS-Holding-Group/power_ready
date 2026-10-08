import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  _checkOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

        if (onboardingCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        }
      } catch (e) {
        // إذا فشل SharedPreferences، انتقل مباشرة إلى Welcome Page
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Text(
          'PowerReady',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00E676),
            fontFamily: 'IBMPlexSansArabic',
          ),
        ),
      ),
    );
  }
}
