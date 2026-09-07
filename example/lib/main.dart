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

class DotdartExamplePage extends StatefulWidget {
  const DotdartExamplePage({super.key});

  @override
  State<DotdartExamplePage> createState() => _DotdartExamplePageState();
}

class _DotdartExamplePageState extends State<DotdartExamplePage> {
  static const _cachedImageWidth = 96.0;

  var _showCachedImage = false;

  Future<void> _precacheAndShowImage() async {
    await $ImagesCache.precacheCataqui(context, width: _cachedImageWidth);
    if (!mounted) return;
    setState(() => _showCachedImage = true);
  }

  Future<void> _hideAndRemoveImage() async {
    setState(() => _showCachedImage = false);
    await $ImagesCache.removeCataqui(context, width: _cachedImageWidth);
  }

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
            label: 'SVG semantic colors and nested groups',
            child: $Icons.nestedGroups(
              width: 80,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              outlineColor: Theme.of(context).colorScheme.primary,
              innerTextColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            label: 'SVG by filename',
            child: $Icons.findByName('cross.svg', width: 64) ?? const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            label: 'Lottie compiled to CustomPainter',
            child: $Lotties.pulse(
              width: 96,
              playback: LottiePlayback.loop,
              overrides: PulseOverrides(fixtureColor: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            label: 'Animated Lottie trim path',
            child: $Lotties.trimPath(
              width: 100,
              delay: const Duration(milliseconds: 300),
              duration: const Duration(seconds: 2),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            label: 'Editable Lottie text and named colors',
            child: Center(
              child: $Lotties.cataquiJobCardsCarousel(
                clip: false,
                playback: LottiePlayback.loop,
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
          _ExampleCard(
            label: 'Per-asset image cache',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_showCachedImage) $Images.cataqui(width: _cachedImageWidth),
                if (_showCachedImage) const SizedBox(width: 16),
                FilledButton(
                  onPressed: _showCachedImage ? _hideAndRemoveImage : _precacheAndShowImage,
                  child: Text(_showCachedImage ? 'Remove from cache' : 'Precache and show'),
                ),
              ],
            ),
          ),
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
