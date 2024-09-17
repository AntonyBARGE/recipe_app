class RecipeCategory {
  final int? id;
  final String name;

  RecipeCategory({
    this.id,
    required this.name,
  });

  RecipeCategory copyWith({
    int? id,
    String? name,
  }) {
    return RecipeCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static RecipeCategory fromMap(Map<String, dynamic> map) {
    return RecipeCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}
