import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

/// 체크와 구매에 한 번 나는 동전 소리. 파일은 Kenney RPG Audio의 handleCoins2.
class CoinSound {
  static const purchaseAsset = 'sounds/purchase.ogg';

  AudioPlayer? _player;

  Future<void> play({String asset = 'sounds/coin.wav'}) async {
    // 위젯 테스트에는 소리 장치가 없어서 재생을 건너뛴다.
    if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
      return;
    }
    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource(asset));
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
