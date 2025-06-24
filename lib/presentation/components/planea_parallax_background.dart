import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:planea/domain/entities/playing_state.dart';
import 'package:planea/presentation/planea_game.dart';

class PlaneaParallaxBackground extends ParallaxComponent<PlaneaGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final record = game.leaderboardCubit.state.leaderboardEntity?.ownerRecord;
    final score = int.tryParse(record?.score ?? '') ?? 0;
    final codeBackground = score >= 600
        ? '1_3'
        : score >= 450 && score <= 599
        ? '1_2'
        : score >= 300 && score <= 449
        ? '1_1'
        : score >= 150 && score <= 299
        ? '2_3'
        : score >= 0 && score <= 149
        ? '2_2'
        : '2_2';
    parallax = await game.loadParallax(
      [
        /*ParallaxImageData('background/layer1-sky.png'),
        ParallaxImageData('background/layer2-clouds.png'),
        ParallaxImageData('background/layer3-clouds.png'),
        ParallaxImageData('background/layer4-clouds.png'),
        ParallaxImageData('background/layer5-huge-clouds.png'),
        ParallaxImageData('background/layer6-bushes.png'),
        ParallaxImageData('background/layer7-bushes.png'),*/
        ParallaxImageData(
          'background/clouds/clouds_background$codeBackground/1.png',
        ),
        ParallaxImageData(
          'background/clouds/clouds_background$codeBackground/2.png',
        ),
        ParallaxImageData(
          'background/clouds/clouds_background$codeBackground/3.png',
        ),
        ParallaxImageData(
          'background/clouds/clouds_background$codeBackground/4.png',
        ),
        ParallaxImageData(
          'background/clouds/clouds_background$codeBackground/5.png',
        ),
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
