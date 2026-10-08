import 'package:flutter/material.dart';
import '../models/home_model.dart';
import '../services/analysis_service.dart';
import '../widgets/card_stat.dart';
import 'simulation_page.dart';
import 'trusted_providers_page.dart';

class ReportPage extends StatelessWidget {
  final HomeModel home;

  const ReportPage({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    final score = home.readinessScore ?? AnalysisService.calculateReadinessScore(home);
    final detailedScores = AnalysisService.getDetailedScores(home);
    final labels = AnalysisService.getScoreLabels();
    final recommendations = AnalysisService.getRecommendations(home);
    final level = AnalysisService.getReadinessLevel(score);
    final levelColor = AnalysisService.getReadinessLevelColor(score);

    return Scaffold(
      appBar: AppBar(
        title: Text(home.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.solar_power),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SimulationPage(home: home),
                ),
              );
            },
            tooltip: 'محاكاة الطاقة',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة الجاهزية الإجمالية مع شارة
          _buildGlassCard(
            child: Column(
              children: [
                Text(
                  'منزلك جاهز بنسبة ${score.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(levelColor),
                    fontFamily: 'IBMPlexSansArabic',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildBadge(level, Color(levelColor)),
                const SizedBox(height: 24),
                const Text(
                  'نسبة الجاهزية الإجمالية',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${score.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color(levelColor),
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: const Color(0xFF2C2C2C),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(levelColor)),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'تفاصيل المقاييس',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // بطاقات المقاييس مع Progress bars
          ...detailedScores.entries.map((entry) {
            final label = labels[entry.key] ?? entry.key;
            final value = entry.value;
            return _buildMetricCard(
              label: label,
              value: value,
              description: _getMetricDescription(entry.key, value),
            );
          }).toList(),
          const SizedBox(height: 24),
          const Text(
            'التوصيات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...recommendations.map((recommendation) {
            return _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF00E676),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          // معلومات المنزل
          _buildGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'معلومات المنزل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('الموقع', home.location),
                  _buildInfoRow('مساحة السطح', '${home.roofArea} م²'),
                  _buildInfoRow('اتجاه السطح', home.direction),
                  _buildInfoRow('الظل', _getShadowLabel(home.shadow)),
                  _buildInfoRow('جودة السطح', home.structuralQuality ?? 'متوسط'),
                  _buildInfoRow('الاستهلاك الشهري', '${home.monthlyConsumption} kWh'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrustedProvidersPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.business),
                      label: const Text('اطلب التركيب من جهة مختصة'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF00E676),
                        foregroundColor: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3A3A3A).withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required double value,
    required String description,
  }) {
    Color valueColor = _getScoreColor(value);

    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: const Color(0xFF2C2C2C),
              valueColor: AlwaysStoppedAnimation<Color>(valueColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFB0B0B0),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getMetricDescription(String key, double value) {
    switch (key) {
      case 'orientation':
        if (value >= 85) return 'اتجاه مثالي للألواح الشمسية';
        if (value >= 70) return 'اتجاه جيد، يمكن تحسينه قليلاً';
        return 'اتجاه يحتاج تحسين، يُنصح بتوجيه نحو الجنوب';
      case 'area':
        if (value >= 100) return 'مساحة كبيرة وممتازة للألواح';
        if (value >= 60) return 'مساحة جيدة لكن يمكن إضافة المزيد';
        return 'مساحة صغيرة، يُنصح بتوسيع السطح';
      case 'shadow':
        if (value >= 80) return 'ظلال قليلة جداً، أداء ممتاز';
        if (value >= 50) return 'ظلال متوسطة، يمكن تحسينها';
        return 'ظلال كثيفة، يُنصح بإزالة العوائق';
      case 'consumption':
        if (value >= 70) return 'استهلاك جيد، نظام كبير مناسب';
        return 'استهلاك منخفض، يُنصح بنظام متوسط الحجم';
      case 'structural':
        if (value >= 75) return 'جودة إنشائية ممتازة، جاهز للتركيب';
        if (value >= 50) return 'جودة جيدة، قد تحتاج فحص إضافي';
        return 'جودة تحتاج تحسين قبل التركيب';
      default:
        return '';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getShadowLabel(String shadow) {
    switch (shadow) {
      case 'none':
        return 'لا يوجد';
      case 'light':
        return 'خفيف';
      case 'moderate':
        return 'متوسط';
      case 'heavy':
        return 'كثيف';
      default:
        return shadow;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) {
      return const Color(0xFF00E676);
    } else if (score >= 65) {
      return const Color(0xFFFFC107);
    } else if (score >= 40) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFFF5252);
    }
  }
}
