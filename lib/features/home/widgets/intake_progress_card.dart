import 'dart:async';
import 'package:flutter/material.dart';
import 'wave_clipper.dart';

class IntakeProgressCard extends StatefulWidget {
  final int goalMl;
  final int currentMl;

  const IntakeProgressCard({
    super.key,
    required this.goalMl,
    required this.currentMl,
  });

  @override
  State<IntakeProgressCard> createState() => _IntakeProgressCardState();
}

class _IntakeProgressCardState extends State<IntakeProgressCard> {
  double wavePhase = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 60), (_) {
      setState(() {
        wavePhase += 0.2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = widget.goalMl == 0
        ? 0
        : (widget.currentMl / widget.goalMl).clamp(0.0, 1.0);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 26,
                  backgroundColor: const Color(0xFF8ED0E0),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF0A7DAC)),
                );
              },
            ),
          ),

          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(120),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([]),
                    builder: (context, _) {
                      return ClipPath(
                        clipper: WaveClipper(
                          progress: progress,
                          wavePhase: wavePhase,
                        ),
                        child: Container(color: const Color(0xFF8ACEFF)),
                      );
                    },
                  ),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/plants/mainflower.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.currentMl} / ${widget.goalMl} ml',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
