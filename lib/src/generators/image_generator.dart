// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import '../models/raster_image.dart';
import '../parsers/raster/thumbhash.dart';
import 'accessor_param.dart';
import 'naming.dart';

/// Generates a self-contained Dart `StatelessWidget` from a [RasterImage]
/// model, producing an optimized `Image.asset` widget with embedded metadata,
/// decode-time downsampling, and thumbhash placeholder.
class ImageGenerator {
  ImageGenerator(this.model, this.sourcePath);

  final RasterImage model;
  final String sourcePath;

  /// Default logical width used when no display dimensions are provided.
  static const defaultWidth = 280;

  /// Returns the constructor parameters of the generated image widget.
  List<AccessorParam> get params => [
    const AccessorParam(name: 'key', type: 'Key?'),
    const AccessorParam(name: 'width', type: 'double?', documentation: 'Width in logical pixels.'),
    const AccessorParam(name: 'height', type: 'double?', documentation: 'Height in logical pixels.'),
    const AccessorParam(name: 'fit', type: 'BoxFit?', documentation: 'How to inscribe the image in its bounds.'),
    const AccessorParam(
      name: 'alignment',
      type: 'AlignmentGeometry',
      defaultValue: 'Alignment.center',
      documentation: 'Alignment within the widget bounds.',
    ),
    const AccessorParam(name: 'color', type: 'Color?', documentation: 'A color to blend with the image.'),
    const AccessorParam(
      name: 'colorBlendMode',
      type: 'BlendMode?',
      documentation: 'The blend mode applied when color is set.',
    ),
  ];

  /// Generates the widget class source fragment (no header/imports).
  String generateWidgetClass() {
    final b = StringBuffer();
    _writeWidgetClass(b);
    return b.toString();
  }

  String get widgetClassName => '_${Naming.widgetClassName(sourcePath)}';

  void _writeWidgetClass(StringBuffer b) {
    final name = widgetClassName;
    final formatName = _formatName();
    final hexColor = _dominantColorHex();
    final assetPath = sourcePath;
    final decodedThumbhash = model.thumbhash.isEmpty
        ? (width: 0, height: 0, pixels: <int>[])
        : ThumbhashDecoder.decode(model.thumbhash);
    final thumbhashColors = <int>[];
    for (var index = 0; index < decodedThumbhash.pixels.length; index += 4) {
      thumbhashColors.add(
        decodedThumbhash.pixels[index + 3] << 24 |
            decodedThumbhash.pixels[index] << 16 |
            decodedThumbhash.pixels[index + 1] << 8 |
            decodedThumbhash.pixels[index + 2],
      );
    }

    b.writeln('/// A dotdart-generated image widget from `$assetPath`.');
    b.writeln('///');
    b.writeln(
      '/// Intrinsic ${model.intrinsicWidth}×${model.intrinsicHeight} · $formatName · aspect ${model.aspectRatio.toStringAsFixed(4)}.',
    );
    b.writeln('/// Decodes at display size × device pixel ratio for minimal memory.');
    b.writeln('/// Renders a thumbhash placeholder in frame 1, then swaps to the image.');
    b.writeln('class $name extends StatelessWidget {');
    b.writeln('  const $name({');
    for (final param in params) {
      b.writeln('    ${param.constructorInitializer},');
    }
    b.writeln('  });');
    b.writeln();
    for (final param in params) {
      final fieldDeclaration = param.fieldDeclaration;
      if (fieldDeclaration == null) continue;
      b.write(fieldDeclaration);
      b.writeln();
    }

    b.writeln('  static const double _aspectRatio = ${_fmt(model.aspectRatio)};');
    b.writeln('  static const Color _dominantColor = Color($hexColor);');
    b.writeln('  static const int _thumbhashWidth = ${decodedThumbhash.width};');
    b.writeln('  static const int _thumbhashHeight = ${decodedThumbhash.height};');
    b.writeln('  static const List<Color> _thumbhashPixels = <Color>[');
    for (final color in thumbhashColors) {
      b.writeln('    Color(${_colorHex(color)}),');
    }
    b.writeln('  ];');
    b.writeln('  static final _frameBuilder = _dotdartImageFrameBuilder(');
    b.writeln('    _thumbhashWidth,');
    b.writeln('    _thumbhashHeight,');
    b.writeln('    _thumbhashPixels,');
    b.writeln('    _dominantColor,');
    b.writeln('  );');
    b.writeln("  static const String _assetPath = '$assetPath';");
    b.writeln();

    b.writeln('  @override');
    b.writeln('  Widget build(BuildContext context) {');
    b.writeln('    final dpr = MediaQuery.devicePixelRatioOf(context);');
    b.writeln('    const aspect = _aspectRatio;');
    b.writeln('    final w = width ?? (height != null ? height! * aspect : $defaultWidth.0);');
    b.writeln('    final h = height ?? w / aspect;');
    b.writeln();
    b.writeln('    final image = Image.asset(');
    b.writeln('      _assetPath,');
    b.writeln('      key: key,');
    b.writeln('      width: w,');
    b.writeln('      height: h,');
    b.writeln('      fit: fit,');
    b.writeln('      alignment: alignment,');
    b.writeln('      color: color,');
    b.writeln('      colorBlendMode: colorBlendMode,');
    b.writeln('      gaplessPlayback: true,');
    b.writeln('      filterQuality: FilterQuality.low,');
    b.writeln('      cacheWidth: (w * dpr).ceil(),');
    b.writeln('      cacheHeight: (h * dpr).ceil(),');
    b.writeln('      frameBuilder: _frameBuilder,');
    b.writeln('    );');
    b.writeln();
    b.writeln('    return RepaintBoundary(child: image);');
    b.writeln('  }');
    b.writeln('}');
    b.writeln();
  }

  String _formatName() {
    return switch (model.format) {
      RasterImageFormat.webp => 'WebP',
      RasterImageFormat.png => 'PNG',
      RasterImageFormat.jpeg => 'JPEG',
      RasterImageFormat.gif => 'GIF',
    };
  }

  String _dominantColorHex() {
    return _colorHex(model.dominantColor);
  }

  String _colorHex(int color) {
    final a = (color >> 24) & 0xFF;
    final r = (color >> 16) & 0xFF;
    final g = (color >> 8) & 0xFF;
    final b = color & 0xFF;
    return '0x${a.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${r.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${g.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  String _fmt(double v) {
    if (v == v.roundToDouble() && v.abs() < 1e10) {
      return v.toInt().toString();
    }
    return v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
