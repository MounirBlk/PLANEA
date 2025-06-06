import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PipePosition extends PositionComponent {
  late Sprite _pipeSprite;
  final bool isFlipped; // Property to check if the pipe is flipped

  PipePosition({required this.isFlipped, required super.position})
    : super(priority: 2);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _pipeSprite = await Sprite.load('pipe.png'); // Load the sprite image
    anchor = Anchor.topCenter; // Set anchor to center
    final ratio = _pipeSprite.srcSize.y / _pipeSprite.srcSize.x;
    const width = 82.0; // Set the width of the pipe
    size = Vector2(width, width * ratio); // Set the size of the pipe
    if (isFlipped) {
      flipVertically();
    }
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _pipeSprite.render(canvas, position: Vector2.zero(), size: size);
  }
}
