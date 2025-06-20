import 'package:flutter/material.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'ResultsScreen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizViewModel viewModel = QuizViewModel();
  String? selectedAnswer;
  bool showFeedback = false;
  bool isCorrect = false;

  // Variables para el tiempo y puntuación
  late DateTime startTime;
  int correctAnswersCount = 0;
  List<bool> answerHistory = []; // Historial de respuestas para análisis

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  void _submitAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = viewModel.isAnswerCorrect(answer);
      showFeedback = true;

      // Contar respuestas correctas y guardar historial
      if (isCorrect) {
        correctAnswersCount++;
      }
      answerHistory.add(isCorrect);
    });

    Future.delayed(Duration(seconds: 2), () {
      if (!viewModel.isLastQuestion) {
        viewModel.nextQuestion();
        setState(() {
          selectedAnswer = null;
          showFeedback = false;
        });
      } else {
        // Quiz terminado - navegar a pantalla de resultados
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    final timeElapsed = _formatDuration(duration);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          correctAnswers: correctAnswersCount,
          totalQuestions: viewModel.questions.length,
          timeElapsed: timeElapsed,
          quizViewModel: viewModel,
          answerHistory: answerHistory,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // Metodo para calcular el porcentaje de progreso
  double get progressPercentage => (viewModel.currentIndex + 1) / viewModel.questions.length;

  // Método para obtener dimensiones responsivas
  double _getResponsiveWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      // Tablets
      return screenWidth * 0.7;
    } else if (screenWidth > 400) {
      // Móviles grandes
      return screenWidth * 0.9;
    } else {
      // Móviles pequeños
      return screenWidth * 0.95;
    }
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return baseFontSize * 1.2;
    } else if (screenWidth < 350) {
      return baseFontSize * 0.9;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 24.0;
    } else if (screenWidth < 350) {
      return 12.0;
    }
    return 16.0;
  }

  @override
  Widget build(BuildContext context) {
    final question = viewModel.currentQuestion;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final responsivePadding = _getResponsivePadding(context);
    final maxWidth = _getResponsiveWidth(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF353535),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/logo_noesis_game.png',
              height: screenWidth > 600 ? 50 : 40,
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _showExitConfirmation();
          },
        ),
      ),
      backgroundColor: Color(0xFF353535),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Barra de progreso
                Container(
                  padding: EdgeInsets.all(responsivePadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Pregunta ${viewModel.currentIndex + 1} de ${viewModel.questions.length}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: _getResponsiveFontSize(context, 16),
                                color: Color(0xFF9E9E9E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${(progressPercentage * 100).toInt()}%',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: _getResponsiveFontSize(context, 16),
                              color: Color(0xFF00BCD4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressPercentage,
                        backgroundColor: Color(0xFF4A4A4A),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),

                // Contenido principal con scroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: responsivePadding),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                          minHeight: constraints.maxHeight - 120,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),

                            // Título del juego
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Test Game ',
                                    style: TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontSize: _getResponsiveFontSize(context, 24),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                  '🎮',
                                  style: TextStyle(fontSize: _getResponsiveFontSize(context, 24)),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Estadísticas rápidas
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: responsivePadding,
                                  vertical: 8
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '$correctAnswersCount correctas',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: _getResponsiveFontSize(context, 14),
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30),

                            // Pregunta
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                question.question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: _getResponsiveFontSize(context, 20),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                            ),

                            SizedBox(height: 30),

                            // Opciones de respuesta
                            ...question.options.asMap().entries.map((entry) {
                              int index = entry.key;
                              String option = entry.value;
                              String prefix = String.fromCharCode(65 + index); // A, B, C, D

                              Color buttonColor;
                              Color borderColor = Colors.transparent;

                              if (showFeedback && selectedAnswer == option) {
                                buttonColor = isCorrect ? Colors.green : Colors.red;
                                borderColor = isCorrect ? Colors.green : Colors.red;
                              } else if (showFeedback && option == question.correctAnswer) {
                                // Mostrar la respuesta correcta si el user se equivoco
                                buttonColor = Colors.green;
                                borderColor = Colors.green;
                              } else {
                                buttonColor = Color(0xFF9E9E9E);
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: selectedAnswer == null && !showFeedback
                                        ? () => _submitAnswer(option)
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenWidth > 600 ? 20 : 16,
                                          horizontal: responsivePadding
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                          color: borderColor,
                                          width: 2,
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$prefix) ',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: _getResponsiveFontSize(context, 18),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: _getResponsiveFontSize(context, 18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1.2,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            SizedBox(height: 20),

                            // Feedback visual de respuestas
                            if (showFeedback)
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                padding: EdgeInsets.all(responsivePadding),
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isCorrect ? Colors.green : Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isCorrect ? Icons.check_circle : Icons.cancel,
                                      color: isCorrect ? Colors.green : Colors.red,
                                      size: _getResponsiveFontSize(context, 20),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        isCorrect ? '¡Correcto!' : '¡Incorrecto!',
                                        style: TextStyle(
                                          color: isCorrect ? Colors.green : Colors.red,
                                          fontSize: _getResponsiveFontSize(context, 16),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Nunito',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Confirmación antes de salir
  void _showExitConfirmation() {
    final responsivePadding = _getResponsivePadding(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '¿Salir del quiz?',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              fontSize: _getResponsiveFontSize(context, 18),
            ),
          ),
          content: Text(
            'Si sales ahora, perderás tu progreso actual.',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontFamily: 'Nunito',
              fontSize: _getResponsiveFontSize(context, 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar dialogo
              },
              child: Text(
                'Continuar',
                style: TextStyle(
                  color: Color(0xFF00BCD4),
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: _getResponsiveFontSize(context, 16),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar dialogo
                Navigator.of(context).pop(); // Salir del quiz
              },
              child: Text(
                'Salir',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: _getResponsiveFontSize(context, 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}