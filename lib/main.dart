import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    GameWidget(
      game: SpaceInvadersGame(),
    ),
  );
}

class SpaceInvadersGame extends FlameGame with KeyboardEvents {
  late Player player1;

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
      player1.velocity = Vector2(-1, 0);
    } else if (isRight && isKeyDown) {
      player1.velocity = Vector2(1, 0);
    } else if (isDown && isKeyDown) {
      player1.velocity = Vector2(0, 1);
    } else if (isUp && isKeyDown) {
      player1.velocity = Vector2(0, -1);
    } else if (isSpace && isKeyDown) {
      player1.shoot();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    FlameAudio.bgm.initialize();

    player1 = Player();

    add(player1);
  }
}

class Player extends SpriteComponent with HasGameRef<SpaceInvadersGame> {
  static const speed = 200;

  Vector2 velocity = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('spaceship.png');
    width = 50;
    height = 75;
    position = gameRef.size / 2;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final displacement = velocity * (speed * dt);
    move(displacement);
  }

  void move(Vector2 delta) {
    position += delta;

    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
  }

  void shoot() {
    final rnd = Random();

    Vector2 randomVector2() =>
        (Vector2.random(rnd) - Vector2.random(rnd)) * 200;

    gameRef.add(
      ParticleComponent(
        Particle.generate(
          generator: (i) => AcceleratedParticle(
            position: position.clone()..y = y + -height / 2,
            acceleration: randomVector2(),
            child: CircleParticle(
              paint: Paint()..color = const Color(0xFF85E0EC),
              radius: 2,
              lifespan: .1,
            ),
          ),
        ),
      ),
    );
    gameRef.add(PlayerShoot(position.clone()..y = y + -height / 2));
  }
}

class PlayerShoot extends SpriteComponent with HasGameRef<SpaceInvadersGame> {
  static const speed = 500.0;
  final Vector2 p;

  Vector2 velocity = Vector2(0, -1);

  PlayerShoot(
    this.p,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('bullet.png');
    width = 25;
    height = 50;
    position = p;
    anchor = Anchor.center;

    FlameAudio.play('laser.mp3');
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * speed * dt;
    if (position.y < 0) {}
  }
}
