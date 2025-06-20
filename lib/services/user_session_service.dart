class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();
  factory UserSessionService() => _instance;
  UserSessionService._internal();

  String? _currentUserEmail;
  String? _currentUsername;

  // Getters
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _currentUserEmail != null;

  // Obtener el email del usuario actual
  static Future<String?> getCurrentUserEmail() async {
    return _instance._currentUserEmail;
  }

  // Obtener el username del usuario actual
  static Future<String?> getCurrentUsername() async {
    return _instance._currentUsername;
  }

  // Verificar si hay un usuario logueado
  static Future<bool> isUserLoggedIn() async {
    return _instance._currentUserEmail != null;
  }

  // Establecer el usuario logueado
  void setCurrentUser(String email) {
    _currentUserEmail = email;
    _currentUsername = _extractUsernameFromEmail(email);
  }

  // Metodo para cerrar sesión
  void logout() {
    _currentUserEmail = null;
    _currentUsername = null;
  }

  // Metodo estático para cerrar sesión
  static Future<void> logoutUser() async {
    _instance.logout();
  }

  // Extraer el username del email (parte antes del @)
  String _extractUsernameFromEmail(String email) {
    return email.split('@')[0];
  }
}