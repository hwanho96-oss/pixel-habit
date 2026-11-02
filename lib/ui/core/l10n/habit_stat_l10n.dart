import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';

extension HabitStatL10n on AppLocalizations {
  String habitStatLabel(HabitStat stat) {
    return switch (stat) {
      HabitStat.strength => statStrength,
      HabitStat.intelligence => statIntelligence,
      HabitStat.wisdom => statWisdom,
    };
  }
}
