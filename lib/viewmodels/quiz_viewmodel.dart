import '../models/quiz_question.dart';
import 'dart:math';

class QuizViewModel {
  int _currentIndex = 0;
  List<QuizQuestion> _selectedQuestions = [];

  // Banco completo de 40 preguntas
  final List<QuizQuestion> _allQuestions = [
    // Verb To Be (10 preguntas)
    QuizQuestion(
      question: "He ___ a doctor.",
      options: ["is", "are", "am", "be"],
      correctAnswer: "is",
    ),
    QuizQuestion(
      question: "They ___ my friends.",
      options: ["is", "am", "are", "be"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "My parents ___ always supportive of my decisions.",
      options: ["are", "is", "am", "be"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "The documents ___ supposed to be on the manager's desk this morning.",
      options: ["is", "was", "be", "are"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "I ___ not ready for the exam yet.",
      options: ["is", "are", "be", "am"],
      correctAnswer: "am",
    ),
    QuizQuestion(
      question: "The book ___ on the table.",
      options: ["are", "is", "were", "am"],
      correctAnswer: "is",
    ),
    QuizQuestion(
      question: "We ___ students at the university.",
      options: ["are", "is", "am", "was"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "She ___ very talented in music.",
      options: ["are", "am", "were", "is"],
      correctAnswer: "is",
    ),
    QuizQuestion(
      question: "You ___ welcome to join us anytime.",
      options: ["are", "is", "am", "was"],
      correctAnswer: "are",
    ),
    QuizQuestion(
      question: "It ___ a beautiful day today.",
      options: ["am", "are", "were", "is"],
      correctAnswer: "is",
    ),

    // Present Simple (10 preguntas)
    QuizQuestion(
      question: "She ___ every morning at 6 AM.",
      options: ["wake", "wakes", "waking", "woke"],
      correctAnswer: "wakes",
    ),
    QuizQuestion(
      question: "We ___ to the same school.",
      options: ["go", "goes", "going", "gone"],
      correctAnswer: "go",
    ),
    QuizQuestion(
      question: "He usually ___ his homework before dinner.",
      options: ["do", "did", "doing", "does"],
      correctAnswer: "does",
    ),
    QuizQuestion(
      question: "The train ___ every hour, so don't worry if you miss this one.",
      options: ["departs", "departed", "depart", "is departing"],
      correctAnswer: "departs",
    ),
    QuizQuestion(
      question: "My sister ___ English and French fluently.",
      options: ["speak", "speaking", "spoke", "speaks"],
      correctAnswer: "speaks",
    ),
    QuizQuestion(
      question: "They ___ coffee every morning.",
      options: ["drink", "drinks", "drinking", "drank"],
      correctAnswer: "drink",
    ),
    QuizQuestion(
      question: "The sun ___ in the east.",
      options: ["rise", "rising", "rises", "rose"],
      correctAnswer: "rises",
    ),
    QuizQuestion(
      question: "I ___ my teeth twice a day.",
      options: ["brush", "brushes", "brushing", "brushed"],
      correctAnswer: "brush",
    ),
    QuizQuestion(
      question: "She ___ to work by bus.",
      options: ["travel", "traveling", "traveled", "travels"],
      correctAnswer: "travels",
    ),
    QuizQuestion(
      question: "We ___ our grandparents every weekend.",
      options: ["visits", "visiting", "visited", "visit"],
      correctAnswer: "visit",
    ),

    // Future Perfect (10 preguntas)
    QuizQuestion(
      question: "By 8 PM, I ___ my homework.",
      options: ["will have finished", "will finished", "will be finished", "will finish"],
      correctAnswer: "will have finished",
    ),
    QuizQuestion(
      question: "She ___ dinner before we arrive.",
      options: ["has cooked", "will have cooked", "will cook", "cooks"],
      correctAnswer: "will have cooked",
    ),
    QuizQuestion(
      question: "By next semester, they ___ all the required courses.",
      options: ["complete", "will complete", "will have completed", "completed"],
      correctAnswer: "will have completed",
    ),
    QuizQuestion(
      question: "By 2030, scientists ___ a cure for many rare diseases.",
      options: ["will have found", "have found", "found", "find"],
      correctAnswer: "will have found",
    ),
    QuizQuestion(
      question: "By the time you get home, I ___ the report.",
      options: ["will finish", "finish", "finished", "will have finished"],
      correctAnswer: "will have finished",
    ),
    QuizQuestion(
      question: "They ___ the project by next Friday.",
      options: ["will complete", "complete", "will have completed", "completed"],
      correctAnswer: "will have completed",
    ),
    QuizQuestion(
      question: "By noon, she ___ for three hours.",
      options: ["will study", "studies", "will have studied", "studied"],
      correctAnswer: "will have studied",
    ),
    QuizQuestion(
      question: "We ___ all the books by the end of the month.",
      options: ["will have read", "will read", "read", "reads"],
      correctAnswer: "will have read",
    ),
    QuizQuestion(
      question: "By tomorrow, he ___ the entire presentation.",
      options: ["will prepare", "prepares", "prepared", "will have prepared"],
      correctAnswer: "will have prepared",
    ),
    QuizQuestion(
      question: "The team ___ the championship by next year.",
      options: ["will win", "wins", "will have won", "won"],
      correctAnswer: "will have won",
    ),

    // The Verb Can (10 preguntas)
    QuizQuestion(
      question: "I ___ ride a bike.",
      options: ["can", "am", "have", "do"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "He ___ play the piano.",
      options: ["will", "is", "can", "does"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "She ___ speak three languages fluently.",
      options: ["is", "does", "will", "can"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "Although he's young, he ___ analyze complex systems with ease.",
      options: ["may", "can", "is", "will"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "We ___ help you with your project.",
      options: ["will", "are", "do", "can"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "They ___ swim very well.",
      options: ["can", "are", "do", "will"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "You ___ borrow my car if you need it.",
      options: ["will", "are", "can", "do"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "My brother ___ cook delicious meals.",
      options: ["is", "does", "will", "can"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "She ___ solve difficult math problems quickly.",
      options: ["will", "can", "is", "does"],
      correctAnswer: "can",
    ),
    QuizQuestion(
      question: "We ___ meet tomorrow if you're available.",
      options: ["are", "do", "will", "can"],
      correctAnswer: "can",
    ),
  ];

  // Getters
  List<QuizQuestion> get questions => _selectedQuestions;
  int get currentIndex => _currentIndex;
  QuizQuestion get currentQuestion => _selectedQuestions[_currentIndex];
  bool get isLastQuestion => _currentIndex == _selectedQuestions.length - 1;

  // Constructor que inicializa con preguntas aleatorias
  QuizViewModel() {
    _selectRandomQuestions();
  }

  // Metodo para seleccionar 20 preguntas aleatorias del banco de 40
  void _selectRandomQuestions() {
    final random = Random();
    List<QuizQuestion> tempQuestions = List.from(_allQuestions);
    _selectedQuestions.clear();

    // Seleccionar 20 preguntas aleatorias
    for (int i = 0; i < 20; i++) {
      int randomIndex = random.nextInt(tempQuestions.length);
      _selectedQuestions.add(tempQuestions[randomIndex]);
      tempQuestions.removeAt(randomIndex); // Evitar duplicados
    }
  }

  void nextQuestion() {
    if (_currentIndex < _selectedQuestions.length - 1) {
      _currentIndex++;
    }
  }

  bool isAnswerCorrect(String answer) {
    return answer == currentQuestion.correctAnswer;
  }

  void reset() {
    _currentIndex = 0;
    _selectRandomQuestions(); // Seleccionar nuevas preguntas aleatorias al reiniciar
  }

  // Metodo para obtener estadísticas del banco de preguntas
  Map<String, int> getQuestionStats() {
    int verbToBe = 0;
    int presentSimple = 0;
    int futurePerfect = 0;
    int verbCan = 0;

    // Contar preguntas por categoría en las preguntas seleccionadas
    for (var question in _selectedQuestions) {
      String questionText = question.question.toLowerCase();
      if (questionText.contains('___') &&
          (question.options.contains('is') || question.options.contains('are') || question.options.contains('am'))) {
        verbToBe++;
      } else if (question.options.contains('can')) {
        verbCan++;
      } else if (question.options.contains('will have')) {
        futurePerfect++;
      } else {
        presentSimple++;
      }
    }

    return {
      'Verb To Be': verbToBe,
      'Present Simple': presentSimple,
      'Future Perfect': futurePerfect,
      'Verb Can': verbCan,
    };
  }
}