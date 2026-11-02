import 'package:flutter/material.dart';

/// 화면에서 쓰는 색. 위젯에 색 값을 직접 적지 않고 이 상수만 쓴다.
///
/// [statStrength], [statIntelligence], [statWisdom]는 힘·지능·지혜 배지에 쓴다.
abstract final class AppColors {
  static const background = Color(0xFFF5EDE3);
  static const dark = Color(0xFF1E1A2E);
  static const accent = Color(0xFF6B4DE6);
  static const gold = Color(0xFFC9A227);
  static const text = Color(0xFF2C241B);
  static const textOnDark = Color(0xFFF7F3EE);
  static const border = Color(0xFFD8CFC4);

  static const statStrength = Color(0xFFE85D5D);
  static const statIntelligence = Color(0xFF5B8DEF);
  static const statWisdom = Color(0xFF6BCB77);

  /// 홈 아래 패널과 하단 탭. 시안의 남색이다.
  static const panel = Color(0xFF12182B);

  /// 패널 위의 퀘스트 카드.
  static const panelRaised = Color(0xFF1C2438);

  /// 패널 카드와 탭 구분선.
  static const panelBorder = Color(0xFF33405C);

  /// 패널 위에서 선택되지 않은 글자.
  static const panelMuted = Color(0xFF9AA6BD);

  /// [dark]를 옅게 풀어 카드 그림자에 쓴다.
  static const shadow = Color(0x1A1E1A2E);
}
