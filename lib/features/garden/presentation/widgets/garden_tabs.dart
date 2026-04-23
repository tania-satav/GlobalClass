/*import 'package:flutter/material.dart';

class GardenTabs extends StatelessWidget {
  const GardenTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _Tab(label: "Monthly", selected: true),
        _Tab(label: "Weekly"),
        _Tab(label: "Daily"),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;

  const _Tab({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected
            ? Colors.blue
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected
              ? Colors.white
              : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
*/