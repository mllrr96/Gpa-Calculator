import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CopyButton extends StatelessWidget {
  const CopyButton(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25.0),
      onTap: () {
        final snackBar = SnackBar(content: Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Icon(LucideIcons.info, size: 20),
    );
  }
}
