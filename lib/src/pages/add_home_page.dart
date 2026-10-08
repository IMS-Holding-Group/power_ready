import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/home_model.dart';
import '../services/db_helper.dart';
import '../services/analysis_service.dart';
import '../widgets/input_row.dart';

class AddHomePage extends StatefulWidget {
  const AddHomePage({super.key});

  @override
  State<AddHomePage> createState() => _AddHomePageState();
}

class _AddHomePageState extends State<AddHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _roofAreaController = TextEditingController();
  final _monthlyConsumptionController = TextEditingController();

  String _selectedDirection = 'جنوب';
  String _selectedShadow = 'none';
  String _selectedStructuralQuality = 'متوسط';

  final List<String> _directions = [
    'جنوب',
    'جنوب شرق',
    'شرق',
    'شمال شرق',
    'شمال',
    'شمال غرب',
    'غرب',
    'جنوب غرب',
  ];

  final Map<String, String> _shadowOptions = {
    'none': 'لا يوجد',
    'light': 'خفيف',
    'moderate': 'متوسط',
    'heavy': 'كثيف',
  };

  final List<String> _structuralQualityOptions = [
    'ممتاز',
    'جيد',
    'متوسط',
    'ضعيف',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _roofAreaController.dispose();
    _monthlyConsumptionController.dispose();
    super.dispose();
  }

  Future<void> _saveHome() async {
    if (_formKey.currentState!.validate()) {
      final home = HomeModel(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        roofArea: double.parse(_roofAreaController.text),
        direction: _selectedDirection,
        shadow: _selectedShadow,
        monthlyConsumption: double.parse(_monthlyConsumptionController.text),
        structuralQuality: _selectedStructuralQuality,
      );

      final score = AnalysisService.calculateReadinessScore(home);
      final homeWithScore = home.copyWith(readinessScore: score);

      await DbHelper.instance.insertHome(homeWithScore);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ المنزل بنجاح'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منزل جديد'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InputRow(
              label: 'اسم المنزل',
              isRequired: true,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'أدخل اسم المنزل',
                ),
                textDirection: TextDirection.rtl,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال اسم المنزل';
                  }
                  return null;
                },
              ),
            ),
            InputRow(
              label: 'الموقع',
              isRequired: true,
              child: TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'أدخل الموقع أو الإحداثيات',
                ),
                textDirection: TextDirection.rtl,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال الموقع';
                  }
                  return null;
                },
              ),
            ),
            InputRow(
              label: 'نوع السقف',
              isRequired: true,
              child: DropdownButtonFormField<String>(
                value: 'Flat',
                decoration: const InputDecoration(
                  hintText: 'اختر نوع السقف',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Flat',
                    child: Text('Flat'),
                  ),
                  DropdownMenuItem(
                    value: 'مائل',
                    child: Text('مائل'),
                  ),
                ],
                onChanged: (value) {},
              ),
            ),
            InputRow(
              label: 'مساحة السطح (متر مربع)',
              isRequired: true,
              child: TextFormField(
                controller: _roofAreaController,
                decoration: const InputDecoration(
                  hintText: 'أدخل مساحة السطح',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                textDirection: TextDirection.ltr,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال مساحة السطح';
                  }
                  final area = double.tryParse(value);
                  if (area == null || area <= 0) {
                    return 'الرجاء إدخال قيمة صحيحة';
                  }
                  return null;
                },
              ),
            ),
            InputRow(
              label: 'اتجاه السطح',
              isRequired: true,
              child: DropdownButtonFormField<String>(
                value: _selectedDirection,
                decoration: const InputDecoration(
                  hintText: 'اختر اتجاه السطح',
                ),
                items: _directions.map((direction) {
                  return DropdownMenuItem(
                    value: direction,
                    child: Text(direction),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDirection = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء اختيار اتجاه السطح';
                  }
                  return null;
                },
              ),
            ),
            InputRow(
              label: 'الظل',
              isRequired: true,
              child: DropdownButtonFormField<String>(
                value: _selectedShadow,
                decoration: const InputDecoration(
                  hintText: 'اختر نسبة الظل',
                ),
                items: _shadowOptions.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedShadow = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء اختيار نسبة الظل';
                  }
                  return null;
                },
              ),
            ),
            InputRow(
              label: 'جودة السطح الإنشائية',
              isRequired: true,
              child: DropdownButtonFormField<String>(
                value: _selectedStructuralQuality,
                decoration: const InputDecoration(
                  hintText: 'اختر جودة السطح',
                ),
                items: _structuralQualityOptions.map((quality) {
                  return DropdownMenuItem(
                    value: quality,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStructuralQuality = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء اختيار جودة السطح';
                  }
                  return null;
                },
              ),
            ),
            InputRow(
              label: 'الاستهلاك الكهربائي الشهري (kWh)',
              isRequired: true,
              child: TextFormField(
                controller: _monthlyConsumptionController,
                decoration: const InputDecoration(
                  hintText: 'أدخل الاستهلاك الشهري',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                textDirection: TextDirection.ltr,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال الاستهلاك الشهري';
                  }
                  final consumption = double.tryParse(value);
                  if (consumption == null || consumption <= 0) {
                    return 'الرجاء إدخال قيمة صحيحة';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveHome,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'حفظ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

