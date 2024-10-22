import 'package:flutter/material.dart';

class TranslationButton extends StatelessWidget {
  const TranslationButton({
    Key? key,
    required this.translation,
    required this.onPressed,
  }) : super(key: key);

  final String translation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          translation,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
