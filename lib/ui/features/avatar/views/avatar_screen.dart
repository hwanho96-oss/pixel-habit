import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/widgets/avatar_view.dart';
import 'package:pixel_habit/ui/core/widgets/gold_badge.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:provider/provider.dart';

/// 아바타 탭. 상점과 성격 트리는 다음 단계다.
class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gold = context.watch<RoutineViewModel>().progress.gold;
    return Stack(
      fit: StackFit.expand,
      children: [
        const AvatarView(characterSize: 256),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GoldBadge(amount: gold),
            ),
          ),
        ),
      ],
    );
  }
}
