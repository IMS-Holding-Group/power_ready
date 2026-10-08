class RequestModel {
  final int? id;
  final String name;
  final String city;
  final String phone;
  final String? createdAt;

  RequestModel({
    this.id,
    required this.name,
    required this.city,
    required this.phone,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'phone': phone,
      'created_at': createdAt,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      city: map['city'] as String,
      phone: map['phone'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel.fromMap(json);
  }
}

