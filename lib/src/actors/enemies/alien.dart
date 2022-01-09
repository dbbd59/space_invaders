import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../game.dart';
import '../player_laser.dart';

class Alien extends SpriteComponent
    with HasGameRef<SpaceInvadersGame>, HasHitboxes, Collidable {
  static const speed = 500.0;
  Vector2 velocity = Vector2(0, 0);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerLaser) {
      final rnd = Random();
      Vector2 randomVector2() =>
          (Vector2.random(rnd) - Vector2.random(rnd)) * speed;
      gameRef.add(
        ParticleComponent(
          Particle.generate(
            generator: (i) => AcceleratedParticle(
              position: position,
              acceleration: randomVector2(),
              child: CircleParticle(
                paint: Paint()..color = const Color(0xFF46EC4E),
                radius: 2,
                lifespan: .1,
              ),
            ),
          ),
        ),
      );
      FlameAudio.play('alien-death.mp3');
      gameRef.add(Alien());
      gameRef.remove(this);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxRectangle());

    sprite = await gameRef.loadSprite('alien.png');
    width = 50;
    height = 50;

    final rnd = Random();
    final x = rnd.nextInt(gameRef.size.x.toInt()).toDouble();
    final y =
        rnd.nextInt(gameRef.size.y.toInt() - gameRef.size.y ~/ 3).toDouble();

    position.x = x;
    position.y = y;
    anchor = Anchor.center;
  }
}
