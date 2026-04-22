import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_project/features/home/widgets/intake_progress_card.dart';

// Helper: wraps the widget in a minimal Material app so it can render.
Widget buildCard({required int goalMl, required int currentMl}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: IntakeProgressCard(
          goalMl: goalMl,
          currentMl: currentMl,
        ),
      ),
    ),
  );
}

void main() {
  group('IntakeProgressCard – label display', () {
    testWidgets('shows current and goal in correct format', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 500));
      expect(find.text('500ml / 2000ml'), findsOneWidget);
    });

    testWidgets('shows 0ml / 2000ml when no intake logged yet', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 0));
      expect(find.text('0ml / 2000ml'), findsOneWidget);
    });

    testWidgets('shows equal values when goal is exactly reached', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 2000));
      expect(find.text('2000ml / 2000ml'), findsOneWidget);
    });

    testWidgets('shows over-goal values without crashing', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 2500));
      expect(find.text('2500ml / 2000ml'), findsOneWidget);
    });

    testWidgets('shows 0ml / 0ml when both values are 0', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 0, currentMl: 0));
      expect(find.text('0ml / 0ml'), findsOneWidget);
    });

    testWidgets('handles large values correctly', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 10000, currentMl: 7500));
      expect(find.text('7500ml / 10000ml'), findsOneWidget);
    });
  });

  group('IntakeProgressCard – progress logic (clamping)', () {
    // The card clamps progress to [0.0, 1.0] internally.
    // We verify it renders without overflow errors in all boundary cases.

    testWidgets('renders without error at 0% progress', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error at 50% progress', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 1000));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error at 100% progress', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 2000));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when intake exceeds goal (clamped to 1.0)',
        (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 3000));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when goal is 0 (division guard)', (tester) async {
      // goal == 0 should use progress = 0, not divide by zero.
      await tester.pumpWidget(buildCard(goalMl: 0, currentMl: 0));
      expect(tester.takeException(), isNull);
    });
  });

  group('IntakeProgressCard – widget structure', () {
    testWidgets('contains a FractionallySizedBox for the fill bar', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 1000));
      expect(find.byType(FractionallySizedBox), findsWidgets);
    });

    testWidgets('contains a Column as root layout', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 500));
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('contains at least one Stack for the bottle layering', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 500));
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('label text uses white color', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 500));
      final textWidget = tester.widget<Text>(find.text('500ml / 2000ml'));
      expect(textWidget.style?.color, Colors.white);
    });

    testWidgets('label text uses bold weight (w900)', (tester) async {
      await tester.pumpWidget(buildCard(goalMl: 2000, currentMl: 500));
      final textWidget = tester.widget<Text>(find.text('500ml / 2000ml'));
      expect(textWidget.style?.fontWeight, FontWeight.w900);
    });
  });
}
