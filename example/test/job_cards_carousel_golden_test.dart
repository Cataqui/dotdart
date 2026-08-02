import 'package:alchemist/alchemist.dart';
import 'package:dotdart_example/gen/lotties.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cataqui job cards carousel golden tests', () {
    goldenTest(
      'when rendering representative cards, it should preserve maps and editable text',
      fileName: 'job_cards_carousel_frames',
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(width: 458, height: 540),
        children: [
          GoldenTestScenario(
            name: 'first card',
            child: ColoredBox(
              color: Colors.black,
              child: Center(
                child: $Lotties.cataquiJobCardsCarousel(
                  width: 458,
                  progress: 0,
                  overrides: const CataquiJobCardsCarouselOverrides(
                    jobCard01TextJobTitleText: 'Garçom para evento',
                    jobCard02TextJobTitleText: 'Cozinheiro para jantar',
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'compound map card',
            child: ColoredBox(
              color: Colors.black,
              child: Center(
                child: $Lotties.cataquiJobCardsCarousel(
                  width: 458,
                  progress: 1 / 6,
                  overrides: const CataquiJobCardsCarouselOverrides(
                    jobCard02TextJobTitleText: 'Cozinheiro para jantar',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when toggling canvas clipping, it should preserve the requested edge behavior',
      fileName: 'job_cards_carousel_clipping',
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(width: 458, height: 540),
        children: [
          GoldenTestScenario(
            name: 'default clipping',
            child: ColoredBox(
              color: Colors.red,
              child: Center(child: $Lotties.cataquiJobCardsCarousel(width: 220, progress: 0)),
            ),
          ),
          GoldenTestScenario(
            name: 'clipping disabled',
            child: ColoredBox(
              color: Colors.red,
              child: Center(child: $Lotties.cataquiJobCardsCarousel(width: 220, progress: 0, clip: false)),
            ),
          ),
        ],
      ),
    );
  });
}
