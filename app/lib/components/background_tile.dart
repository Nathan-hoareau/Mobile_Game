import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class BackgroundTile extends ParallaxComponent {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    position,
  }) : super(
          position: position,
        );

  final double scrollSpeed = 40;

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2(
      game.size.x,
      game.size.y,
    );
    parallax = await gameRef.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    size = Vector2(
      game.size.x,
      game.size.y,
    );
    super.update(dt);
  }
}
