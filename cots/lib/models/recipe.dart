class Recipe {
  final int? id;
  final String title;
  final String category;
  final String ingredients;
  final String steps;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Recipe({
    this.id,
    required this.title,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      note: json['note'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'ingredients': ingredients,
      'steps': steps,
      'note': note,
    };
  }

  String getEmoji() {
    switch (category) {
      case 'Sarapan':
        return '🍳';
      case 'Makan Siang':
        return '🍜';
      case 'Makan Malam':
        return '🍗';
      case 'Dessert':
        return '🍮';
      default:
        return '🍽️';
    }
  }

  int getEstimatedTime() {
    // Estimasi waktu berdasarkan jumlah steps
    int stepCount = steps.split(',').length;
    return stepCount * 15; // 15 menit per step
  }
}