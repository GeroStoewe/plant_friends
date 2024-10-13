import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/themes/colors.dart';

class ProfileMenuButton extends StatelessWidget {
  final Function()? onTap;
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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isDarkMode ? darkSeaGreen.withOpacity(0.1) : lightSeaGreen.withOpacity(0.2)
        ),
        child: Icon(
            icon,
            size: 20,
            color: isDarkMode ? seaGreen : forestGreen
        ),
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.apply(color: textColor),
      ),
      trailing: endIcon ? Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.25)
        ),
        child: Icon(
          LineAwesomeIcons.angle_right_solid,
          size: 16.0,
          color: isDarkMode ? Colors.grey : Colors.black,
        ),
      ) : null,
    );
  }
}