class HomeModel {
  final int? id;
  final String name;
  final String location;
  final double roofArea;
  final String direction;
  final String shadow;
  final double monthlyConsumption;
  final String? structuralQuality;
  final String? simulationData;
  final double? readinessScore;
  final String? createdAt;

  HomeModel({
    this.id,
    required this.name,
    required this.location,
    required this.roofArea,
    required this.direction,
    required this.shadow,
    required this.monthlyConsumption,
    this.structuralQuality,
    this.simulationData,
    this.readinessScore,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'roof_area': roofArea,
      'direction': direction,
      'shadow': shadow,
      'monthly_consumption': monthlyConsumption,
      'structural_quality': structuralQuality,
      'simulation_data': simulationData,
      'readiness_score': readinessScore,
      'created_at': createdAt,
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      location: map['location'] as String,
      roofArea: map['roof_area'] as double,
      direction: map['direction'] as String,
      shadow: map['shadow'] as String,
      monthlyConsumption: map['monthly_consumption'] as double,
      structuralQuality: map['structural_quality'] as String?,
      simulationData: map['simulation_data'] as String?,
      readinessScore: map['readiness_score'] as double?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel.fromMap(json);
  }

  HomeModel copyWith({
    int? id,
    String? name,
    String? location,
    double? roofArea,
    String? direction,
    String? shadow,
    double? monthlyConsumption,
    String? structuralQuality,
    String? simulationData,
    double? readinessScore,
    String? createdAt,
  }) {
    return HomeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      roofArea: roofArea ?? this.roofArea,
      direction: direction ?? this.direction,
      shadow: shadow ?? this.shadow,
      monthlyConsumption: monthlyConsumption ?? this.monthlyConsumption,
      structuralQuality: structuralQuality ?? this.structuralQuality,
      simulationData: simulationData ?? this.simulationData,
      readinessScore: readinessScore ?? this.readinessScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
