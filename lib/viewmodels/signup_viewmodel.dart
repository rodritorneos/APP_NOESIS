import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String email = '';
  String password = '';

  // Getter para el estado de carga
  bool get isLoading => _isLoading;

  // Registrar un nuevo usuario usando la API
  Future<Map<String, dynamic>> registrarUsuario() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.registrarUsuario(email, password);

      _isLoading = false;
      notifyListeners();

      debugPrint("Usuario registrado exitosamente");
      return {
        'success': true,
        'message': 'Usuario registrado exitosamente'
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      debugPrint("Error al registrar: $e");
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', '')
      };
    }
  }
}