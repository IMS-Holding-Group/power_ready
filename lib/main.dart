import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';
import 'src/services/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة SharedPreferences
  try {
    await SharedPreferences.getInstance();
  } catch (e) {
    // تجاهل الأخطاء في التهيئة
  }
  
  // تهيئة قاعدة البيانات (تعمل تلقائياً على الويب والموبايل)
  try {
    await DbHelper.instance.init();
  } catch (e) {
    // تجاهل الأخطاء في التهيئة
    print('خطأ في تهيئة قاعدة البيانات: $e');
  }
  
  runApp(const PowerReadyApp());
}
