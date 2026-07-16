import 'package:dotdart/src/generators/image_generator.dart';
import 'package:dotdart/src/models/raster_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImageGenerator', () {
    final fixture = RasterImage(
      intrinsicWidth: 1024,
      intrinsicHeight: 768,
      format: RasterImageFormat.webp,
      isAnimated: false,
      aspectRatio: 1024 / 768,
      dominantColor: 0xFF8A6D4B,
      thumbhash: 'testhash123',
    );

    test('when generating params, it should include all expected parameters', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final params = generator.params;

      expect(params.any((p) => p.name == 'key'), isTrue);
      expect(params.any((p) => p.name == 'width'), isTrue);
      expect(params.any((p) => p.name == 'height'), isTrue);
      expect(params.any((p) => p.name == 'fit'), isTrue);
      expect(params.any((p) => p.name == 'alignment'), isTrue);
      expect(params.any((p) => p.name == 'color'), isTrue);
      expect(params.any((p) => p.name == 'colorBlendMode'), isTrue);
      expect(params, hasLength(7));
    });

    test('when generating the widget class name, it should derive from the source path', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      expect(generator.widgetClassName, equals('_Cat'));
    });

    test('when generating widget class name with underscores, it should produce PascalCase', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/spilled_coffee.webp');
      expect(generator.widgetClassName, equals('_SpilledCoffee'));
    });

    test('when generating source, it should contain the widget class declaration', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('class _Cat extends StatelessWidget'));
    });

    test('when generating source, it should embed intrinsic dimensions', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('static const int _intrinsicWidth = 1024'));
      expect(source, contains('static const int _intrinsicHeight = 768'));
    });

    test('when generating source, it should embed the aspect ratio', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('static const double _aspectRatio'));
    });

    test('when generating source, it should embed the dominant color', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('static const Color _dominantColor = Color(0xFF8A6D4B)'));
    });

    test('when generating source, it should embed the thumbhash', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains("static const String _thumbhash = 'testhash123'"));
    });

    test('when generating source, it should embed the asset path', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains("static const String _assetPath = 'assets/three_d/cat.webp'"));
    });

    test('when generating source, it should embed the cache key', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains("static const String cacheKey = 'assets/three_d/cat.webp'"));
    });

    test('when generating source, it should set gaplessPlayback to true', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('gaplessPlayback: true'));
    });

    test('when generating source, it should use FilterQuality.low', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('filterQuality: FilterQuality.low'));
    });

    test('when generating source, it should compute cacheWidth and cacheHeight from width and dpr', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('cacheWidth: (w * dpr).ceil()'));
      expect(source, contains('cacheHeight: (h * dpr).ceil()'));
    });

    test('when generating source, it should wrap the image in a RepaintBoundary', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('RepaintBoundary'));
    });

    test('when generating source, it should reference the dotdart frame builder', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, contains('_dotdartImageFrameBuilder'));
    });

    test('when generating source for an animated image, _isAnimated should be true', () {
      final animatedFixture = fixture.copyWith(
        isAnimated: true,
        frameCount: 12,
        durationMs: 600,
      );
      final generator = ImageGenerator(animatedFixture, 'assets/three_d/animated.gif');
      final source = generator.generateWidgetClass();

      expect(source, contains('static const bool _isAnimated = true'));
    });

    test('when generating source for a static image, _isAnimated should be false', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/static.png');
      final source = generator.generateWidgetClass();

      expect(source, contains('static const bool _isAnimated = false'));
    });

    test('when generating source, it should not import the image package or dotdart', () {
      final generator = ImageGenerator(fixture, 'assets/three_d/cat.webp');
      final source = generator.generateWidgetClass();

      expect(source, isNot(contains("import 'package:image")));
    });
  });
}

extension on RasterImage {
  RasterImage copyWith({
    int? intrinsicWidth,
    int? intrinsicHeight,
    RasterImageFormat? format,
    bool? isAnimated,
    int? frameCount,
    int? durationMs,
    double? aspectRatio,
    int? dominantColor,
    String? thumbhash,
  }) {
    return RasterImage(
      intrinsicWidth: intrinsicWidth ?? this.intrinsicWidth,
      intrinsicHeight: intrinsicHeight ?? this.intrinsicHeight,
      format: format ?? this.format,
      isAnimated: isAnimated ?? this.isAnimated,
      frameCount: frameCount ?? this.frameCount,
      durationMs: durationMs ?? this.durationMs,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      dominantColor: dominantColor ?? this.dominantColor,
      thumbhash: thumbhash ?? this.thumbhash,
    );
  }
}
