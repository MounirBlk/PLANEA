import 'package:flutter/material.dart';
import 'package:planea/presentation/dialogs/leaderboard_dialog.dart';
import 'package:planea/presentation/dialogs/nickname_dialog.dart';

class AppDialogs {
  static Future<void> showLeaderboard(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const LeaderBoardDialog();
      },
    );
  }

  static Future<void> nicknameDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const NicknameDialog();
      },
    );
  }
}
