import 'package:flutter/material.dart';

class ReferenceButton extends StatelessWidget {
  const ReferenceButton({Key? key, 
    required this.reference,
    required this.onPressed,
  }) : super(key: key);

  final String reference;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          reference,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
