import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'storage_interface.dart';
import '../models/home_model.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';

/// تنفيذ التخزين للويب باستخدام SharedPreferences
class DbHelperWeb implements StorageInterface {
  static final DbHelperWeb instance = DbHelperWeb._init();
  SharedPreferences? _prefs;

  DbHelperWeb._init();

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _storage async {
    await init();
    return _prefs!;
  }

  // Homes operations
  @override
  Future<int> insertHome(HomeModel home) async {
    final prefs = await _storage;
    final homes = await getHomes();
    final now = DateTime.now().toIso8601String();
    final newId = homes.isEmpty ? 1 : (homes.map((h) => h.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final homeWithId = home.copyWith(id: newId, createdAt: now);
    homes.add(homeWithId);
    await prefs.setString('homes', jsonEncode(homes.map((h) => h.toMap()).toList()));
    return newId;
  }

  @override
  Future<List<HomeModel>> getHomes() async {
    final prefs = await _storage;
    final homesJson = prefs.getString('homes');
    if (homesJson == null) return [];
    final List<dynamic> homesList = jsonDecode(homesJson);
    return homesList.map((map) => HomeModel.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  @override
  Future<HomeModel?> getHomeById(int id) async {
    final homes = await getHomes();
    try {
      return homes.firstWhere((home) => home.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> updateHome(HomeModel home) async {
    final prefs = await _storage;
    final homes = await getHomes();
    final index = homes.indexWhere((h) => h.id == home.id);
    if (index != -1) {
      homes[index] = home;
      await prefs.setString('homes', jsonEncode(homes.map((h) => h.toMap()).toList()));
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteHome(int id) async {
    final prefs = await _storage;
    final homes = await getHomes();
    homes.removeWhere((home) => home.id == id);
    await prefs.setString('homes', jsonEncode(homes.map((h) => h.toMap()).toList()));
    return 1;
  }

  // Requests operations
  @override
  Future<int> insertRequest(RequestModel request) async {
    final prefs = await _storage;
    final requests = await getRequests();
    final now = DateTime.now().toIso8601String();
    final newId = requests.isEmpty ? 1 : (requests.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final requestWithId = RequestModel(
      id: newId,
      name: request.name,
      city: request.city,
      phone: request.phone,
      createdAt: now,
    );
    requests.add(requestWithId);
    await prefs.setString('requests', jsonEncode(requests.map((r) => r.toMap()).toList()));
    return newId;
  }

  @override
  Future<List<RequestModel>> getRequests() async {
    final prefs = await _storage;
    final requestsJson = prefs.getString('requests');
    if (requestsJson == null) return [];
    final List<dynamic> requestsList = jsonDecode(requestsJson);
    return requestsList.map((map) => RequestModel.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  // User operations
  @override
  Future<UserModel?> getUser() async {
    final prefs = await _storage;
    final userJson = prefs.getString('user');
    if (userJson == null) {
      // إنشاء مستخدم افتراضي
      final defaultUser = UserModel(
        id: 1,
        name: 'مستخدم PowerReady',
        city: '',
        phone: '',
        email: '',
        createdAt: DateTime.now().toIso8601String(),
      );
      await prefs.setString('user', jsonEncode(defaultUser.toMap()));
      return defaultUser;
    }
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel.fromMap(userMap);
  }

  @override
  Future<int> updateUser(UserModel user) async {
    final prefs = await _storage;
    final existingUser = await getUser();
    final userToSave = user.copyWith(
      id: existingUser?.id ?? 1,
      createdAt: existingUser?.createdAt ?? DateTime.now().toIso8601String(),
    );
    await prefs.setString('user', jsonEncode(userToSave.toMap()));
    return 1;
  }

  @override
  Future<void> close() async {
    // لا حاجة لإغلاق SharedPreferences
  }
}

/// دالة للحصول على مثيل التخزين للويب
StorageInterface getStorageInstance() => DbHelperWeb.instance;

