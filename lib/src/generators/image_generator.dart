// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import '../models/raster_image.dart';
import 'accessor_param.dart';
import 'naming.dart';

/// Generates a self-contained Dart `StatelessWidget` from a [RasterImage]
/// model, producing an optimized `Image.asset` widget with embedded metadata,
/// decode-time downsampling, and thumbhash placeholder.
class ImageGenerator {
  ImageGenerator(this.model, this.sourcePath);

  final RasterImage model;
  final String sourcePath;

  static const _defaultWidth = 280;

  /// Returns the constructor parameters of the generated image widget.
  List<AccessorParam> get params => [
    const AccessorParam(name: 'key', type: 'Key?'),
    const AccessorParam(name: 'width', type: 'double?'),
    const AccessorParam(name: 'height', type: 'double?'),
    const AccessorParam(name: 'fit', type: 'BoxFit?'),
    const AccessorParam(name: 'alignment', type: 'AlignmentGeometry', defaultValue: 'Alignment.center'),
    const AccessorParam(name: 'color', type: 'Color?'),
    const AccessorParam(name: 'colorBlendMode', type: 'BlendMode?'),
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

    b.writeln('/// A dotdart-generated image widget from `$assetPath`.');
    b.writeln('///');
    b.writeln('/// Intrinsic ${model.intrinsicWidth}×${model.intrinsicHeight} · $formatName · aspect ${model.aspectRatio.toStringAsFixed(4)}.');
    b.writeln('/// Decodes at display size × device pixel ratio for minimal memory.');
    b.writeln('/// Renders a thumbhash placeholder in frame 1, then crossfades to the image.');
    b.writeln('class $name extends StatelessWidget {');
    b.writeln('  const $name({');
    b.writeln('    super.key,');
    b.writeln('    this.width,');
    b.writeln('    this.height,');
    b.writeln('    this.fit,');
    b.writeln('    this.alignment = Alignment.center,');
    b.writeln('    this.color,');
    b.writeln('    this.colorBlendMode,');
    b.writeln('  });');
    b.writeln();

    b.writeln('  /// Width in logical pixels.');
    b.writeln('  final double? width;');
    b.writeln();
    b.writeln('  /// Height in logical pixels.');
    b.writeln('  final double? height;');
    b.writeln();
    b.writeln('  /// How to inscribe the image within [width] and [height].');
    b.writeln('  final BoxFit? fit;');
    b.writeln();
    b.writeln('  /// Alignment within the widget bounds.');
    b.writeln('  final AlignmentGeometry alignment;');
    b.writeln();
    b.writeln('  /// A color to blend the image with.');
    b.writeln('  final Color? color;');
    b.writeln();
    b.writeln('  /// The blend mode to apply when [color] is set.');
    b.writeln('  final BlendMode? colorBlendMode;');
    b.writeln();

    b.writeln('  static const int _intrinsicWidth = ${model.intrinsicWidth};');
    b.writeln('  static const int _intrinsicHeight = ${model.intrinsicHeight};');
    b.writeln('  static const double _aspectRatio = ${_fmt(model.aspectRatio)};');
    b.writeln('  static const bool _isAnimated = ${_boolLiteral(model.isAnimated)};');
    b.writeln('  static const Color _dominantColor = Color($hexColor);');
    b.writeln("  static const String _thumbhash = '${model.thumbhash}';");
    b.writeln("  static const String _assetPath = '$assetPath';");
    b.writeln("  static const String cacheKey = '$assetPath';");
    b.writeln();

    b.writeln('  @override');
    b.writeln('  Widget build(BuildContext context) {');
    b.writeln('    final dpr = MediaQuery.devicePixelRatioOf(context);');
    b.writeln('    final aspect = _aspectRatio;');
    b.writeln('    final w = width ?? (height != null ? height! / aspect : $_defaultWidth.0);');
    b.writeln('    final h = height ?? w * aspect;');
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
    b.writeln('      frameBuilder: _dotdartImageFrameBuilder(_thumbhash, _dominantColor),');
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
    final a = (model.dominantColor >> 24) & 0xFF;
    final r = (model.dominantColor >> 16) & 0xFF;
    final g = (model.dominantColor >> 8) & 0xFF;
    final b = model.dominantColor & 0xFF;
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

  String _boolLiteral(bool v) => v ? 'true' : 'false';
}
