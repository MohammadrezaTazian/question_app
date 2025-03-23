class Year {
  final String id;
  final String year;
  final String description;

  Year({
    required this.id,
    required this.year,
    required this.description,
  });

  factory Year.fromJson(Map<String, dynamic> json) {
    return Year(
      id: json['id'],
      year: json['year'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'description': description,
    };
  }
}