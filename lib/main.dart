import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_invaders/src/overlay.dart';

import 'src/game.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
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
        ),
      ),
    ),
  );
}
