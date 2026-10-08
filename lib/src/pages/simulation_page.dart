import 'package:flutter/material.dart';
import '../models/home_model.dart';
import '../services/simulation_service.dart';

class SimulationPage extends StatefulWidget {
  final HomeModel? home;

  const SimulationPage({super.key, this.home});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  int _panelCount = 10;
  double _panelArea = 1.6; // متر مربع
  double _panelAngle = 30.0; // درجة
  double _shadowPercentage = 10.0; // نسبة مئوية
  double? _monthlyConsumption;

  @override
  void initState() {
    super.initState();
    if (widget.home != null) {
      _monthlyConsumption = widget.home!.monthlyConsumption;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyProduction = SimulationService.calculateDailyProduction(
      panelCount: _panelCount,
      panelArea: _panelArea,
      panelAngle: _panelAngle,
      shadowPercentage: _shadowPercentage,
    );

    final monthlyProduction = SimulationService.calculateMonthlyProduction(
      panelCount: _panelCount,
      panelArea: _panelArea,
      panelAngle: _panelAngle,
      shadowPercentage: _shadowPercentage,
    );

    Map<String, double> comparison = {};
    if (_monthlyConsumption != null) {
      comparison = SimulationService.compareProductionVsConsumption(
        monthlyProduction: monthlyProduction,
        monthlyConsumption: _monthlyConsumption!,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('محاكاة الطاقة الشمسية'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإنتاج المتوقع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('يومي', '${dailyProduction.toStringAsFixed(1)}', 'kWh'),
                      _buildStatCard('شهري', '${monthlyProduction.toStringAsFixed(1)}', 'kWh'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات المحاكاة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('عدد الألواح: $_panelCount'),
                  Slider(
                    value: _panelCount.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: _panelCount.toString(),
                    onChanged: (value) {
                      setState(() {
                        _panelCount = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('مساحة اللوحة الواحدة: ${_panelArea.toStringAsFixed(1)} م²'),
                  Slider(
                    value: _panelArea,
                    min: 1.0,
                    max: 3.0,
                    divisions: 20,
                    label: '${_panelArea.toStringAsFixed(1)} م²',
                    onChanged: (value) {
                      setState(() {
                        _panelArea = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('زاوية الميل: ${_panelAngle.toStringAsFixed(0)}°'),
                  Slider(
                    value: _panelAngle,
                    min: 0,
                    max: 45,
                    divisions: 45,
                    label: '${_panelAngle.toStringAsFixed(0)}°',
                    onChanged: (value) {
                      setState(() {
                        _panelAngle = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('نسبة الظل: ${_shadowPercentage.toStringAsFixed(0)}%'),
                  Slider(
                    value: _shadowPercentage,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_shadowPercentage.toStringAsFixed(0)}%',
                    onChanged: (value) {
                      setState(() {
                        _shadowPercentage = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_monthlyConsumption != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المقارنة مع الاستهلاك الحالي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildComparisonBar(
                      'الاستهلاك',
                      _monthlyConsumption!,
                      const Color(0xFFFF5252),
                    ),
                    const SizedBox(height: 8),
                    _buildComparisonBar(
                      'الإنتاج',
                      monthlyProduction,
                      const Color(0xFF00E676),
                    ),
                    const SizedBox(height: 16),
                    if (comparison.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'نسبة التغطية',
                            '${comparison['coverage']!.toStringAsFixed(1)}',
                            '%',
                          ),
                          _buildStatCard(
                            'التوفير',
                            '${SimulationService.estimateMonthlySavings(monthlyProduction, _monthlyConsumption!).toStringAsFixed(0)}',
                            'ريال',
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFB0B0B0),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00E676),
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB0B0B0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonBar(String label, double value, Color color) {
    double maxValue = _monthlyConsumption != null
        ? (_monthlyConsumption! > value ? _monthlyConsumption! : value)
        : value;
    double percentage = (value / maxValue) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '${value.toStringAsFixed(1)} kWh',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: const Color(0xFF2C2C2C),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 24,
          ),
        ),
      ],
    );
  }
}

