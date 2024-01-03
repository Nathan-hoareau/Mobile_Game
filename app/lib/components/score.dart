
import 'package:shared_preferences/shared_preferences.dart';

class Score {
  int currentScore = 0;
  int highScore = 0;

  Score() {
    getHighScore();
  }

  void updateScore(int points) {
    currentScore += points;
  }

  void getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }

  void saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highScore', highScore);
  }

  void updateHighScore() {
    if (currentScore > highScore) {
      highScore = currentScore;
    }
    saveHighScore();
  }

  void resetScore() {
    currentScore = 0;
  }
}