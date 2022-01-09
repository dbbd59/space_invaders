import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/src/actors/enemies/alien.dart';
import 'package:space_invaders/src/actors/player.dart';

class SpaceInvadersGame extends FlameGame with KeyboardEvents, HasCollidables {
  late Player player;

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);
    final isDown = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    final isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isLeft && isKeyDown) {
      player.velocity = Vector2(-1, 0);
    } else if (isRight && isKeyDown) {
      player.velocity = Vector2(1, 0);
    } else if (isDown && isKeyDown) {
      player.velocity = Vector2(0, 1);
    } else if (isUp && isKeyDown) {
      player.velocity = Vector2(0, -1);
    } else if (isSpace && isKeyDown) {
      player.shoot();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    FlameAudio.bgm.initialize();

    final background = await ParallaxComponent.load(
      [
        ParallaxImageData('background.png'),
      ],
      alignment: Alignment.center,
      fill: LayerFill.width,
      repeat: ImageRepeat.repeatY,
      baseVelocity: Vector2(0, -50),
    );
    await add(background);
  }

  Future<void> reset() async {
    children.whereType<Player>().forEach((player) => remove(player));
    children.whereType<Alien>().forEach((alien) => remove(alien));

    await init();
  }

  Future<void> init() async {
    player = Player();
    await add(player);

    final aliens = [
      for (var i = 0; i < 5; i++) Alien(),
    ];
    await addAll(
      aliens,
    );
  }
}
