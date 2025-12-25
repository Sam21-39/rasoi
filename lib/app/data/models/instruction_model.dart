/// Instruction Model
/// Represents a single step in recipe instructions
class InstructionModel {
  final int stepNumber;
  final String description;
  final String? imageUrl;

  const InstructionModel({required this.stepNumber, required this.description, this.imageUrl});

  /// Create from JSON
  factory InstructionModel.fromJson(Map<String, dynamic> json) {
    return InstructionModel(
      stepNumber: json['stepNumber'] ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  /// Create a copy with updated fields
  InstructionModel copyWith({int? stepNumber, String? description, String? imageUrl}) {
    return InstructionModel(
      stepNumber: stepNumber ?? this.stepNumber,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Check if instruction has an image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if instruction is valid
  bool get isValid => description.isNotEmpty;

  @override
  String toString() => 'Step $stepNumber: $description';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstructionModel &&
        other.stepNumber == stepNumber &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => Object.hash(stepNumber, description, imageUrl);
}
