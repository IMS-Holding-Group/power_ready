import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'مرحباً في PowerReady',
      description: 'تطبيق ذكي لتقييم جاهزية منزلك لاستخدام الطاقة الشمسية. نقوم بتحليل عدة معايير مهمة لتقديم تقييم شامل ودقيق.',
      icon: Icons.solar_power,
    ),
    OnboardingSlide(
      title: 'كيف يعمل التقييم؟',
      description: 'نقوم بتحليل اتجاه السطح، المساحة، نسبة الظلال، الاستهلاك الكهربائي، وجودة السطح الإنشائية. ثم نقدم لك تقريراً مفصلاً وتوصيات مخصصة.',
      icon: Icons.assessment,
    ),
    OnboardingSlide(
      title: 'استفد من النتائج',
      description: 'احصل على تقرير شامل مع نسب الجاهزية، محاكاة لإنتاج الطاقة، ومصادر معتمدة للطاقة المتجددة. ابدأ الآن!',
      icon: Icons.trending_up,
    ),
  ];

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (e) {
      // إذا فشل SharedPreferences، استمر في التنقل
    }
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index]);
                },
              ),
            ),
            _buildPageIndicator(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _slides.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF000000),
                  ),
                  child: Text(
                    _currentPage < _slides.length - 1 ? 'التالي' : 'ابدأ الآن',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            slide.icon,
            size: 80,
            color: const Color(0xFF00E676),
          ),
          const SizedBox(height: 32),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            slide.description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB0B0B0),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF00E676)
                : const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
  });
}

