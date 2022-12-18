import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadaa/app/shared/enum/sound_type.dart';

class EffectManager extends GetxController {
  /* *************** Variables *************** */
  late ConfettiController confettiController;
  AlignmentGeometry confettiAlignment = Alignment.topCenter;
  double gravity = 0.2;
  final player = AudioPlayer();
  List<Color>? colors = const [
    Color.fromARGB(255, 233, 30, 99),
    Color.fromARGB(255, 41, 110, 180),
    Colors.orange
    // Colors.blue,
    // Colors.pink,
    // Colors.orange,
    // Colors.purple
  ];
  /* *************** Controller life cycle *************** */
  @override
  void onInit() async {
    super.onInit();

    //
    confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    //
    update();
  }

  /* *************** Functions *************** */
  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Future<void> playConfetti({
    int milliseconds = 1000,
    AlignmentGeometry alignment = Alignment.topCenter,
    SoundType soundType = SoundType.big,
  }) async {
    confettiAlignment = alignment;
    confettiController.duration = Duration(milliseconds: milliseconds);

    await playSoundEffect(soundType: soundType);
    update();
    confettiController.play();
  }

  playSoundEffect({SoundType soundType = SoundType.big}) async {
    switch (soundType) {
      case SoundType.big:
        await player.play(AssetSource("sounds/big_finish.mp3"));
        gravity = 0.9;
        break;
      case SoundType.small:
        await player.play(AssetSource("sounds/small_finish.mp3"));
        gravity = 0.2;
        break;
      default:
    }
  }
}
