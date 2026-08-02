import 'package:dotdart_example/gen/icons.g.dart';
import 'package:dotdart_example/gen/images.g.dart';
import 'package:dotdart_example/gen/lotties.g.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DotdartExampleApp());

class DotdartExampleApp extends StatelessWidget {
  const DotdartExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF4A4B)), useMaterial3: true),
      home: const DotdartExamplePage(),
    );
  }
}

class DotdartExamplePage extends StatelessWidget {
  const DotdartExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('dotdart')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ExampleCard(
            label: 'SVG compiled to Path',
            child: $Icons.cross(width: 64, color1: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            label: 'Lottie compiled to CustomPainter',
            child: $Lotties.pulse(
              width: 96,
              overrides: PulseOverrides(fixtureColor: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            label: 'Editable Lottie text and named colors',
            child: Center(
              child: $Lotties.cataquiJobCardsCarousel(
                clip: false,
                overrides: const CataquiJobCardsCarouselOverrides(
                  // postedTimeText: 'Agora',
                  // jobTitleText: 'Garçom para evento',
                  // jobTitleText2: 'Cozinheiro para jantar',
                  // jobTitleText3: 'Auxiliar de montagem',
                  // jobTitleText4: 'Recepcionista de evento',
                  // jobTitleText5: 'Fotógrafo por diária',
                  // jobTitleText6: 'Bartender para festa',
                  // payText: 'EUR 200/dia',
                  // payText2: 'TTT 33',
                  // descriptionText: 'Trabalho por três dias em um evento. Experiência com atendimento é bem-vinda.',
                  // payTextColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(label: 'Image with generated metadata', child: $Images.cataqui(width: 96)),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 120, child: Center(child: child)),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
