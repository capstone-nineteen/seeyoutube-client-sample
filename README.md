# seeyoutube-sample
전면카메라를 이용하여 시선 추적과 표정 분석을 구현한 토이프로젝트입니다.

[여기](https://please-amend.tistory.com/251)에 구현 과정이 소개되어 있습니다.

</br>

## 필요 사항

- **SeeSo SDK iOS 2.5.1 버전 & SeeSo 라이센스 키**

  - [SeeSo Console](https://manage.seeso.io/#/console/)에서 받을 수 있습니다.
  
- **iOS 13.0+, iPhone 6s+, 네트워크 연결된 실기기**

</br>

## 실행 방법

1. SeeYoutubeSample/SeeYoutubeSample/SeeSo.xcframework를 다운로드 받은 SeeSo.xcframework로 변경합니다.

![스크린샷 2022-11-26 오전 1 08 32](https://user-images.githubusercontent.com/70833900/204022493-0450b52a-bd9a-4fa4-96fa-00e659ad550a.png)

2. 아래와 같은 내용으로 LicenseKey.plist 파일을 생성합니다. "발급받은 라이센스키 입력" 부분을 실제 라이센스 키로 변경하세요.

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

3. 생성한 LicenseKey.plist 파일을 SeeYoutubeSample/SeeYoutubeSample/ 경로에 추가합니다.

![스크린샷](https://user-images.githubusercontent.com/70833900/204022983-ad840704-90d2-4734-a36e-dbd14ca87c1e.png)

</br>

## 외부 리소스 정보
- SeeSo iOS SDK 2.5.1

    - 시선 추적 구현에 사용하였습니다.
    
- [Pre-trained MiniXception 모델](https://github.com/oarriaga/face_classification/blob/master/trained_models/fer2013_mini_XCEPTION.119-0.65.hdf5)
    
    - Core ML 포맷으로 변환하여 표정 분석 구현에 사용하였습니다.
