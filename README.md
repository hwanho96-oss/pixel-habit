# Pixel Habit

판타지·픽셀 아트 세계관의 게이미피케이션 습관 트래커입니다. Android에서 쓰고, 브라우저에서 프로토타입을 볼 수 있습니다.

## 현재 구현

- 하단 4개 탭: 홈, 아바타, 기록, 설정
- **홈**: 위에는 배경과 아바타, 골드, 힘·지능·지혜 범례, 레벨. 아래 어두운 패널에서 루틴과 할 일(투두)을 바꾼다. 체크하면 골드 10이 오르고, 짧게 반짝인 뒤 동전 소리가 난다.
- **할 일**: 이름, 날짜, 시간(선택). 예전에 저장한 할 일에 시간이 없어도 그대로 열린다.
- **아바타**, **기록**: 아직 비어 있다. 기록에는 다음에 캘린더가 들어온다.
- **설정**: 그림과 효과음 크레딧.
- 긴 글은 Pretendard, 레벨·골드·숫자는 Galmuri.

## 실행

Android:

```bash
flutter pub get
flutter run
```

Android Studio에서는 이 폴더를 연 뒤 기기 또는 에뮬레이터를 선택하고 Run을 누르면 됩니다.

브라우저:

```bash
flutter pub get
flutter run -d chrome
```

넓은 창에서는 가운데에 휴대폰 너비로 맞춰 보여 줍니다. 릴리스 정적 파일은 `flutter build web --release`로 `build/web`에 만들어집니다.

`main`에 푸시하면 GitHub Actions가 웹 빌드를 만들어 GitHub Pages로 올리도록 설정되어 있습니다. 주소는 `https://hwanho96-oss.github.io/pixel-habit/` 입니다. 비공개 저장소에서 Pages를 쓰려면 GitHub Pro 이상이 필요하고, 저장소 Settings → Pages에서 Source를 GitHub Actions로 한 번 켜야 합니다.

## 크레딧

체크박스, 골드 배지, 등록 버튼에 쓰는 픽셀 그림은 Franuka의 [RPG UI pack (demo)](https://franuka.itch.io/rpg-ui-pack-demo)를 편집해 사용합니다. 상업적 사용과 편집은 허용되며, 팩을 그대로 다시 배포할 수는 없습니다. 라이선스 원문은 `assets/rpg_ui/LICENSE.txt`에 있습니다.

홈 배경, 빨간 마법사 아바타, 코인 그림의 출처는 아직 확인 전입니다. 메모는 `assets/SOURCES.md`에 있습니다.

동전 효과음은 Kenney의 [RPG Audio](https://kenney.nl/assets/rpg-audio) `handleCoins2`이며 CC0입니다. 앱 안에서는 설정 탭에서 크레딧을 볼 수 있습니다.

본문 글자는 [Pretendard](https://github.com/orioncactus/pretendard) (SIL Open Font License 1.1), 레벨·골드·숫자 같은 짧은 글자는 [Galmuri](https://github.com/quiple/galmuri) (SIL Open Font License 1.1)를 씁니다. 라이선스 원문은 `assets/fonts/pretendard/OFL.txt`, `assets/fonts/galmuri/OFL.txt`에 있습니다.
