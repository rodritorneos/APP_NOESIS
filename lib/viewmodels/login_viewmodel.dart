import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../services/user_session_service.dart';

class LoginViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final UserSessionService _sessionService = UserSessionService();
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String email = '';
  String password = '';

  // Getter para el estado de carga
  bool get isLoading => _isLoading;

  // Metodo para obtener la lista de usuarios desde la API
  Future<void> fetchUsuarios() async {
    _usuarios = await _apiService.fetchUsuarios();
  }

  // Metodo para validar las credenciales de inicio de sesión
  Future<bool> validateLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      await fetchUsuarios();

      final user = _usuarios.firstWhere(
            (u) => u.email == email && u.password == password,
        orElse: () => Usuario(email: '', password: ''),
      );

      _isLoading = false;
      notifyListeners();

      if (user.email.isNotEmpty) {
        // Establecer el usuario logueado en el servicio de sesión
        _sessionService.setCurrentUser(user.email);
        debugPrint("Login correcto para: ${user.email}");
        debugPrint("Username: ${_sessionService.currentUsername}");
        return true;
      } else {
        debugPrint("Credenciales incorrectas");
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error en login: $e");
      return false;
    }
  }

  // Metodo para obtener el usuario actual
  String? getCurrentUsername() {
    return _sessionService.currentUsername;
  }

  // Metodo para cerrar sesión
  void logout() {
    _sessionService.logout();
    email = '';
    password = '';
    notifyListeners();
  }
}