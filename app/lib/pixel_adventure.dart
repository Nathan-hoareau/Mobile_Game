import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/score.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Pink Man');
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
    'Level-05',
    'Level-06',
  ];
  Score score = Score();
  TextStyle style = TextStyle(
    color: BasicPalette.white.color,
    fontSize: 15.0,
  );
  late TextComponent scoreText;
  late TextComponent highScoreText;
  double time = 120;
  late double remainingTime;
  late TextComponent timerText;
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    remainingTime = time;

    _loadLevel();

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }

    scoreText = TextComponent(text: 'Score: ${score.currentScore}', textRenderer: TextPaint(style: style))
      ..anchor = Anchor.topLeft
      ..x = 32
      ..y = 32
      ..priority = 1;
    highScoreText = TextComponent(text: 'HighScore: ${score.highScore}', textRenderer: TextPaint(style: style))
      ..anchor = Anchor.topRight
      ..x = size.x - 32
      ..y = 32
      ..priority = 1;
    add(scoreText);
    add(highScoreText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    int currentScore = score.currentScore;
    int highScore = score.highScore;

    if (showControls) {
      updateJoystick();
    }
  
    scoreText.text = 'Score: $currentScore';
    highScoreText.text = 'HighScore: $highScore';

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      knobRadius: 50,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 64, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadThisLevel(String levelName) {
    int index = levelNames.indexOf(levelName);

    if (index < 0) {
      return;
    }

    removeWhere((component) => component is Level);
    currentLevelIndex = index;
    _loadLevel();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      score.saveHighScore();
      score.resetScore();
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;
      addAll([cam, world]);
    });
  }
}
