import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  const StepProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF7B2027);
    const inactiveColor = Color(0xFFD1CDC0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStep(1, "PASSPORT", currentStep >= 1 ? activeColor : inactiveColor),
          _buildStep(2, "PERSONAL", currentStep >= 2 ? activeColor : inactiveColor),
          _buildStep(3, "PAYMENT", currentStep >= 3 ? activeColor : inactiveColor),
          _buildStep(4, "APPROVAL", currentStep >= 4 ? activeColor : inactiveColor),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}