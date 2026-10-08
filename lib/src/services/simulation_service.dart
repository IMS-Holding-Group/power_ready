class SimulationService {
  // حساب الإنتاج اليومي للطاقة (kWh/day)
  // المعادلة: الإنتاج = (عدد الألواح × مساحة اللوحة × كفاءة اللوحة × ساعات الشمس × عامل الإشعاع × عامل الزاوية × (1 - نسبة الظل))
  // 
  // المعاملات:
  // - كفاءة اللوحة النموذجية: 0.20 (20%)
  // - ساعات الشمس النموذجية: 5.5 ساعة
  // - عامل الإشعاع: 1000 واط/م² (متوسط في السعودية)
  // - عامل الزاوية: يعتمد على زاوية الميل (0-45 درجة)
  static double calculateDailyProduction({
    required int panelCount,
    required double panelArea,
    required double panelAngle,
    required double shadowPercentage,
  }) {
    // كفاءة اللوحة الشمسية (20%)
    const double panelEfficiency = 0.20;
    
    // ساعات الشمس المتوسطة في السعودية
    const double sunHours = 5.5;
    
    // الإشعاع الشمسي (1000 واط/م²)
    const double solarIrradiance = 1000.0;
    
    // عامل الزاوية: أفضل زاوية هي 30 درجة تقريباً
    // المعادلة: cos(|angle - optimal_angle|) حيث optimal_angle = 30
    double optimalAngle = 30.0;
    double angleRad = (panelAngle - optimalAngle).abs() * (3.14159 / 180.0);
    double angleFactor = 1.0 - (angleRad * 0.3); // تقريب بسيط
    if (angleFactor < 0.5) angleFactor = 0.5; // الحد الأدنى
    
    // عامل الظل (0-1)
    double shadowFactor = 1.0 - (shadowPercentage / 100.0);
    if (shadowFactor < 0.1) shadowFactor = 0.1; // الحد الأدنى
    
    // الحساب: kWh/day = (panels × area × efficiency × sunHours × irradiance × angleFactor × shadowFactor) / 1000
    double dailyProduction = (panelCount *
            panelArea *
            panelEfficiency *
            sunHours *
            (solarIrradiance / 1000.0) *
            angleFactor *
            shadowFactor);
    
    return dailyProduction;
  }

  // حساب الإنتاج الشهري (kWh/month)
  static double calculateMonthlyProduction({
    required int panelCount,
    required double panelArea,
    required double panelAngle,
    required double shadowPercentage,
  }) {
    double daily = calculateDailyProduction(
      panelCount: panelCount,
      panelArea: panelArea,
      panelAngle: panelAngle,
      shadowPercentage: shadowPercentage,
    );
    
    return daily * 30; // تقريب شهري
  }

  // مقارنة الإنتاج بالاستهلاك
  static Map<String, double> compareProductionVsConsumption({
    required double monthlyProduction,
    required double monthlyConsumption,
  }) {
    double coverage = (monthlyProduction / monthlyConsumption) * 100.0;
    if (coverage > 100.0) coverage = 100.0;
    
    double savings = monthlyProduction;
    if (savings > monthlyConsumption) {
      savings = monthlyConsumption;
    }
    
    double excess = 0.0;
    if (monthlyProduction > monthlyConsumption) {
      excess = monthlyProduction - monthlyConsumption;
    }
    
    return {
      'coverage': coverage, // نسبة التغطية %
      'savings': savings, // التوفير المتوقع (kWh)
      'excess': excess, // الفائض (kWh)
    };
  }

  // تقدير التكلفة الشهرية (ريال)
  // سعر الكهرباء في السعودية: حوالي 0.18 ريال/kWh للمنازل
  static double estimateMonthlySavings(double monthlyProduction, double monthlyConsumption) {
    const double electricityPrice = 0.18; // ريال/kWh
    double savings = monthlyProduction;
    if (savings > monthlyConsumption) {
      savings = monthlyConsumption;
    }
    return savings * electricityPrice;
  }
}

