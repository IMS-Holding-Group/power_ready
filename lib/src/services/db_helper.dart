import 'storage_interface.dart';
import '../models/home_model.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';

// استيراد شرطي - للويب يستخدم db_helper_web، للموبايل يستخدم db_helper_mobile
import 'db_helper_stub.dart';

/// واجهة موحدة للوصول إلى قاعدة البيانات
/// تعمل تلقائياً على الويب والموبايل
class DbHelper {
  static final DbHelper instance = DbHelper._init();
  StorageInterface? _storage;

  DbHelper._init();

  StorageInterface get storage {
    _storage ??= getPlatformStorage();
    return _storage!;
  }

  Future<void> init() async {
    await storage.init();
  }

  Future<int> insertHome(HomeModel home) => storage.insertHome(home);
  Future<List<HomeModel>> getHomes() => storage.getHomes();
  Future<HomeModel?> getHomeById(int id) => storage.getHomeById(id);
  Future<int> updateHome(HomeModel home) => storage.updateHome(home);
  Future<int> deleteHome(int id) => storage.deleteHome(id);
  
  Future<int> insertRequest(RequestModel request) => storage.insertRequest(request);
  Future<List<RequestModel>> getRequests() => storage.getRequests();
  
  Future<UserModel?> getUser() => storage.getUser();
  Future<int> updateUser(UserModel user) => storage.updateUser(user);
  
  Future<void> close() => storage.close();
}
