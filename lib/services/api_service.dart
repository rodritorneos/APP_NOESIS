import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  Future<List<Usuario>> fetchUsuarios() async {
    final response = await http.get(Uri.parse('https://backend-noesis.onrender.com/usuarios'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  // Registrar un nuevo usuario en el sistema
  Future<bool> registrarUsuario(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://backend-noesis.onrender.com/usuarios/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      // Email ya existe
      throw Exception('El email ya está registrado');
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  // Obtener el mejor puntaje de un usuario específico
  static Future<Map<String, dynamic>> getBestScore(String email) async {
    try {
      final response = await http.get(
        Uri.parse('https://backend-noesis.onrender.com/usuarios/$email/puntajes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener puntajes'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Actualizar el mejor puntaje del usuario
  static Future<Map<String, dynamic>> updateBestScore(
      String email,
      int puntajeObtenido,
      int puntajeTotal,
      String nivel
      ) async {
    try {
      final response = await http.post(
        Uri.parse('https://backend-noesis.onrender.com/usuarios/$email/puntajes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'puntaje_obtenido': puntajeObtenido,
          'puntaje_total': puntajeTotal,
          'nivel': nivel,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Asegura que los datos devueltos sean un Map válido
        final responseData = data is Map<String, dynamic> ? data : <String, dynamic>{};

        // Establece valor por defecto si no viene en la respuesta
        responseData['is_new_best'] ??= true; // Default to true if not specified

        return {
          'success': true,
          'data': responseData
        };
      } else {
        return {
          'success': false,
          'message': 'Error al actualizar puntaje'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }
  // Predecir nivel de inglés usando ML
  static Future<Map<String, dynamic>> predictEnglishLevel(
      int puntajeObtenido,
      int puntajeTotal
      ) async {
    try {
      final response = await http.post(
        Uri.parse('https://backend-noesis.onrender.com/modelo/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'puntaje_obtenido': puntajeObtenido,
          'puntaje_total': puntajeTotal,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error en la predicción del modelo'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> predictUserEnglishLevel(String email) async {
    try {
      final response = await http.get(
        Uri.parse('https://backend-noesis.onrender.com/usuarios/$email/puntajes/modelo/predict'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error en la predicción del modelo para el usuario'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }

// Obtener estadísticas del modelo para el usuario
  static Future<Map<String, dynamic>> getUserModelStats(String email) async {
    try {
      final response = await http.get(
        Uri.parse('https://backend-noesis.onrender.com/usuarios/$email/puntajes/modelo/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'message': 'Error obteniendo estadísticas del usuario'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
  }
}