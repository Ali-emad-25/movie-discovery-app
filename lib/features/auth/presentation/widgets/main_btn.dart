import 'package:flutter/material.dart';

class MainBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MainBtn({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: theme.textTheme.titleSmall),
    );
  }
}
