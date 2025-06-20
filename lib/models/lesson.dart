class Lesson {
  final String id;
  final String name;
  final String imagePath;
  final String screenRoute;
  bool isFavorite;

  // Constructor para inicializar una lección
  Lesson({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.screenRoute,
    this.isFavorite = false,
  });

  // Metodo factory para crear una lección a partir de un JSON
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['clase_id'] ?? json['id'],
      name: json['nombre_clase'] ?? json['name'],
      imagePath: json['imagen_path'] ?? json['imagePath'],
      screenRoute: json['screenRoute'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'clase_id': id,
      'nombre_clase': name,
      'imagen_path': imagePath,
      'screenRoute': screenRoute,
      'isFavorite': isFavorite,
    };
  }

  // Metodo para crear una copia con cambios
  Lesson copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? screenRoute,
    bool? isFavorite,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      screenRoute: screenRoute ?? this.screenRoute,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}