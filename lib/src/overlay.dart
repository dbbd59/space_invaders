import 'package:flutter/material.dart';
import 'package:space_invaders/src/game.dart';

class OverlayStart extends StatefulWidget {
  static const String ID = 'OverlayStartId';
  final SpaceInvadersGame gameRef;

  const OverlayStart({
    required this.gameRef,
    Key? key,
  }) : super(key: key);

  @override
  State<OverlayStart> createState() => _OverlayStartState();
}

class _OverlayStartState extends State<OverlayStart> {
  @override
  void initState() {
    super.initState();
    widget.gameRef.pauseEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                widget.gameRef.overlays.remove(OverlayStart.ID);
                widget.gameRef.reset();
                widget.gameRef.resumeEngine();
              },
              child: const Text('Start'),
            ),
          ),

          // Exit button.
        ],
      ),
    );
  }
}

class OverlayGameOver extends StatelessWidget {
  static const String ID = 'OverlayGameOverId';
  final SpaceInvadersGame gameRef;

  const OverlayGameOver({
    required this.gameRef,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'Game Over',
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Restart'),
            ),
          ),

          // Exit button.
        ],
      ),
    );
  }
}
