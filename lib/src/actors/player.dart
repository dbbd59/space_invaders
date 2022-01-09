import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:space_invaders/src/actors/enemies/alien.dart';
import 'package:space_invaders/src/overlay.dart';

import '../game.dart';
import 'player_laser.dart';

class Player extends SpriteComponent
    with HasGameRef<SpaceInvadersGame>, HasHitboxes, Collidable {
  static const speed = 400.0;

  Vector2 velocity = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxRectangle());

    sprite = await gameRef.loadSprite('spaceship.png');
    width = 50;
    height = 75;
    position.x = gameRef.size.x / 2;
    position.y = gameRef.size.y - (height * 3);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Alien) {
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
                paint: Paint()..color = const Color(0xFFE9EC46),
                radius: 5,
                lifespan: 3.5,
              ),
            ),
          ),
        ),
      );
      gameRef.add(
        ParticleComponent(
          Particle.generate(
            generator: (i) => AcceleratedParticle(
              position: position,
              acceleration: randomVector2(),
              child: CircleParticle(
                paint: Paint()..color = const Color(0xFFF0150D),
                radius: 5,
                lifespan: 3.5,
              ),
            ),
          ),
        ),
      );
      gameRef.add(
        ParticleComponent(
          Particle.generate(
            generator: (i) => AcceleratedParticle(
              position: position,
              acceleration: randomVector2(),
              child: CircleParticle(
                paint: Paint()..color = const Color(0xFFFF9900),
                radius: 5,
                lifespan: 3.5,
              ),
            ),
          ),
        ),
      );
      FlameAudio.play('player-death.mp3');

      gameRef.remove(this);
      gameRef.overlays.add(OverlayGameOver.ID);
    }
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
    gameRef.add(PlayerLaser(position.clone()..y = y + -height / 2));
  }
}
