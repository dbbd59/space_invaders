import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import 'enemies/alien.dart';

class PlayerLaser extends SpriteComponent
    with HasGameRef<SpaceInvadersGame>, HasHitboxes, Collidable {
  PlayerLaser(
    this.p,
  );

  static const speed = 500.0;

  final Vector2 p;
  Vector2 velocity = Vector2(0, -1);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Alien) {
      gameRef.remove(this);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('bullet.png');
    width = 25;
    height = 50;
    position = p;
    anchor = Anchor.center;

    addHitbox(HitboxRectangle());

    final rnd = Random();
    Vector2 randomVector2() =>
        (Vector2.random(rnd) - Vector2.random(rnd)) * speed;
    await gameRef.add(
      ParticleComponent(
        Particle.generate(
          generator: (i) => AcceleratedParticle(
            position: position,
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

    await FlameAudio.play('laser.mp3');
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * speed * dt;
    if (position.y < 0) {}
  }
}
