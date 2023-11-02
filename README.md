<img width="100%" height="45%" src="https://user-images.githubusercontent.com/83231344/200801447-24d5ceee-171c-4287-979a-1553b5a78570.png">


# 명식이 - 명지대의 식사를 책임지다! 👀
## 📌 Project Explanation 
* 명지대학교 인문캠퍼스에 MCC관이 생기면서 학식의 인기가 급증하였습니다. 학생들은 메뉴를 알기 위해 다른 커뮤니티를 참조하거나, 월요일 아침에 직접 가서 정보를 알아야만 했습니다. 따라서 명식이는 명지대학교 학생들의 편의를 제공하고자, 인문캠퍼스의 학식 정보를 제공하고, 맛을 평가하는 서비스입니다.

:rice: <b>오늘 식단 </b>: 오늘 하루의 식단 정보를 제공합니다.<br>
:bento: <b>주간 식단</b> : 이번 주 식단 정보를 제공합니다.<br>
:ramen: <b>맛 평가</b> : 오늘 식단에 대해서 맛을 평가합니다.<br>
:mailbox: <b>의견 작성</b> : 식단에 대한 구체적인 평가, 먹고싶은 음식 등 구체적인 의견을 작성할 수 있습니다.<br>
:information_desk_person: <b>식당, 카페 추천 맟 검색</b> : 학교 주변 식당, 카페를 추천받고, 검색할 수 있습니다.<br>
:cupid: <b>찜꽁리스트</b> : 맛있었던 곳을 찜꽁리스트에 저장할 수 있습니다.<br>

## 📌 Screen Shot
<p align="center">
<img src="https://github.com/MYONGSIK/iOS/assets/81149634/e5b31cd1-edfc-43f5-940f-6d136bc3485d" width="16%" height="30%">
<img src="https://github.com/MYONGSIK/iOS/assets/81149634/31145b8a-8fab-4188-9cd5-5f0360ee9920" width="16%" height="30%">
<img src="https://github.com/MYONGSIK/iOS/assets/81149634/ea11c3c6-3c5d-49fe-9f74-89065f62363f" width="16%" height="30%">
<img src="https://github.com/MYONGSIK/iOS/assets/81149634/9ae7ef81-bdd9-445d-818d-de935fb2d999" width="16%" height="30%">
<img src="https://github.com/MYONGSIK/iOS/assets/81149634/981147db-3559-4af0-8c57-41be552f9cd7" width="16%" height="30%">
<img src="https://github.com/MYONGSIK/iOS/assets/81149634/91ce0613-d8ca-4082-8160-6817c180b0c0" width="16%" height="30%">
</p>


## Tech Stack
### Language
<img src="https://img.shields.io/badge/swift-orange?style=for-the-badge&logo=swift&logoColor=white">

### Develop Tool
<img src="https://img.shields.io/badge/XCode-1da8e9?style=for-the-badge&logo=XCode&logoColor=white"> <img src="https://img.shields.io/badge/swagger-FF6C37?style=for-the-badge&logo=swagger&logoColor=white"> <img src="https://img.shields.io/badge/figma-25a183?style=for-the-badge&logo=figma&logoColor=white">  <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> <img src="https://img.shields.io/badge/Firebase-186ce0?style=for-the-badge&logo=Firebase&logoColor=white"> 

### SDK (Pod)
 <img src="https://img.shields.io/badge/Alamofire-FF6C37?style=for-the-badge&logo=Alamofire&logoColor=white"> <img src="https://img.shields.io/badge/Then-25a183?style=for-the-badge&logo=Then&logoColor=white">  <img src="https://img.shields.io/badge/Toast Swift-181717?style=for-the-badge&logo=Toast Swift&logoColor=white"> <img src="https://img.shields.io/badge/Realm-F05032?style=for-the-badge&logo=Realm&logoColor=white">  <img src="https://img.shields.io/badge/KakaoMapSDK-FF6C37?style=for-the-badge&logo=KakaoMapSDK&logoColor=white">  <img src="https://img.shields.io/badge/SnapKit-181717?style=for-the-badge&logo=SnapKit&logoColor=white"> <img src="https://img.shields.io/badge/GoogleAdMob-1da8e9?style=for-the-badge&logo=GoogleAdMob&logoColor=white"> 
<br> 
<br>


## Project Structure

<details>
<summary>App Details</summary>

```jsx
── Assets.xcassets
│   ├── AccentColor.colorset
│   │   └── Contents.json
│   ├── AppIcon.appiconset
│   │   ├── 100.png
│   │   ├── 1024.png
│   │   ├── 114.png
│   │   ├── 120.png
│   │   ├── 128.png
│   │   ├── 144.png
│   │   ├── 152.png
│   │   ├── 16.png
│   │   ├── 167.png
│   │   ├── 172.png
│   │   ├── 180.png
│   │   ├── 196.png
│   │   ├── 20.png
│   │   ├── 216.png
│   │   ├── 256.png
│   │   ├── 29.png
│   │   ├── 32.png
│   │   ├── 40.png
│   │   ├── 48.png
│   │   ├── 50.png
│   │   ├── 512.png
│   │   ├── 55.png
│   │   ├── 57.png
│   │   ├── 58.png
│   │   ├── 60.png
│   │   ├── 64.png
│   │   ├── 72.png
│   │   ├── 76.png
│   │   ├── 80.png
│   │   ├── 87.png
│   │   ├── 88.png
│   │   └── Contents.json
│   ├── BottomIcons
│   │   ├── Contents.json
│   │   ├── heart.imageset
│   │   │   ├── Contents.json
│   │   │   └── todayFood.svg
│   │   ├── map.imageset
│   │   │   ├── Contents.json
│   │   │   └── mapIcon.svg
│   │   ├── res.imageset
│   │   │   ├── Contents.json
│   │   │   └── res2.svg
│   │   └── todayFood.imageset
│   │       ├── Contents.json
│   │       └── heart.svg
│   ├── Contents.json
│   ├── Icons
│   │   ├── Contents.json
│   │   ├── arrow_bottom.imageset
│   │   │   ├── Contents.json
│   │   │   └── Vector 536.svg
│   │   ├── arrow_left.imageset
│   │   │   ├── Contents.json
│   │   │   └── ep_arrow-left.svg
│   │   ├── arrow_left_gray.imageset
│   │   │   ├── Contents.json
│   │   │   └── arrow_left_gray.svg
│   │   ├── arrow_right_blue.imageset
│   │   │   ├── Contents.json
│   │   │   └── arrow_right_blue.svg
│   │   ├── calendar.imageset
│   │   │   ├── Contents.json
│   │   │   └── calendar.svg
│   │   ├── check_blue.imageset
│   │   │   ├── Contents.json
│   │   │   └── check.blue.svg
│   │   ├── check_gray.imageset
│   │   │   ├── Contents.json
│   │   │   └── check.gray.svg
│   │   ├── custom_check.imageset
│   │   │   ├── Contents.json
│   │   │   └── custom_check.png
│   │   ├── empty_heart.imageset
│   │   │   ├── Contents.json
│   │   │   └── empty_heart.svg
│   │   ├── fill_heart.imageset
│   │   │   ├── Contents.json
│   │   │   └── fill_heart.svg
│   │   ├── pencil.imageset
│   │   │   ├── Contents.json
│   │   │   └── pencil.png
│   │   ├── phone.imageset
│   │   │   ├── Contents.json
│   │   │   └── phone.svg
│   │   ├── pin.imageset
│   │   │   ├── Contents.json
│   │   │   └── pin.svg
│   │   ├── resIcon_bakery.imageset
│   │   │   ├── Contents.json
│   │   │   └── resIcon_bakery.svg
│   │   ├── resIcon_cafe.imageset
│   │   │   ├── Contents.json
│   │   │   └── resIcon_cafe.svg
│   │   ├── resIcon_drink.imageset
│   │   │   ├── Contents.json
│   │   │   └── resIcon_drink.svg
│   │   ├── resIcon_meal.imageset
│   │   │   ├── Contents.json
│   │   │   └── resIcon_meal.svg
│   │   ├── search.imageset
│   │   │   ├── Contents.json
│   │   │   └── search.svg
│   │   ├── search_blue.imageset
│   │   │   ├── Contents.json
│   │   │   └── search_blue.svg
│   │   ├── search_white.imageset
│   │   │   ├── Contents.json
│   │   │   └── search_white.svg
│   │   ├── thumbdown.imageset
│   │   │   ├── Contents.json
│   │   │   └── thumbdown.svg
│   │   ├── thumbdown_blue.imageset
│   │   │   ├── Contents.json
│   │   │   └── thumbdown_blue.svg
│   │   ├── thumbup.imageset
│   │   │   ├── Contents.json
│   │   │   └── thumbup.svg
│   │   ├── thumbup_blue.imageset
│   │   │   ├── Contents.json
│   │   │   └── thumbup_blue.svg
│   │   ├── update_map.imageset
│   │   │   ├── Contents.json
│   │   │   └── update_map.svg
│   │   └── update_widget.imageset
│   │       ├── Contents.json
│   │       └── widget.svg
│   ├── Images
│   │   ├── Contents.json
│   │   ├── mainTopBackImg.imageset
│   │   │   ├── Contents.json
│   │   │   └── mainTopImg.svg
│   │   └── seperatorLine.imageset
│   │       ├── Contents.json
│   │       └── seperatorLine.svg
│   ├── Logo
│   │   ├── Contents.json
│   │   ├── logo.imageset
│   │   │   ├── Contents.json
│   │   │   └── logo.svg
│   │   └── mainTopLogo.imageset
│   │       ├── Contents.json
│   │       └── mainTopLogo.svg
│   ├── Map
│   │   ├── Contents.json
│   │   ├── heartButton.imageset
│   │   │   ├── Contents.json
│   │   │   ├── haertButton@2x.png
│   │   │   ├── haertButton@3x.png
│   │   │   └── heartButton.png
│   │   ├── heartFillButton.imageset
│   │   │   ├── Contents.json
│   │   │   ├── heartFillButton.png
│   │   │   ├── heartFillButton@2x.png
│   │   │   └── heartFillButton@3x.png
│   │   ├── mapPin.imageset
│   │   │   ├── Contents.json
│   │   │   └── Union.png
│   │   ├── phoneButton.imageset
│   │   │   ├── Contents.json
│   │   │   ├── phoneButton.png
│   │   │   ├── phoneButton@2x.png
│   │   │   └── phoneButton@3x.png
│   │   └── selectedMapPin.imageset
│   │       ├── Contents.json
│   │       └── Group 14108 (1).svg
│   └── Splash
│       ├── Contents.json
│       ├── splash.imageset
│       │   ├── Contents.json
│       │   └── splash.svg
│       └── splashTitle.imageset
│           ├── Contents.json
│           └── splashLogo.svg
├── GoogleService-Info.plist
├── Info.plist
├── MYONGSIK.entitlements
├── Resource
│   ├── Enum
│   │   └── Restaurant.swift
│   ├── Extensions
│   │   ├── CALayer+.swift
│   │   ├── CGFloat+.swift
│   │   ├── NSMutableAttributedString+.swift
│   │   ├── String+.swift
│   │   └── UserDefaults+.swift
│   ├── Support
│   │   ├── AppDelegate.swift
│   │   ├── GoogleMobileAdsController.swift
│   │   ├── GoogleMobileAdsKey.swift
│   │   ├── InfoPlist
│   │   │   ├── en.lproj
│   │   │   │   └── InfoPlist.strings
│   │   │   └── ko.lproj
│   │   │       └── InfoPlist.strings
│   │   ├── RegisterUUID.swift
│   │   └── SceneDelegate.swift
│   └── UI
│       ├── Fonts
│       │   ├── NotoSansKR-Bold.otf
│       │   ├── NotoSansKR-Light.otf
│       │   ├── NotoSansKR-Regular.otf
│       │   └── UIFont.swift
│       ├── PaddingLabel.swift
│       ├── UIColor.swift
│       ├── UIDevice.swift
│       ├── UIResponder+.swift
│       └── UITextField.swift
└── Source
    ├── Data
    │   ├── Network
    │   │   ├── APIManager.swift
    │   │   ├── APIModel.swift
    │   │   └── Constants.swift
    │   └── Services
    │       ├── HeartService
    │       │   └── HeartService.swift
    │       ├── KakaoMapService
    │       │   └── KakaoMapDataManager.swift
    │       └── MainService
    │           └── MainService.swift
    ├── Domain
    │   └── Entity
    │       ├── DayFoodModel.swift
    │       ├── HeartListData.swift
    │       ├── KakaoMapModel.swift
    │       ├── MindFoodModel.swift
    │       ├── StoreModel.swift
    │       ├── SubmitData.swift
    │       └── UserModel.swift
    └── Presentation
        ├── Heart
        │   ├── Cells
        │   │   └── HeartListTableViewCell.swift
        │   └── ViewControllers
        │       └── HeartViewController.swift
        ├── Launch
        │   ├── Splash
        │   │   ├── CampusSetPopupViewController.swift
        │   │   └── SplashViewController.swift
        │   └── View
        │       └── Base.lproj
        │           ├── LaunchScreen.storyboard
        │           └── Main.storyboard
        ├── Main
        │   ├── Cells
        │   │   ├── FoodInfoCell.swift
        │   │   ├── PageCell.swift
        │   │   ├── RestaurantSelectCell.swift
        │   │   └── SettingResTableViewCell.swift
        │   ├── ViewControllers
        │   │   ├── MainViewController.swift
        │   │   ├── SelectRestaurantViewController.swift
        │   │   ├── SettingRestautrantViewController.swift
        │   │   ├── SubmitViewController.swift
        │   │   └── UpdateBottomAlertViewController.swift
        │   ├── ViewModel
        │   │   └── MainViewModel.swift
        │   └── ViewModels
        │       └── SubmitViewController.swift
        ├── Map
        │   └── ViewController
        │       ├── MapStoreView.swift
        │       └── MapViewController.swift
        ├── Restaurant
        │   ├── Cells
        │   │   ├── SearchResultTableViewCell.swift
        │   │   ├── TagCollectionViewCell.swift
        │   │   └── TagTableViewCell.swift
        │   └── ViewControllers
        │       ├── RestaurantMainViewController.swift
        │       ├── RestaurantSearchViewController.swift
        │       ├── RestaurantTagViewController.swift
        │       └── WebViewController.swift
        └── Utils
            ├── BaseViewController.swift
            ├── FormatManager.swift
            ├── MainBaseViewController.swift
            ├── PopupBaseVIewController.swift
            ├── ScreenManager.swift
            ├── TabBarViewController.swift
            └── ToastBar.swift
```
<br>
</details>

<details>
<summary>Widget Details</summary>

```jsx
├── Assets.xcassets
│   ├── AccentColor.colorset
│   │   └── Contents.json
│   ├── AppIcon.appiconset
│   │   └── Contents.json
│   ├── Contents.json
│   ├── WidgetBackground.colorset
│   │   └── Contents.json
│   └── separator.imageset
│       ├── Contents.json
│       └── separator.svg
├── DailyFoodWidget.swift
├── DailyFoodWidgetBundle.swift
└── Info.plist
```
<br>
</details>
<br><br>


## iOS Architecture 
<details>
<summary>MVC Pattern</summary>
  - 짧은 개발 시간으로 직관적인 MVC 패턴을 사용하여 개발했습니다.
  - 기능 추가 및 삭제 등 유지보수에 UI 로직과 비즈니스 로직이 결합되어 유지보수성이 떨어진다고 판단, Combine을 사용해 MVVM 패턴으로 마이그레이션 진행중입니다.
  <p align="center">
  <img src="https://github.com/MYONGSIK/iOS/assets/81149634/1ec53fbb-6529-401b-9841-e5018736a8a9" width="45%" height="30%">
  ->
  <img src="https://github.com/MYONGSIK/iOS/assets/81149634/02d9e15f-84e6-4bc3-b3ee-8ad64198f3a1" width="45%" height="30%">
  </p>
<br>
</details>
<br>

## Commit/PR Convention
**Commit**
```
#1 feat: 일정 등록 API 추가
```
- #이슈번호 타입: 커밋 설명
<br>

**Pull Request**
```
[feature/1-create-calender] 일정 등록
```
- [브랜치명]  설명
<br>

## Branch Strategy
- main
    - 배포 이력 관리 목적
- develop
    - feature 병합용 브랜치
    - 배포 전 병합 브랜치
- feature
    - develop 브랜치를 베이스로 기능별로 feature 브랜치 생성해 개발
- test
    - 테스트가 필요한 코드용 브랜치
- fix
    - 배포 후 버그 발생 시 버그 수정 
<br>

- feature branch의 경우, 기능명/이슈번호-기능설명 형태로 작성
```md
feature/7-desserts-patchDessert
```
<br>

<br>
<br>
