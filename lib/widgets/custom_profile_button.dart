import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomProfileButton extends StatelessWidget {
  final Function()? onPressed;
  final double width;
  final double height;
  final String text;
  final Color? color;

  const CustomProfileButton({
    super.key,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            side: BorderSide.none,
            shape: const StadiumBorder()
          ),
          child: AutoSizeText(
              text,
              style: Theme.of(context).textTheme.displayMedium,
              maxLines: 1
          )
      ),
    );
  }
}