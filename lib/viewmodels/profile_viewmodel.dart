import 'package:flutter/material.dart';
import '../services/user_session_service.dart';
import '../services/visits_service.dart';
import '../services/api_service.dart';

class ProfileViewModel with ChangeNotifier {
  final UserSessionService _sessionService = UserSessionService();

  // Datos del perfil (estos vendrán eventualmente de la API)
  String _nivel = "Intermedio";
  int _puntajeObtenido = 0;
  int _puntajeTotal = 20;
  String _claseMasRecurrida = "Ninguna clase visitada aún";
  bool _isLoadingMostVisited = false;
  bool _isLoadingScore = false;

  String? _mlRecommendation;
  bool _isLoadingPrediction = false;
  Map<String, dynamic>? _mlPredictionData;

  bool _isLoadingMLData = false;

  // Getters
  String? get username => _sessionService.currentUsername;
  String? get userEmail => _sessionService.currentUserEmail;
  String get nivel => _nivel;
  int get puntajeObtenido => _puntajeObtenido;
  int get puntajeTotal => _puntajeTotal;
  String get claseMasRecurrida => _claseMasRecurrida;
  bool get isLoggedIn => _sessionService.isLoggedIn;
  bool get isLoadingMostVisited => _isLoadingMostVisited;
  bool get isLoadingScore => _isLoadingScore;
  bool get isLoadingMLData => _isLoadingMLData;

  String? get mlRecommendation => _mlRecommendation;
  bool get isLoadingPrediction => _isLoadingPrediction;
  Map<String, dynamic>? get mlPredictionData => _mlPredictionData;

  // Metodo para cargar datos del perfil
  Future<void> loadProfileData() async {
    if (!isLoggedIn) return;

    // Cargar la clase más visitada
    await _loadMostVisitedClass();

    // Cargar el mejor puntaje
    await loadBestScore();

    notifyListeners();
  }

  // Metodo privado para cargar la clase más visitada
  Future<void> _loadMostVisitedClass() async {
    if (!isLoggedIn || userEmail == null) return;

    _isLoadingMostVisited = true;
    notifyListeners();

    try {
      final mostVisitedId = await VisitsService.getMostVisitedClass(userEmail!);

      if (mostVisitedId != null) {
        // Mapear el ID a nombre legible
        _claseMasRecurrida = _getClassNameFromId(mostVisitedId);
      } else {
        _claseMasRecurrida = "Ninguna clase visitada aún";
      }
    } catch (e) {
      print('Error loading most visited class: $e');
      _claseMasRecurrida = "Error al cargar datos";
    } finally {
      _isLoadingMostVisited = false;
      notifyListeners();
    }
  }

  // Cargar el mejor puntaje del usuario
  Future<void> loadBestScore() async {
    if (!isLoggedIn || userEmail == null) return;

    _isLoadingScore = true;
    notifyListeners();

    try {
      final response = await ApiService.getBestScore(userEmail!);

      if (response['success']) {
        _puntajeObtenido = response['data']['puntaje_obtenido'] ?? 0;
        _puntajeTotal = response['data']['puntaje_total'] ?? 20;
        _nivel = response['data']['nivel'] ?? "Básico";
      }
    } catch (e) {
      print('Error loading best score: $e');
    } finally {
      _isLoadingScore = false;
      notifyListeners();
    }
  }

  Future<bool> updateBestScore(int correctAnswers, int totalQuestions) async {
    if (!isLoggedIn || userEmail == null) return false;

    try {
      // Calcular nivel básico como fallback
      final percentage = (correctAnswers / totalQuestions * 100).round();
      String fallbackLevel = _calculateLevel(percentage);

      // Actualizar puntaje - el backend ya incluye ML automáticamente
      final response = await ApiService.updateBestScore(
          userEmail!,
          correctAnswers,
          totalQuestions,
          fallbackLevel
      );

      if (response['success']) {
        final isNewBest = response['data']?['is_new_best'] ?? false;
        final mlEnhanced = response['data']?['ml_enhanced'] ?? false;

        if (isNewBest || response['data']?['is_new_best'] == null) {
          _puntajeObtenido = correctAnswers;
          _puntajeTotal = totalQuestions;
          _nivel = response['data']?['nivel'] ?? fallbackLevel;

          // Refrescar predicción ML después de actualizar
          await refreshMLPrediction();

          notifyListeners();

          if (mlEnhanced) {
            print('Nivel mejorado por ML: ${_nivel}');
          }

          return true;
        }
      }
    } catch (e) {
      print('Error updating best score: $e');
    }

    return false;
  }

  // Metodo privado para calcular el nivel basado en porcentaje
  String _calculateLevel(int percentage) {
    if (percentage >= 90) return "Avanzado";
    if (percentage >= 70) return "Intermedio";
    return "Básico";
  }

  Future<void> refreshMLPrediction() async {
    if (!isLoggedIn || userEmail == null) return;

    _isLoadingPrediction = true;
    notifyListeners();

    try {
      final response = await ApiService.predictUserEnglishLevel(userEmail!);

      if (response['success']) {
        _mlPredictionData = response['data'];

        // Verificar si la predicción es mejor que el nivel actual
        if (response['data']['es_prediccion_mejor'] == true) {
          // Mostrar notificación de mejora
          print('¡Predicción ML indica mejora de nivel!');
        }
      } else {
        print('Error en predicción ML: ${response['message']}');
      }
    } catch (e) {
      print('Error refreshing ML prediction: $e');
    } finally {
      _isLoadingPrediction = false;
      notifyListeners();
    }
  }

// Obtener recomendaciones personalizadas
  Future<void> loadUserRecommendations() async {
    if (!isLoggedIn || userEmail == null) return;

    try {
      final response = await ApiService.getUserModelStats(userEmail!);

      if (response['success']) {
        _mlRecommendation = response['data']['recomendacion'];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading recommendations: $e');
    }
  }

  // Metodo auxiliar para mapear IDs a nombres legibles
  String _getClassNameFromId(String classId) {
    switch (classId) {
      case 'verb_to_be':
        return 'Verb to be';
      case 'future_perfect':
        return 'Future Perfect';
      case 'present_simple':
        return 'Present Simple';
      case 'verb_can':
        return 'The Verb Can';
      default:
        return 'Clase desconocida';
    }
  }

  // Metodo para actualizar datos del perfil
  void updateProfileData({
    String? nivel,
    int? puntajeObtenido,
    int? puntajeTotal,
    String? claseMasRecurrida,
  }) {
    if (nivel != null) _nivel = nivel;
    if (puntajeObtenido != null) _puntajeObtenido = puntajeObtenido;
    if (puntajeTotal != null) _puntajeTotal = puntajeTotal;
    if (claseMasRecurrida != null) _claseMasRecurrida = claseMasRecurrida;

    notifyListeners();
  }

  Future<void> loadCompleteMLAnalysis() async {
    if (!isLoggedIn || userEmail == null) return;

    _isLoadingMLData = true;
    notifyListeners();

    try {
      await Future.wait([
        refreshMLPrediction(),
        loadUserRecommendations(),
      ]);
    } catch (e) {
      print('Error loading complete ML analysis: $e');
    } finally {
      _isLoadingMLData = false;
      notifyListeners();
    }
  }

  // Metodo para cerrar sesión
  void logout() {
    _sessionService.logout();
    notifyListeners();
  }
}