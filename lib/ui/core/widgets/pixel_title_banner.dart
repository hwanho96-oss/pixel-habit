import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/rpg_ui_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_nine_slice.dart';

/// 섹션·화면 제목용 타이틀 배너. 높이는 스프라이트 원본을 유지한다.
class PixelTitleBanner extends StatelessWidget {
  const PixelTitleBanner({
    super.key,
    required this.title,
    required this.slice,
    this.textStyle,
    this.expandWidth = false,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.height,
  });

  final String title;
  final RpgSlice slice;
  final TextStyle? textStyle;
  final bool expandWidth;

  /// 리본처럼 아래쪽에 꼬리가 있으면 글자를 위쪽으로 올린다.
  final Alignment alignment;

  /// 프레임 안쪽 추가 여백. 좌우 캡 두께에 더해진다.
  final EdgeInsets padding;

  /// 배너 높이. 비우면 스프라이트 원본 높이를 쓴다.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final caps = slice.capInsets;
    final text = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: textStyle,
    );

    return SizedBox(
      height: height ?? slice.height,
      width: expandWidth ? double.infinity : null,
      child: PixelNineSlice(
        slice: slice,
        child: Padding(
          padding:
              EdgeInsets.only(left: caps.left, right: caps.right) + padding,
          child: Align(
            alignment: alignment,
            widthFactor: expandWidth ? null : 1,
            child: text,
          ),
        ),
      ),
    );
  }
}
