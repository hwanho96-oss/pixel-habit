import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 체크할 때 한 번 나는 동전 소리. 파일은 Kenney RPG Audio의 handleCoins2.
class CoinSound {
  AudioPlayer? _player;

  Future<void> play() async {
    // 위젯 테스트에는 소리 장치가 없어서 재생을 건너뛴다.
    if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
      return;
    }
    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource('sounds/coin.wav'));
    } catch (error) {
      debugPrint('coin sound skipped: $error');
    }
  }

  Future<void> dispose() async {
    final player = _player;
    _player = null;
    await player?.dispose();
  }
}
