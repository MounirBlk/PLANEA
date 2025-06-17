import 'package:planea/presentation/helpers/update_helper/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class AppUpdateHelper {
  static Future<void> handleUpdateRequired(BuildContext context) async {
    final result = await UpdateDialog.show(
      context,
      actionButton: 'Raffraichir',
    );
    if (result == true) {
      web.window.location.reload();
    }
  }
}
