import 'dart:convert';
import 'package:http/http.dart' as http;

class VisitsService {
  static const String baseUrl = 'https://backend-noesis.onrender.com';

  // Registrar una visita a una clase
  static Future<bool> registerVisit(String userEmail, String claseId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/$userEmail/visitas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'clase_id': claseId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registering visit: $e');
      return false;
    }
  }

  // Obtener las visitas de un usuario
  static Future<Map<String, int>> getUserVisits(String userEmail) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/$userEmail/visitas'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, int> visits = {};

        for (var visit in data['visitas']) {
          visits[visit['clase_id']] = visit['count'];
        }

        return visits;
      }
      return {};
    } catch (e) {
      print('Error getting user visits: $e');
      return {};
    }
  }

  // Obtener la clase más visitada
  static Future<String?> getMostVisitedClass(String userEmail) async {
    try {
      final visits = await getUserVisits(userEmail);

      if (visits.isEmpty) return null;

      String mostVisited = visits.keys.first;
      int maxVisits = visits.values.first;

      visits.forEach((claseId, visitCount) {
        if (visitCount > maxVisits) {
          maxVisits = visitCount;
          mostVisited = claseId;
        }
      });

      return mostVisited;
    } catch (e) {
      print('Error getting most visited class: $e');
      return null;
    }
  }
}