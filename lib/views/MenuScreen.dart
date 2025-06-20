import 'package:flutter/material.dart';
import 'package:noesis/views/FavoritesScreen.dart';
import 'VerboToBeScreen.dart';
import 'FuturePerfectScreen.dart';
import 'PresentSimpleScreen.dart';
import 'TheVerbCanScreen.dart';
import 'QuizScreen.dart';
import 'ProfileScreen.dart';
import '../services/favorites_service.dart';
import '../services/user_session_service.dart';
import '../models/lesson.dart';
import '../services/visits_service.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isClassSelected = true;
  int currentBottomNavIndex = 0;
  bool isLoadingFavorites = false;
  String? currentUserEmail;

  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Lista de lecciones disponibles
  final List<Lesson> availableLessons = [
    Lesson(
      id: 'verb_to_be',
      name: 'Verb to be',
      imagePath: 'assets/verb_to_be.png',
      screenRoute: '/verb_to_be',
    ),
    Lesson(
      id: 'future_perfect',
      name: 'Future Perfect',
      imagePath: 'assets/future_perfect.png',
      screenRoute: '/future_perfect',
    ),
    Lesson(
      id: 'present_simple',
      name: 'Present Simple',
      imagePath: 'assets/present_simple.png',
      screenRoute: '/present_simple',
    ),
    Lesson(
      id: 'verb_can',
      name: 'The Verb Can',
      imagePath: 'assets/verb_can.png',
      screenRoute: '/verb_can',
    ),
  ];

  // Lista filtrada de lecciones
  List<Lesson> get filteredLessons {
    if (_searchQuery.isEmpty) {
      return availableLessons;
    }

    return availableLessons.where((lesson) {
      return lesson.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadUserSession();

    // Agregar listener al controlador de búsqueda
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserSession() async {
    try {
      currentUserEmail = await UserSessionService.getCurrentUserEmail();
      if (currentUserEmail != null) {
        await _loadFavoriteStatus();
      }
    } catch (e) {
      print('Error loading user session: $e');
    }
  }

  Future<void> _loadFavoriteStatus() async {
    if (currentUserEmail == null) return;

    setState(() {
      isLoadingFavorites = true;
    });

    try {
      final favorites = await FavoritesService.getFavorites(currentUserEmail!);
      final favoriteIds = favorites.map((f) => f.id).toSet();

      setState(() {
        for (var lesson in availableLessons) {
          lesson.isFavorite = favoriteIds.contains(lesson.id);
        }
        isLoadingFavorites = false;
      });
    } catch (e) {
      print('Error loading favorite status: $e');
      setState(() {
        isLoadingFavorites = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text('Error al cargar favoritos'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleFavorite(Lesson lesson) async {
    if (currentUserEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Debes iniciar sesión para usar favoritos'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    bool success;
    bool wasAlreadyFavorite = lesson.isFavorite;

    try {
      if (lesson.isFavorite) {
        success = await FavoritesService.removeFromFavorites(currentUserEmail!, lesson.id);
      } else {
        success = await FavoritesService.addToFavorites(currentUserEmail!, lesson);
      }

      if (success) {
        setState(() {
          lesson.isFavorite = !lesson.isFavorite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  lesson.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lesson.isFavorite
                        ? '${lesson.name} agregado a favoritos'
                        : '${lesson.name} removido de favoritos',
                  ),
                ),
              ],
            ),
            backgroundColor: lesson.isFavorite ? Colors.green : Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
            action: lesson.isFavorite ? SnackBarAction(
              label: 'Ver favoritos',
              textColor: Colors.white,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
                await _loadFavoriteStatus();
              },
            ) : null,
          ),
        );
      } else {
        throw Exception('Error en la operación');
      }
    } catch (e) {
      print('Error toggling favorite: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Error al actualizar favoritos. Intenta de nuevo.'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.white,
            onPressed: () => _toggleFavorite(lesson),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener información de la pantalla
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 3 : 2;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFC96B0D)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          currentUserEmail ?? 'No hay usuario',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text('Favoritos'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
                await _loadFavoriteStatus();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/logo_noesis.png',
              height: 40,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                kBottomNavigationBarHeight,
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What class do you \nwant to learn?',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 28 : 24,
                  ),
                ),
                SizedBox(height: 16),
                // Campo de búsqueda con funcionalidad
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Color(0xFF878787),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF878787),
                      size: 24,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Color(0xFF878787),
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  cursorColor: Color(0xFF878787),
                ),
                SizedBox(height: 20),

                // Filtro para cambiar entre "Class" y "Game"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => isClassSelected = true),
                      child: Column(
                        children: [
                          Text(
                            'Class',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: isTablet ? 26 : 22,
                              color: isClassSelected ? Color(0xFFFF0000) : Colors.black,
                            ),
                          ),
                          if (isClassSelected)
                            Container(
                              height: 3,
                              width: 40,
                              color: Color(0xFFFF0000),
                              margin: EdgeInsets.only(top: 4),
                            )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isClassSelected = false),
                      child: Column(
                        children: [
                          Text(
                            'Game',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: isTablet ? 26 : 22,
                              color: !isClassSelected ? Color(0xFFFF0000) : Colors.black,
                            ),
                          ),
                          if (!isClassSelected)
                            Container(
                              height: 3,
                              width: 40,
                              color: Color(0xFFFF0000),
                              margin: EdgeInsets.only(top: 4),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Contenido principal
                if (isClassSelected)
                  isLoadingFavorites
                      ? Container(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.red),
                          SizedBox(height: 16),
                          Text('Cargando favoritos...'),
                        ],
                      ),
                    ),
                  )
                      : filteredLessons.isEmpty && _searchQuery.isNotEmpty
                      ? Container(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No se encontraron resultados',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Intenta con otro término de búsqueda',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isTablet ? 1.1 : 186 / 201,
                    ),
                    itemCount: filteredLessons.length,
                    itemBuilder: (context, index) {
                      final lesson = filteredLessons[index];
                      return _buildLessonCard(lesson, isTablet);
                    },
                  ),
                if (!isClassSelected)
                  Container(
                    height: 300,
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.play_arrow),
                        label: Text(
                          'Start Game',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 24 : 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40 : 32,
                              vertical: isTablet ? 20 : 16
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizScreen()),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: currentBottomNavIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) async {
          setState(() {
            currentBottomNavIndex = index;
          });

          switch (index) {
            case 0:
              break;
            case 1:
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
              await _loadFavoriteStatus();
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, bool isTablet) {
    final cardWidth = isTablet ? 220.0 : 186.0;
    final cardHeight = isTablet ? 240.0 : 201.0;

    return GestureDetector(
      onTap: () => _navigateToLessonScreen(lesson),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Imagen de fondo con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  lesson.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Botón de favorito
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _toggleFavorite(lesson),
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 8 : 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    lesson.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: lesson.isFavorite ? Colors.red : Colors.grey[600],
                    size: isTablet ? 24 : 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToLessonScreen(Lesson lesson) async {
    // Registrar la visita si hay usuario logueado
    if (currentUserEmail != null) {
      try {
        await VisitsService.registerVisit(currentUserEmail!, lesson.id);
      } catch (e) {
        print('Error registering visit: $e');
      }
    }

    Widget screen;

    switch (lesson.id) {
      case 'verb_to_be':
        screen = VerboToBeScreen();
        break;
      case 'future_perfect':
        screen = FuturePerfectScreen();
        break;
      case 'present_simple':
        screen = PresentSimpleScreen();
        break;
      case 'verb_can':
        screen = TheVerbCanScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}