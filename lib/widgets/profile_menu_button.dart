import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/themes/colors.dart';

class ProfileMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;
  final bool endIcon;
  final Color? textColor;

  const ProfileMenuButton ({
   super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    this.endIcon = true,
    this.textColor
});
  
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isDarkMode ? darkSeaGreen.withOpacity(0.1) : lightSeaGreen.withOpacity(0.2)
        ),
        child: Icon(
            icon,
            color: isDarkMode ? seaGreen : forestGreen
        ),
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.apply(color: textColor),
      ),
      trailing: endIcon ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.25)
        ),
        child: Icon(
          LineAwesomeIcons.angle_right_solid,
          size: 18.0,
          color: isDarkMode ? Colors.grey : Colors.black,
        ),
      ) : null,
    );
  }
}