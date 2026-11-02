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

  /// [dark]를 옅게 풀어 카드 그림자에 쓴다.
  static const shadow = Color(0x1A1E1A2E);
}
