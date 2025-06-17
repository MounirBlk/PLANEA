// ignore_for_file: unused_import
import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class HiddenCoin extends PositionComponent {
  HiddenCoin({required super.position, required super.size})
    : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  /*@override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      (size / 2).toOffset(),
      size.x / 2,
      BasicPalette.yellow.paint(),
    );
  }*/
}
