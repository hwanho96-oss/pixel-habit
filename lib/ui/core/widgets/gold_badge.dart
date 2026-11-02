import 'package:flutter/material.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_coin.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_nine_slice.dart';

/// 골드 수치와 +획득 애니메이션. 픽셀 리본은 이 배지에만 포인트로 쓴다.
class GoldBadge extends StatefulWidget {
  const GoldBadge({super.key, required this.amount});

  final int amount;

  @override
  State<GoldBadge> createState() => _GoldBadgeState();
}

class _GoldBadgeState extends State<GoldBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final CurvedAnimation _scaleCurve;
  late final CurvedAnimation _fadeCurve;
  late final Animation<double> _scale;
  late final Animation<double> _gainOpacity;
  late final Animation<Offset> _gainRise;
  int? _gain;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleCurve = CurvedAnimation(parent: _pulse, curve: Curves.easeOut);
    _fadeCurve = CurvedAnimation(
      parent: _pulse,
      curve: const Interval(0.45, 1),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.08), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.08, end: 1), weight: 65),
    ]).animate(_scaleCurve);
    _gainOpacity = Tween<double>(begin: 1, end: 0).animate(_fadeCurve);
    _gainRise = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, -1.15),
    ).animate(_scaleCurve);
    _pulse.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted && _gain != null) {
        setState(() => _gain = null);
      }
    });
  }

  @override
  void didUpdateWidget(covariant GoldBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final gained = widget.amount - oldWidget.amount;
    if (gained > 0) {
      _gain = gained;
      _pulse.forward(from: 0);
    } else if (gained < 0) {
      _gain = null;
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _scaleCurve.dispose();
    _fadeCurve.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amountStyle = AppTheme.pixel(fontSize: 16);
    final slice = RpgUiAssets.bannerRibbon;

    return ScaleTransition(
      scale: _scale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_gain != null)
            SlideTransition(
              position: _gainRise,
              child: FadeTransition(
                opacity: _gainOpacity,
                child: Text(
                  l10n.goldGain(_gain!),
                  style: AppTheme.pixel(fontSize: 16),
                ),
              ),
            ),
          PixelNineSlice(
            slice: slice,
            child: Padding(
              padding:
                  slice.capInsets +
                  const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PixelCoin(size: 20),
                  const SizedBox(width: 4),
                  Text(l10n.goldAmount(widget.amount), style: amountStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
