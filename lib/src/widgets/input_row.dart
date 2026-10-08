import 'package:flutter/material.dart';

class InputRow extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isRequired;

  const InputRow({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(color: Color(0xFFFF5252)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

