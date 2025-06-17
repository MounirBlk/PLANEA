import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:planea/domain/entities/playing_state.dart';
import 'package:planea/presentation/planea_game.dart';

class PlaneaParallaxBackground extends ParallaxComponent<PlaneaGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/layer1-sky.png'),
        ParallaxImageData('background/layer2-clouds.png'),
        ParallaxImageData('background/layer3-clouds.png'),
        ParallaxImageData('background/layer4-clouds.png'),
        ParallaxImageData('background/layer5-huge-clouds.png'),
        ParallaxImageData('background/layer6-bushes.png'),
        ParallaxImageData('background/layer7-bushes.png'),
      ],
      baseVelocity: Vector2(1, 0),
      velocityMultiplierDelta: Vector2(1.7, 0),
    );
  }

  @override
  void update(double dt) {
    switch (game.getCurrentPlayingState()) {
      case PlayingState.idle:
      case PlayingState.playing:
        super.update(dt);
        break;
      case PlayingState.paused:
      case PlayingState.gameOver:
        break;
    }
  }
}
