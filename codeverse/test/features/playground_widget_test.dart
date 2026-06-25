import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/data/models/playground_data.dart';
import 'package:codeverse/features/level/presentation/playground_widget.dart';

Widget _wrap(PlaygroundData playground) {
  return MaterialApp(
    home: Scaffold(body: PlaygroundWidget(playground: playground)),
  );
}

void main() {
  testWidgets('color_picker shows a swatch per palette entry',
      (tester) async {
    await tester.pumpWidget(_wrap(const PlaygroundData(
      type: 'color_picker',
      instructions: 'pick',
      config: {'palette': ['#FF0000', '#00FF00']},
    )));

    expect(find.byType(GestureDetector), findsNWidgets(2));
  });

  testWidgets('average_calculator updates the average when a number is added',
      (tester) async {
    await tester.pumpWidget(_wrap(const PlaygroundData(
      type: 'average_calculator',
      instructions: 'avg',
      config: {'startingNumbers': [10, 20]},
    )));

    expect(find.text('Average: 15.0'), findsOneWidget);

    await tester.tap(find.text('Add 5'));
    await tester.pump();

    expect(find.text('Average: 11.7'), findsOneWidget);
  });

  testWidgets('coordinate_mover moves the marker on tap', (tester) async {
    await tester.pumpWidget(_wrap(const PlaygroundData(
      type: 'coordinate_mover',
      instructions: 'move',
      config: {'gridSize': 3},
    )));

    expect(find.text('Position: (0, 0)'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector).at(4));
    await tester.pump();

    expect(find.text('Position: (0, 0)'), findsNothing);
  });

  testWidgets('unknown playground type falls back to instructions text',
      (tester) async {
    await tester.pumpWidget(_wrap(const PlaygroundData(
      type: 'totally_unknown',
      instructions: 'Just read this for now.',
    )));

    expect(find.text('Just read this for now.'), findsOneWidget);
  });
}
