import 'package:flutter/material.dart';

class CustomProfileButton extends StatelessWidget {
  final Function()? onPressed;
  final double width;
  final double height;
  final String text;

  const CustomProfileButton({
    super.key,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            side: BorderSide.none,
            shape: const StadiumBorder()
          ),
          child: Text(
              text,
              style: Theme.of(context).textTheme.labelMedium
          )
      ),
    );
  }
}