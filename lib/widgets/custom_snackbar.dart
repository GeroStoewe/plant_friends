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
    IconData iconClose = Icons.close_rounded;

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

    // Reference to ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show the Snackbar
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 7.5),
          Expanded(
            child: Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center),
          ),
          GestureDetector(
            onTap: () {
              scaffoldMessenger.hideCurrentSnackBar(); // Close the snackbar
            },
            child: Icon(
              iconClose,
              color: Colors.white,
              size: 30,
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
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }
}
