import 'package:flutter/material.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

/// 종합 탭에 두는 Franuka 팩 크레딧.
class RpgAssetCredit extends StatelessWidget {
  const RpgAssetCredit({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          l10n.assetCredit,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        SelectableText(
          l10n.assetCreditUrl,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
