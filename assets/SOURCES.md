# 에셋 출처

그림 파일은 전달받은 묶음에서 가져왔다. 출처와 라이선스는 아직 확인되지 않았다.
확인 전에는 이 그림들을 앱 밖으로 따로 재배포하지 않는다.

## 배경 `images/home_background.png`

- 원본: `background.png` (1024×576)
- 출처: TBD
- 라이선스: TBD

## 아바타 `images/avatar_wizard.png`

- 원본: `avatars_wizards.png` (마법사 4명, 2×2)
- 오른쪽 위 빨간 마법사만 잘라 투명 PNG로 저장했다.
- 출처: TBD
- 라이선스: TBD

## 코인 `images/coin.png`

- 원본: `coin.aseprite` (16×16)
- PNG로 변환해 사용한다.
- 출처: TBD
- 라이선스: TBD

## 동전 효과음 `sounds/coin.wav`

- 원본 파일: `handleCoins2.ogg`
- 만든 사람: Kenney (https://kenney.nl)
- 묶음: RPG Audio
- 주소: https://kenney.nl/assets/rpg-audio
- 라이선스: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/)
- 개인·교육·상업 프로젝트에 쓸 수 있다. 크레딧은 필수는 아니다.
- 브라우저에서도 재생되도록 ogg를 wav(모노, 44100Hz)로 바꿨다.

## 픽셀 아이콘 `icons/`

- 출처: Nikoichu 1-bit icon pack, CC0
- 16×16. 흰 속과 검은 테두리를 앱 색으로 다시 칠해 쓴다. 파일 자체는 원본 그대로다.
- 하단 탭: 집, 사람, 달력, 톱니. 기록 탭은 클립보드보다 달력이 더 잘 보여 달력을 썼다.
- 스탯: 주먹(힘), 뇌(지능), 전구(지혜). 더하기와 닫기(X), 빈 화면의 두루마리도 이 팩이다.
- 체크할 때 커지는 별은 `RPG_Stat_MP_Mana_Star`다. 금색 `#C9A227`.
- 코인은 이 팩 대신 `images/coin.png`(aseprite 변환본)를 쓴다.
- 종 아이콘은 알림용이라 이번에는 넣지 않았다.

## 레이어 아바타 `avatar/`, `items/`, `pets/`, `backgrounds/`

홈의 빨간 마법사 대신 Kenney 맨몸 위에 장비 레이어를 쌓는다. 쓴 파일만 복사했다.

### 맨몸 `avatar/base.png`

- 원본 시트: Kenney Roguelike Characters `kenney_roguelikeChar_transparent.png`
- 왼쪽 위 16×16 칸(맨몸)만 잘랐다. 장비 레이어와 같은 칸에 겹친다.
- 만든 사람: Kenney (https://kenney.nl/assets/roguelike-characters)
- 라이선스: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/)

### 장비 `items/tops|bottoms|weapons/`

- 같은 Kenney 시트의 16×16 레이어. 상의 8, 하의 7, 무기 7.
- 라이선스: CC0 1.0

### 펫 `pets/`

- `pet_cat_spring_native.png` (40×40), `pet_dog_spring_native.png` (32×32)
- 만든 사람: Spring Spring
- 주소: https://opengameart.org/content/catto-and-doogydooge
- 라이선스: CC0
- `pet_cat_bonzille.png`, `pet_dog_bonzille.png`
- 만든 사람: bonzille
- 주소: https://opengameart.org/content/pixel-art-dog-and-cat
- 라이선스: CC0
- `pet_dog_shepard_native.png` (15×10, 앉은 첫 장면)
- 만든 사람: Shepardskin
- 주소: https://opengameart.org/content/dog-sprites
- 라이선스: CC0
- 같은 그림의 128 확대본은 상점에 또 올리지 않았다.

### 배경 `backgrounds/`

- `shop_bg_fantasy_castle.png`, `shop_bg_fantasy_castle2.png` (1024×576)
- 만든 사람: titi_son
- 주소: https://opengameart.org/content/fantasy-background
- 라이선스: CC0
- `shop_bg_desert.png` (1024×576)
- 만든 사람: Cethiel
- 주소: https://opengameart.org/content/desert-background-0
- 라이선스: CC0
- `shop_bg_mountain.png` (1024×576)
- 만든 사람: GrumpyDiamond
- 주소: https://opengameart.org/content/parallax-mountain-background
- 프로필: http://opengameart.org/users/grumpydiamond
- 라이선스: 묶음 안 라이선스 파일은 **CC-BY-3.0**. 크레딧을 남긴다.
- 라이선스 원문: `Parallax Mountain Background Licence cc-BY-3.0: Please let me know when you use this background in your project and credit 'GrumpyDiamond' and a link back to my profile http://opengameart.org/users/grumpydiamond`
- 기본 화면 배경은 이 파일들이 아니다. 아직 배경을 사지 않으면 기존 `images/home_background.png`를 쓴다.

## 구매 효과음 `sounds/purchase.ogg`

- 원본 파일: `handleCoins2.ogg` (0.338초로 자른 것)
- 만든 사람: Kenney (https://kenney.nl)
- 묶음: RPG Audio
- 주소: https://kenney.nl/assets/rpg-audio
- 라이선스: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/)
- 체크 때 나는 `sounds/coin.wav`와 같은 소리다. 구매는 ogg를 그대로 재생한다.

## 그 밖의 UI 그림과 글꼴

- RPG UI 팩: `assets/rpg_ui/LICENSE.txt`
- Pretendard, Galmuri: 각 폴더의 `OFL.txt`
