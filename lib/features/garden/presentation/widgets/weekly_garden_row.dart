import 'package:flutter/material.dart';

import '../../application/garden_controller.dart';
import '../../domain/garden_day.dart';
import '../utils/week_utils.dart';

import 'weekly_day_tile.dart';

class WeeklyGardenRow
    extends StatefulWidget {
  const WeeklyGardenRow({super.key});

  @override
  State<WeeklyGardenRow> createState() =>
      _WeeklyGardenRowState();
}

class _WeeklyGardenRowState
    extends State<WeeklyGardenRow> {
  final controller = GardenController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await controller.loadWeek();

    setState(() {
      isLoading = false;
    });
  }

  GardenDay? _getDay(
      DateTime day) {
    return controller.dayForDate(day);
  }

  @override
  Widget build(BuildContext context) {
    final days =
        WeekUtils.buildWeekDays();

    if (isLoading) {
      return const SizedBox(height: 80);
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: days.map((day) {
          final isFuture =
              WeekUtils.isFutureDay(day);

          final label =
              WeekUtils.getDayLabel(day);

          final data =
              _getDay(day);

          final intake =
              data?.intakeMl ?? 0;

          final goal =
              data?.goalMl ?? 2000;

          final flowerType =
              data?.flowerType ??
                  FlowerType.sunflower;

          return WeeklyDayTile(
            intakeMl: intake,
            goalMl: goal,
            isFuture: isFuture,
            label: label,
            flowerType: flowerType,
          );
        }).toList(),
      ),
    );
  }
}