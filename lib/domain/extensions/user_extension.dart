import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/extensions/string_extension.dart';
import 'package:nakama/nakama.dart';

extension UserExtensions on User {
  String get showingName {
    if (displayName.isNotNullOrBlank) {
      return displayName!;
    }
    return PlaneaType.fromUserId(id).name;
  }
}
