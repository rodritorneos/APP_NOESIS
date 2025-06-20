import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson.dart';

class FavoritesService {
  static const String baseUrl = 'https://backend-noesis.onrender.com';

  // Obtener favoritos del usuario
  static Future<List<Lesson>> getFavorites(String userEmail) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$userEmail/favoritos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> favoritosJson = data['favoritos'];

        return favoritosJson.map((json) => Lesson.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener favoritos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getFavorites: $e');
      return [];
    }
  }

  // Agregar a favoritos
  static Future<bool> addToFavorites(String userEmail, Lesson lesson) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/$userEmail/favoritos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'clase_id': lesson.id,
          'nombre_clase': lesson.name,
          'imagen_path': lesson.imagePath,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error en addToFavorites: $e');
      return false;
    }
  }

  // Remover de favoritos
  static Future<bool> removeFromFavorites(String userEmail, String lessonId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/usuarios/$userEmail/favoritos/$lessonId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error en removeFromFavorites: $e');
      return false;
    }
  }

  // Verificar si una lección está en favoritos
  static Future<bool> isFavorite(String userEmail, String lessonId) async {
    try {
      final favorites = await getFavorites(userEmail);
      return favorites.any((lesson) => lesson.id == lessonId);
    } catch (e) {
      print('Error en isFavorite: $e');
      return false;
    }
  }
}