enum PlaneaType {
  flutterPlanea,
  limePlanea,
  peachyPlanea,
  rosePlanea,
  sandPlanea,
  scarletPlanea,
  skyPlanea,
  mintyPlanea,
  sunnyPlanea,
  violetPlanea;

  static PlaneaType fromUserId(String userId) {
    int sum = 0;
    for (int i = 0; i < userId.length; i++) {
      sum += userId.codeUnitAt(i);
    }
    final index = sum % PlaneaType.values.length;
    return PlaneaType.values[index];
  }

  String get name => switch (this) {
    PlaneaType.flutterPlanea => 'Flutter Planea',
    PlaneaType.limePlanea => 'Lime Planea',
    PlaneaType.peachyPlanea => 'Peachy Planea',
    PlaneaType.rosePlanea => 'Rose Planea',
    PlaneaType.sandPlanea => 'Sand Planea',
    PlaneaType.scarletPlanea => 'Scarlet Planea',
    PlaneaType.skyPlanea => 'Sky Planea',
    PlaneaType.mintyPlanea => 'Minty Planea',
    PlaneaType.sunnyPlanea => 'Sunny Planea',
    PlaneaType.violetPlanea => 'Violet Planea',
  };

  String get _fileName => switch (this) {
    PlaneaType.flutterPlanea => 'flutter_planea',
    PlaneaType.limePlanea => 'lime_planea',
    PlaneaType.peachyPlanea => 'peachy_planea',
    PlaneaType.rosePlanea => 'rose_planea',
    PlaneaType.sandPlanea => 'sand_planea',
    PlaneaType.scarletPlanea => 'scarlet_planea',
    PlaneaType.skyPlanea => 'sky_planea',
    PlaneaType.mintyPlanea => 'minty_planea',
    PlaneaType.sunnyPlanea => 'sunny_planea',
    PlaneaType.violetPlanea => 'violet_planea',
  };

  String get flamePngAssetName => 'planeas/$_fileName.png';

  String get pngAssetName => 'assets/images/planeas/$_fileName.png';
}
