import 'package:flutter/material.dart';
import 'main_page.dart';
import 'onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E1E1E),
                    border: Border.all(
                      color: const Color(0xFF00E676),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E676).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.solar_power,
                    size: 60,
                    color: Color(0xFF00E676),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'PowerReady',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00E676),
                    fontFamily: 'IBMPlexSansArabic',
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'جاهزية المنزل تبدأ من هنا',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'IBMPlexSansArabic',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

                        if (mounted) {
                          if (onboardingCompleted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const MainPage()),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const OnboardingPage()),
                            );
                          }
                        }
                      } catch (e) {
                        // إذا فشل SharedPreferences، انتقل مباشرة إلى Onboarding
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const OnboardingPage()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: const Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ابدأ التقييم الآن',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
