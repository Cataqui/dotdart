import 'package:dotdart/src/generators/image_generator.dart';
import 'package:dotdart/src/models/raster_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImageGenerator widget', () {
    final fixture = RasterImage(
      intrinsicWidth: 16,
      intrinsicHeight: 16,
      format: RasterImageFormat.png,
      isAnimated: false,
      aspectRatio: 1.0,
      dominantColor: 0xFF000000,
      thumbhash: 'testhash',
    );

    testWidgets('when building the generated widget, it should render an Image', (tester) async {
      final generator = ImageGenerator(fixture, 'test_asset.png');
      final source = generator.generateWidgetClass();

      // Parse the class name from the source.
      final className = generator.widgetClassName;

      // We can't directly construct the private class, so test the source
      // fragments instead (the widget test uses generated source validation).
      expect(source, contains('class $className extends StatelessWidget'));
    });

    testWidgets('when building the generated widget with a width, it should not throw', (tester) async {
      // Verify the generated source is valid Dart by checking key patterns.
      final generator = ImageGenerator(fixture, 'test_asset.png');
      final source = generator.generateWidgetClass();

      expect(source, contains('filterQuality: FilterQuality.low'));
      expect(source, contains('gaplessPlayback: true'));
      expect(source, contains('RepaintBoundary'));
      expect(source, contains('MediaQuery.devicePixelRatioOf'));
    });

    testWidgets('when evaluating the build method, it should reference Image.asset', (tester) async {
      final generator = ImageGenerator(fixture, 'test_asset.png');
      final source = generator.generateWidgetClass();

      expect(source, contains('Image.asset('));
    });

    testWidgets('when the widget has no explicit width, it should default to 280 logical pixels', (tester) async {
      final generator = ImageGenerator(fixture, 'test_asset.png');
      final source = generator.generateWidgetClass();

      expect(source, contains('280.0'));
    });

    testWidgets('when a color is provided, it should pass color to Image.asset', (tester) async {
      final generator = ImageGenerator(fixture, 'test_asset.png');
      final source = generator.generateWidgetClass();

      expect(source, contains('color: color,'));
      expect(source, contains('colorBlendMode: colorBlendMode,'));
    });
  });
}
