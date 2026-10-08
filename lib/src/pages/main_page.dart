import 'package:flutter/material.dart';
import 'home_page.dart';
import 'simulation_page.dart';
import 'trusted_providers_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SimulationPage(),
    const TrustedProvidersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E).withOpacity(0.95),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF3A3A3A).withOpacity(0.5),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'الرئيسية',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.solar_power_outlined,
                  activeIcon: Icons.solar_power,
                  label: 'المحاكاة',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.business_outlined,
                  activeIcon: Icons.business,
                  label: 'الجهات',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'ملفي',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? const Color(0xFF00E676)
                    : const Color(0xFF6A6A6A),
                size: 22,
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive
                        ? const Color(0xFF00E676)
                        : const Color(0xFF6A6A6A),
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

