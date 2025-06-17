import 'package:flutter/material.dart';

class UpdateDialog {
  static Future<bool?> show(
    BuildContext context, {
    String actionButton = 'Mise à jour',
  }) {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Version obsolète'),
          content: const Text(
            "Veuillez mettre à jour l'application vers la dernière version pour continuer à l'utiliser.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(actionButton),
            ),
          ],
        );
      },
    );
  }
}
