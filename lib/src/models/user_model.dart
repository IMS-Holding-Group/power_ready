class UserModel {
  final int? id;
  final String name;
  final String city;
  final String phone;
  final String? email;
  final String? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.city,
    required this.phone,
    this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'phone': phone,
      'email': email,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      city: map['city'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? city,
    String? phone,
    String? email,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
