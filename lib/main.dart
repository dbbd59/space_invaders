import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_invaders/src/overlay.dart';

import 'src/game.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GameSpaceInvader(),
      ),
    ),
  );
}

class GameSpaceInvader extends StatelessWidget {
  const GameSpaceInvader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget<SpaceInvadersGame>(
      game: SpaceInvadersGame(),
      initialActiveOverlays: [OverlayStart.ID],
      overlayBuilderMap: {
        OverlayStart.ID: (
          BuildContext context,
          SpaceInvadersGame gameRef,
        ) {
          return OverlayStart(
            gameRef: gameRef,
          );
        },
        OverlayGameOver.ID: (
          BuildContext context,
          SpaceInvadersGame gameRef,
        ) {
          return OverlayGameOver(
            gameRef: gameRef,
          );
        },
      },
    );
  }
}
