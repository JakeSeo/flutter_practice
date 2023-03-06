# firebase_phone_auth_sample
Firebase Phone and Email Auth Sample
Used Provider

#### 셋업
~~~
flutter pub get
~~~

#### 파이어베이스 셋업 
참조: https://firebase.google.com/docs/flutter/setup?platform=android

~~~
% firebase login
% flutterfire config
~~~

파이어베이스 프로젝트 생성후 안드로이드앱에 디버그SHA1 키 값 추가 

###안드로이드 디버그키 구하는법

~~~
% cd android
% /.gradlew signingReport
~~~
