import 'package:flutter/material.dart';

class GrowableFlowersBar extends StatelessWidget {
  const GrowableFlowersBar({super.key});

  @override
  Widget build(BuildContext context) {
    final flowers = [
      {"name": "Sunflower", "asset": "assets/plants/sunflower.png"},
      {"name": "Blue Flower", "asset": "assets/plants/blueflower.png"},
      {"name": "Red Flower", "asset": "assets/plants/redflower.png"},
      {"name": "Purple Flower", "asset": "assets/plants/purpleflower.png"},
    ];

    return Column(
      children: [
        const SizedBox(height: 10),

        // TITLE
        const Text(
          "You can grow",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1D3557),
          ),
        ),

        const SizedBox(height: 12),

        // FLOWER BUBBLES
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            //
            padding: const EdgeInsets.only(left: 12, right: 12),

            itemCount: flowers.length,
            itemBuilder: (context, index) {
              final flower = flowers[index];

              return Container(
                margin: const EdgeInsets.only(
                  right: 8,
                ), // keep spacing only on right

                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(blurRadius: 4, color: Colors.white),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(flower["asset"]!, width: 40, height: 40),
                    const SizedBox(height: 6),
                    Text(
                      flower["name"]!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
