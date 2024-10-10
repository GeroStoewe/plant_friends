import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

enum MessageType { success, error, info }

class CustomSnackbar {
  final BuildContext context;

  CustomSnackbar(this.context);

  void showMessage(String message, MessageType type) {
    // Bestimme die Hintergrundfarbe und das Symbol basierend auf dem Nachrichtentyp
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case MessageType.error:
        backgroundColor = Colors.deepOrange;
        icon = Icons.error_outline_rounded;
        break;
      case MessageType.info:
        backgroundColor = lightSeaGreen; // Farbe für Informationsnachrichten
        icon = Icons.info_outline_rounded; // Symbol für Informationsnachrichten
        break;
      case MessageType.success:
      default:
        backgroundColor = seaGreen;
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    // Snackbar anzeigen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 7.5),
            Expanded(
              child: Center(  // Text in Center-Widget einfügen
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center, // Text zentrieren
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
