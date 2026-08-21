import 'package:alchemist/alchemist.dart';
import 'package:dotdart_example/gen/lotties.g.dart';
import 'package:flutter/material.dart';

void main() {
  goldenTest(
    'when trim-path progress advances, it should reveal the generated stroke',
    fileName: 'trim_path_frames',
    builder: () => GoldenTestGroup(
      columns: 3,
      scenarioConstraints: const BoxConstraints.tightFor(width: 140, height: 80),
      children: [
        GoldenTestScenario(
          name: 'empty',
          child: ColoredBox(
            color: Colors.white,
            child: Center(child: $Lotties.trimPath(width: 100, progress: 0)),
          ),
        ),
        GoldenTestScenario(
          name: 'half drawn',
          child: ColoredBox(
            color: Colors.white,
            child: Center(child: $Lotties.trimPath(width: 100, progress: 0.5)),
          ),
        ),
        GoldenTestScenario(
          name: 'complete',
          child: ColoredBox(
            color: Colors.white,
            child: Center(child: $Lotties.trimPath(width: 100, progress: 1)),
          ),
        ),
      ],
    ),
  );
}
