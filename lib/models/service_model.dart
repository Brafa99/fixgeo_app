class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.examples,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: json['category'] as String,
      examples: List<String>.from(json['examples'] as List? ?? const []),
      isActive: json['is_active'] as bool,
    );
  }

  final String id;
  final String name;
  final String description;
  final String icon;
  final String category;
  final List<String> examples;
  final bool isActive;

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? category,
    List<String>? examples,
    bool? isActive,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      examples: List.unmodifiable(examples ?? this.examples),
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category,
      'examples': examples,
      'is_active': isActive,
    };
  }
}
