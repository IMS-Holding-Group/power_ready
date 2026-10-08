import '../models/home_model.dart';

class AnalysisService {
  // حساب درجة الجاهزية مع المعايير الجديدة
  // الأوزان: اتجاه 25%, مساحة 25%, ظلال 15%, استهلاك 20%, جودة السطح 15%
  static double calculateReadinessScore(HomeModel home) {
    double orientationScore = _getOrientationScore(home.direction);
    double areaScore = _getAreaScore(home.roofArea);
    double shadowScore = _getShadowScore(home.shadow);
    double consumptionScore = _getConsumptionScore(home.monthlyConsumption);
    double structuralScore = _getStructuralQualityScore(home.structuralQuality ?? 'متوسط');

    // المعادلة: sum(score * weight)
    double score = orientationScore * 0.25 +
        areaScore * 0.25 +
        shadowScore * 0.15 +
        consumptionScore * 0.20 +
        structuralScore * 0.15;

    return score;
  }

  // حساب درجة الاتجاه (0-100)
  static double _getOrientationScore(String direction) {
    switch (direction) {
      case 'جنوب':
        return 100;
      case 'جنوب شرق':
      case 'جنوب غرب':
        return 85;
      case 'شرق':
      case 'غرب':
        return 70;
      case 'شمال شرق':
      case 'شمال غرب':
        return 50;
      case 'شمال':
        return 20;
      default:
        return 50;
    }
  }

  // حساب درجة المساحة (0-100)
  static double _getAreaScore(double area) {
    if (area >= 20) {
      return 100;
    } else if (area >= 10) {
      return 60;
    } else {
      return 30;
    }
  }

  // حساب درجة الظلال (0-100)
  static double _getShadowScore(String shadow) {
    switch (shadow) {
      case 'none':
        return 100;
      case 'light':
        return 80;
      case 'moderate':
        return 50;
      case 'heavy':
        return 10;
      default:
        return 50;
    }
  }

  // حساب درجة الاستهلاك (0-100)
  static double _getConsumptionScore(double consumption) {
    if (consumption >= 600) {
      return 100;
    } else if (consumption >= 300) {
      return 70;
    } else {
      return 40;
    }
  }

  // حساب درجة جودة السطح (0-100)
  // ممتاز = 100, جيد = 75, متوسط = 50, ضعيف = 20
  static double _getStructuralQualityScore(String quality) {
    switch (quality) {
      case 'ممتاز':
        return 100;
      case 'جيد':
        return 75;
      case 'متوسط':
        return 50;
      case 'ضعيف':
        return 20;
      default:
        return 50;
    }
  }

  // الحصول على توصيات تلقائية حسب المعايير
  static List<String> getRecommendations(HomeModel home) {
    List<String> recommendations = [];
    double orientationScore = _getOrientationScore(home.direction);
    double areaScore = _getAreaScore(home.roofArea);
    double shadowScore = _getShadowScore(home.shadow);
    double consumptionScore = _getConsumptionScore(home.monthlyConsumption);
    double structuralScore = _getStructuralQualityScore(home.structuralQuality ?? 'متوسط');

    Map<String, double> scores = {
      'orientation': orientationScore,
      'area': areaScore,
      'shadow': shadowScore,
      'consumption': consumptionScore,
      'structural': structuralScore,
    };

    // ترتيب المعايير من الأضعف للأقوى
    var sortedEntries = scores.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // إعطاء توصيات للمعايير الأضعف
    for (var entry in sortedEntries) {
      if (entry.value < 60) {
        switch (entry.key) {
          case 'orientation':
            recommendations.add(
                'اتجاه السطح غير مثالي (${entry.value.toStringAsFixed(0)}%). يُنصح بفحص إمكانية توجيه الألواح الشمسية نحو الجنوب للحصول على أفضل أداء.');
            break;
          case 'area':
            recommendations.add(
                'مساحة السطح صغيرة (${entry.value.toStringAsFixed(0)}%). يُنصح بتوسيع المساحة المتاحة أو استخدام ألواح أكثر كفاءة.');
            break;
          case 'shadow':
            recommendations.add(
                'نسبة الظلال عالية (${entry.value.toStringAsFixed(0)}%). يُنصح بتركيب الألواح في مكان أقل ظلًّا أو رفع الميل، أو إزالة العوائق التي تسبب الظل.');
            break;
          case 'consumption':
            recommendations.add(
                'الاستهلاك الكهربائي منخفض نسبيًا (${entry.value.toStringAsFixed(0)}%). يُنصح بمراجعة احتياجات الطاقة المستقبلية قبل تركيب نظام كبير.');
            break;
          case 'structural':
            recommendations.add(
                'جودة السطح الإنشائية تحتاج تحسين (${entry.value.toStringAsFixed(0)}%). يُنصح بفحص وتهيئة السطح قبل تركيب الألواح الشمسية.');
            break;
        }
      }
    }

    if (recommendations.isEmpty) {
      recommendations.add('منزلك جاهز بشكل ممتاز لتركيب نظام الطاقة الشمسية!');
    }

    return recommendations;
  }

  // الحصول على درجات مفصلة لكل معيار
  static Map<String, double> getDetailedScores(HomeModel home) {
    return {
      'orientation': _getOrientationScore(home.direction),
      'area': _getAreaScore(home.roofArea),
      'shadow': _getShadowScore(home.shadow),
      'consumption': _getConsumptionScore(home.monthlyConsumption),
      'structural': _getStructuralQualityScore(home.structuralQuality ?? 'متوسط'),
    };
  }

  // الحصول على أسماء المعايير
  static Map<String, String> getScoreLabels() {
    return {
      'orientation': 'اتجاه السطح',
      'area': 'مساحة السطح',
      'shadow': 'نسبة الظلال',
      'consumption': 'الاستهلاك الكهربائي',
      'structural': 'جودة السطح',
    };
  }

  // الحصول على مستوى الجاهزية
  // ممتاز (80-100), جيد (65-79), يحتاج تحسين (40-64), غير مناسب (<40)
  static String getReadinessLevel(double score) {
    if (score >= 80) {
      return 'ممتاز';
    } else if (score >= 65) {
      return 'جيد';
    } else if (score >= 40) {
      return 'يحتاج تحسين';
    } else {
      return 'غير مناسب';
    }
  }

  // الحصول على لون مستوى الجاهزية
  static int getReadinessLevelColor(double score) {
    if (score >= 80) {
      return 0xFF00E676; // أخضر
    } else if (score >= 65) {
      return 0xFFFFC107; // أصفر
    } else if (score >= 40) {
      return 0xFFFF9800; // برتقالي
    } else {
      return 0xFFFF5252; // أحمر
    }
  }
}
