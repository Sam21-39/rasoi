/// Ingredient Model
/// Represents a single ingredient in a recipe
class IngredientModel {
  final String name;
  final String quantity;
  final String unit;

  const IngredientModel({required this.name, required this.quantity, required this.unit});

  /// Create from JSON
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'unit': unit};
  }

  /// Create a copy with updated fields
  IngredientModel copyWith({String? name, String? quantity, String? unit}) {
    return IngredientModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  /// Get formatted display string
  String get displayText {
    if (quantity.isEmpty && unit.isEmpty) {
      return name;
    } else if (unit.isEmpty) {
      return '$quantity $name';
    } else {
      return '$quantity $unit $name';
    }
  }

  /// Check if ingredient is valid
  bool get isValid => name.isNotEmpty;

  @override
  String toString() => displayText;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngredientModel &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit;
  }

  @override
  int get hashCode => Object.hash(name, quantity, unit);
}
