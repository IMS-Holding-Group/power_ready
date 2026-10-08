import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../services/db_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });

    final user = await DbHelper.instance.getUser();
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _cityController.text = user.city;
        _phoneController.text = user.phone;
        _emailController.text = user.email ?? '';
        _isLoading = false;
      });
    } else {
      // إنشاء مستخدم افتراضي إذا لم يوجد
      final defaultUser = UserModel(
        name: 'مستخدم PowerReady',
        city: '',
        phone: '',
        email: '',
      );
      await DbHelper.instance.updateUser(defaultUser);
      _loadUser();
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = _user!.copyWith(
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
      );

      await DbHelper.instance.updateUser(updatedUser);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التعديلات بنجاح'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
        setState(() {
          _isEditing = false;
        });
        _loadUser();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملفي'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              tooltip: 'تعديل',
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveUser,
              tooltip: 'حفظ',
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _loadUser();
                });
              },
              tooltip: 'إلغاء',
            ),
        ],
      ),
      body: _isEditing ? _buildEditForm() : _buildProfileView(),
    );
  }

  Widget _buildProfileView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E1E1E),
              border: Border.all(
                color: const Color(0xFF00E676),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF00E676),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('الاسم', _user?.name ?? ''),
              const Divider(height: 32),
              _buildInfoRow('المدينة', _user?.city ?? 'غير محدد'),
              const Divider(height: 32),
              _buildInfoRow('رقم الجوال', _user?.phone ?? 'غير محدد'),
              const Divider(height: 32),
              _buildInfoRow('البريد الإلكتروني', _user?.email ?? 'غير محدد'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E1E1E),
                border: Border.all(
                  color: const Color(0xFF00E676),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF00E676),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildGlassCard(
            child: Column(
              children: [
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني (اختياري)',
                    hintText: 'أدخل البريد الإلكتروني',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                ),
              ],
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

