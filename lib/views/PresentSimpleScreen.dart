import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'MenuScreen.dart';
import 'ProfileScreen.dart';
import 'FavoritesScreen.dart';

class PresentSimpleScreen extends StatefulWidget {
  @override
  _PresentSimpleScreenState createState() => _PresentSimpleScreenState();
}

class _PresentSimpleScreenState extends State<PresentSimpleScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentlyPlaying = '';

  int currentBottomNavIndex = 0;

  Future<void> playAudio(String audioFile) async {
    try {
      debugPrint("Attempting to play: assets/audios/$audioFile");

      if (isPlaying) {
        await audioPlayer.stop();
        setState(() {
          isPlaying = false;
          currentlyPlaying = '';
        });
      }

      if (currentlyPlaying != audioFile) {
        setState(() {
          isPlaying = true;
          currentlyPlaying = audioFile;
        });

        await audioPlayer.play(AssetSource('audios/$audioFile'));

        audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlaying = false;
            currentlyPlaying = '';
          });
        });
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
      setState(() {
        isPlaying = false;
        currentlyPlaying = '';
      });
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildAudioExample(String englishText, String spanishText, String audioFile) {
    bool isThisPlaying = isPlaying && currentlyPlaying == audioFile;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  englishText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  spanishText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              icon: Icon(
                isThisPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
              ),
              onPressed: () => playAudio(audioFile),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/present_simple_pizarra.png',
                width: 300,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'El Present Simple en inglés se usa para hablar de rutinas, hechos y situaciones permanentes. Se forma con el verbo en su forma base. En tercera persona (he, she, it) se agrega una ‘-s’ o ‘es’ al verbo. Por ejemplo, "Yo estudio inglés" se traduce como "I study English", y "Él trabaja mucho" se traduce como "He works a lot."',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  'assets/present_simple_tabla.png',
                  width: 300,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Text(
                        'PRESENT SIMPLE – Ejemplos',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Color(0xFFFA0000),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildAudioExample(
                    'I study English.',
                    '(Yo estudio inglés.)',
                    'I_study_English.mp3',
                  ),
                  Divider(),
                  _buildAudioExample(
                    'He plays football.',
                    '(Él juega fútbol.)',
                    'He_plays_football.mp3',
                  ),
                  Divider(),
                  _buildAudioExample(
                    'She works a lot.',
                    '(Ella trabaja mucho.)',
                    'She_works_a_lot.mp3',
                  ),
                  Divider(),
                  _buildAudioExample(
                    'We watch TV.',
                    '(Nosotros vemos televisión.)',
                    'We_watch_TV.mp3',
                  ),
                ],
              ),
            ),
          ],
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
        onTap: (index) {
          setState(() {
            currentBottomNavIndex = index;
          });

          // Navegación basada en el índice seleccionado
          switch (index) {
            case 0:
            // Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
              break;
            case 2:
            // Perfil
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
}