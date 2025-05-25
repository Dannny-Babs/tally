import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const PlatformBackButton({
    super.key,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
            child: Icon(
              CupertinoIcons.back,
              color: color,
            ),
          )
        : IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: color,
            ),
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
          );
  }
} 