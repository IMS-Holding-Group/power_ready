// This file is used for conditional imports
// It exports the appropriate implementation based on the platform
import 'storage_interface.dart';

// استيراد شرطي - للويب يستخدم db_helper_web، للموبايل يستخدم db_helper_mobile
// يتم استيراد دالة getStorageInstance() من الملف المناسب تلقائياً
import 'db_helper_mobile.dart' 
  if (dart.library.html) 'db_helper_web.dart';

/// دالة للحصول على التنفيذ الصحيح حسب المنصة
/// يتم استبدالها تلقائياً بالتنفيذ الصحيح حسب المنصة
StorageInterface getPlatformStorage() => getStorageInstance();

