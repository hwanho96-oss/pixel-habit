import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';

/// 스프라이트를 [FilterQuality.none]으로 9등분해서 그린다.
/// 모서리 픽셀은 고정하고 중앙만 늘려 픽셀이 뭉개지지 않게 한다.
class PixelNineSlice extends StatefulWidget {
  const PixelNineSlice({super.key, required this.slice, required this.child});

  final RpgSlice slice;
  final Widget child;

  @override
  State<PixelNineSlice> createState() => _PixelNineSliceState();
}

class _PixelNineSliceState extends State<PixelNineSlice> {
  ui.Image? _image;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load(widget.slice.path);
  }

  @override
  void didUpdateWidget(PixelNineSlice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slice.path != widget.slice.path) {
      _load(widget.slice.path);
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
          context: ErrorDescription('RPG UI 스프라이트를 그리는 중'),
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
    final image = _image;
    return CustomPaint(
      painter: image == null
          ? null
          : _NineSlicePainter(
              image: image,
              centerSlice: widget.slice.centerSlice,
            ),
      child: widget.child,
    );
  }
}

class _NineSlicePainter extends CustomPainter {
  const _NineSlicePainter({required this.image, required this.centerSlice});

  final ui.Image image;
  final Rect centerSlice;

  @override
  void paint(Canvas canvas, Size size) {
    final sourceWidth = image.width.toDouble();
    final sourceHeight = image.height.toDouble();
    final left = centerSlice.left;
    final top = centerSlice.top;
    final right = centerSlice.right;
    final bottom = centerSlice.bottom;
    final destLeft = left;
    final destTop = top;
    final destRight = size.width - (sourceWidth - right);
    final destBottom = size.height - (sourceHeight - bottom);
    if (destRight < destLeft || destBottom < destTop) {
      return;
    }

    final paint = Paint()
      ..filterQuality = FilterQuality.none
      ..isAntiAlias = false;

    void blit(Rect source, Rect dest) {
      if (source.isEmpty || dest.isEmpty) {
        return;
      }
      canvas.drawImageRect(image, source, dest, paint);
    }

    blit(
      Rect.fromLTRB(0, 0, left, top),
      Rect.fromLTRB(0, 0, destLeft, destTop),
    );
    blit(
      Rect.fromLTRB(left, 0, right, top),
      Rect.fromLTRB(destLeft, 0, destRight, destTop),
    );
    blit(
      Rect.fromLTRB(right, 0, sourceWidth, top),
      Rect.fromLTRB(destRight, 0, size.width, destTop),
    );
    blit(
      Rect.fromLTRB(0, top, left, bottom),
      Rect.fromLTRB(0, destTop, destLeft, destBottom),
    );
    blit(
      Rect.fromLTRB(left, top, right, bottom),
      Rect.fromLTRB(destLeft, destTop, destRight, destBottom),
    );
    blit(
      Rect.fromLTRB(right, top, sourceWidth, bottom),
      Rect.fromLTRB(destRight, destTop, size.width, destBottom),
    );
    blit(
      Rect.fromLTRB(0, bottom, left, sourceHeight),
      Rect.fromLTRB(0, destBottom, destLeft, size.height),
    );
    blit(
      Rect.fromLTRB(left, bottom, right, sourceHeight),
      Rect.fromLTRB(destLeft, destBottom, destRight, size.height),
    );
    blit(
      Rect.fromLTRB(right, bottom, sourceWidth, sourceHeight),
      Rect.fromLTRB(destRight, destBottom, size.width, size.height),
    );
  }

  @override
  bool shouldRepaint(covariant _NineSlicePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.centerSlice != centerSlice;
  }
}
