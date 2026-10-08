import '../models/home_model.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';

/// واجهة عامة للتخزين - تعمل على جميع المنصات
abstract class StorageInterface {
  Future<void> init();

  // Homes operations
  Future<int> insertHome(HomeModel home);
  Future<List<HomeModel>> getHomes();
  Future<HomeModel?> getHomeById(int id);
  Future<int> updateHome(HomeModel home);
  Future<int> deleteHome(int id);

  // Requests operations
  Future<int> insertRequest(RequestModel request);
  Future<List<RequestModel>> getRequests();

  // User operations
  Future<UserModel?> getUser();
  Future<int> updateUser(UserModel user);

  Future<void> close();
}
