import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/ui/core/widgets/web_phone_frame.dart';

void main() {
  group('WebPhoneFrame.shouldConstrain', () {
    test('넓은 웹 화면만 휴대폰 너비로 맞춘다', () {
      expect(
        WebPhoneFrame.shouldConstrain(isWeb: true, viewportWidth: 1280),
        isTrue,
      );
      expect(
        WebPhoneFrame.shouldConstrain(
          isWeb: true,
          viewportWidth: WebPhoneFrame.phoneWidth,
        ),
        isFalse,
      );
      expect(
        WebPhoneFrame.shouldConstrain(isWeb: true, viewportWidth: 360),
        isFalse,
      );
    });

    test('웹이 아니면 화면이 넓어도 프레임을 씌우지 않는다', () {
      expect(
        WebPhoneFrame.shouldConstrain(isWeb: false, viewportWidth: 1280),
        isFalse,
      );
      expect(
        WebPhoneFrame.shouldConstrain(
          isWeb: false,
          viewportWidth: double.infinity,
        ),
        isFalse,
      );
    });
  });
}
