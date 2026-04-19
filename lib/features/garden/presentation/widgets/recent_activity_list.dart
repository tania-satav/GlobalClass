import 'package:flutter/material.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 10),

        Text(
          "YOUR RECENT PLANTS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}