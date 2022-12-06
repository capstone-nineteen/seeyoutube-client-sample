# seeyoutube-sample
전면카메라를 이용하여 시선 추적과 표정 분석을 구현한 토이프로젝트입니다. [여기](https://please-amend.tistory.com/251)에 구현 과정이 소개되어 있습니다.

</br>

## 프로젝트 소개
![움짤](https://blog.kakaocdn.net/dn/c7KzuX/btrR8JGbvAR/4tHfWXU5E4S2oTOU79fDW0/img.gif)
- 유튜브 영상 시청자의 시선과 표정을 분석합니다.
- 흰색 커서가 시선을 따라 움직입니다.
- 좌측에 카메라 프레임과 표정 분류 결과가 표시됩니다.

</br>

## 준비 사항

- SeeSo SDK iOS 2.5.1 버전 & SeeSo 라이센스 키

  - [SeeSo Console](https://manage.seeso.io/#/console/)에서 받을 수 있습니다.
  
- iOS 13.0+, iPhone 6s+, 네트워크 연결된 **실기기** (시뮬레이터 불가)

</br>

## 프로젝트 실행 환경
- MacOS
- Xcode

</br>

## 프로젝트 실행 방법

1. `SeeYoutubeSample/SeeYoutubeSample/SeeSo.xcframework`폴더를 다운로드 받은 SeeSo.xcframework 폴더로 변경합니다.![스크린샷 2022-11-26 오전 1 08 32](https://user-images.githubusercontent.com/70833900/204022493-0450b52a-bd9a-4fa4-96fa-00e659ad550a.png)

</br>

2. 아래와 같은 내용으로 `LicenseKey.plist` 파일을 생성합니다. "발급받은 라이센스키 입력" 부분을 실제 라이센스 키로 변경하세요.
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>SEESO_LICENSE_KEY</key>
        <string>발급받은 라이센스키 입력</string>
    </dict>
    </plist>
    ```

</br>

3. 생성한 `LicenseKey.plist` 파일을 `SeeYoutubeSample/SeeYoutubeSample/` 경로에 추가합니다.![스크린샷](https://user-images.githubusercontent.com/70833900/204022983-ad840704-90d2-4734-a36e-dbd14ca87c1e.png)

</br>

4. `SeeYoutubeSample/SeeYoutubeSample.xcodeproj`를 더블 클릭하여 Xcode에서 프로젝트를 엽니다.![스크린샷](https://user-images.githubusercontent.com/70833900/205860576-6e740272-f65b-4f5e-8217-8a0e7010fadc.png)

</br>

5. 빌드 가능하도록 실기기를 맥에 연결하고, 해당 기기에서 실행하도록 설정해줍니다. (연결 방법은 [여기](https://sweepty.medium.com/자신의-아이폰에-테스트-앱-올리기-54e07e17d3f7)를 참고)![스크린샷](https://user-images.githubusercontent.com/70833900/205860472-22eac15c-e1ac-4408-ad13-f8f8127c4efe.png)

</br>

6. `cmd + R`로 실행합니다. (만약 "신뢰할 수 없는 개발자" 경고가 뜨는 경우, 아이폰에서 [설정 > 일반 > VPN 및 기기관리 > 본인 계정 선택 > 신뢰])

	<image width=200 src=https://user-images.githubusercontent.com/70833900/205862966-572b54a2-90c4-4b3b-ab5f-debecd9d0c2e.jpeg>


</br>

## 외부 리소스 정보
- SeeSo iOS SDK 2.5.1

    - 시선 추적 구현에 사용하였습니다.
    
- [Pre-trained MiniXception 모델](https://github.com/oarriaga/face_classification/blob/master/trained_models/fer2013_mini_XCEPTION.119-0.65.hdf5)
    
    - Core ML 포맷으로 변환하여 표정 분석 구현에 사용하였습니다.
