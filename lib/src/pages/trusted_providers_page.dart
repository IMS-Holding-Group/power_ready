import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/request_model.dart';
import '../services/db_helper.dart';

class TrustedProvidersPage extends StatefulWidget {
  const TrustedProvidersPage({super.key});

  @override
  State<TrustedProvidersPage> createState() => _TrustedProvidersPageState();
}

class _TrustedProvidersPageState extends State<TrustedProvidersPage> {
  final List<Provider> _providers = [
    Provider(
      name: 'شركة الطاقة المتجددة السعودية',
      description: 'مزود رائد للطاقة الشمسية في المملكة العربية السعودية',
      location: 'الرياض',
    ),
    Provider(
      name: 'مؤسسة الطاقة النظيفة',
      description: 'حلول شاملة للطاقة الشمسية للمنازل والشركات',
      location: 'جدة',
    ),
    Provider(
      name: 'شركة الطاقة المستدامة',
      description: 'أنظمة الطاقة الشمسية عالية الجودة والكفاءة',
      location: 'الدمام',
    ),
    Provider(
      name: 'مؤسسة الطاقة الخضراء',
      description: 'خبرة واسعة في تركيب وصيانة أنظمة الطاقة الشمسية',
      location: 'المدينة المنورة',
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  Provider? _selectedProvider;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate() && _selectedProvider != null) {
      final request = RequestModel(
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      await DbHelper.instance.insertRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال طلب التواصل بنجاح'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
        _nameController.clear();
        _cityController.clear();
        _phoneController.clear();
        setState(() {
          _selectedProvider = null;
        });
      }
    } else if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار مزود خدمة'),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مصادر الطاقة المعتمدة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'اختر مزود خدمة للتواصل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._providers.map((provider) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: RadioListTile<Provider>(
                title: Text(
                  provider.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.description),
                    const SizedBox(height: 4),
                    Text(
                      'الموقع: ${provider.location}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
                value: provider,
                groupValue: _selectedProvider,
                onChanged: (value) {
                  setState(() {
                    _selectedProvider = value;
                  });
                },
                activeColor: const Color(0xFF00E676),
              ),
            );
          }),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'طلب تواصل',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم',
                        hintText: 'أدخل اسمك',
                      ),
                      textDirection: TextDirection.rtl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'المدينة',
                        hintText: 'أدخل مدينتك',
                      ),
                      textDirection: TextDirection.rtl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال المدينة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'رقم الجوال',
                        hintText: 'أدخل رقم الجوال',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textDirection: TextDirection.ltr,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال رقم الجوال';
                        }
                        if (value.length < 10) {
                          return 'الرجاء إدخال رقم صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitRequest,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'إرسال طلب التواصل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Provider {
  final String name;
  final String description;
  final String location;

  Provider({
    required this.name,
    required this.description,
    required this.location,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Provider &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

