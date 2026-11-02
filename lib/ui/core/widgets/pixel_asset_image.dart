import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 에셋 PNG를 최근접 이웃으로 그린다. 픽셀 폰트와 같은 격자를 유지한다.
class PixelAssetImage extends StatefulWidget {
  const PixelAssetImage({
    super.key,
    required this.path,
    this.width,
    this.height,
  });

  final String path;
  final double? width;
  final double? height;

  @override
  State<PixelAssetImage> createState() => _PixelAssetImageState();
}

class _PixelAssetImageState extends State<PixelAssetImage> {
  ui.Image? _image;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load(widget.path);
  }

  @override
  void didUpdateWidget(PixelAssetImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _load(widget.path);
    }
  }

  Future<void> _load(String path) async {
    final request = ++_request;
    try {
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      codec.dispose();
      if (!mounted || request != _request) {
        frame.image.dispose();
        return;
      }
      final previous = _image;
      setState(() => _image = frame.image);
      previous?.dispose();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'pixel_habit',
          context: ErrorDescription('픽셀 이미지를 그리는 중'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: _image == null ? null : _PixelImagePainter(image: _image!),
      ),
    );
  }
}

class _PixelImagePainter extends CustomPainter {
  const _PixelImagePainter({required this.image});

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Offset.zero & size,
      Paint()
        ..filterQuality = FilterQuality.none
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(covariant _PixelImagePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
