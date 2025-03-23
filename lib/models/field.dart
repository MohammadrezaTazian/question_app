class Field {
  final String id;
  final String field;
  final String description;

  Field({
    required this.id,
    required this.field,
    required this.description,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] ?? '',
      field: json['field'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field': field,
      'description': description,
    };
  }
}