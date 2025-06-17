import 'package:planea/domain/entities/planea_type.dart';
import 'package:flutter/material.dart';

class PlaneaImage extends StatelessWidget {
  const PlaneaImage({super.key, required this.size, required this.planeaType});

  final double size;
  final PlaneaType planeaType;

  @override
  Widget build(BuildContext context) {
    return Image.asset(planeaType.pngAssetName, width: size, height: size);
  }
}
