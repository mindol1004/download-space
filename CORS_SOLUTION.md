# CORS 문제 해결 방법

## 문제 설명

Flutter 웹 앱에서 Synology NAS나 qBittorrent 서버에 직접 접근할 때 CORS (Cross-Origin Resource Sharing) 정책 오류가 발생합니다.

## 해결 방법

### 1. 프록시 서버 사용 (권장)

#### 1.1 프록시 서버 설치 및 실행

```bash
# 의존성 설치
npm install

# 프록시 서버 실행
npm start
```

프록시 서버가 `http://localhost:3001`에서 실행됩니다.

#### 1.2 Flutter 앱 실행

```bash
flutter run -d chrome
```

### 2. 브라우저 확장 프로그램 사용

#### Chrome/Edge용 CORS 확장 프로그램

1. [CORS Unblock](https://chrome.google.com/webstore/detail/cors-unblock/lfhmikememgdcahcdlaciloancbhjino) 설치
2. 확장 프로그램 활성화
3. Flutter 앱 실행

#### Firefox용 CORS 확장 프로그램

1. [CORS Everywhere](https://addons.mozilla.org/en-US/firefox/addon/cors-everywhere/) 설치
2. 확장 프로그램 활성화
3. Flutter 앱 실행

### 3. 개발 서버에서 CORS 비활성화 (개발용)

#### Chrome에서 CORS 비활성화

```bash
# Windows
chrome.exe --disable-web-security --user-data-dir="C:/temp/chrome_dev"

# macOS
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev" --disable-web-security

# Linux
google-chrome --disable-web-security --user-data-dir="/tmp/chrome_dev"
```

## 프록시 서버 설정

프록시 서버는 다음 기능을 제공합니다:

- **Synology API**: `/api/synology/*` → `http://[target-server]/webapi/*`
- **qBittorrent API**: `/api/qbittorrent/*` → `http://[target-server]/api/v2/*`
- **CORS 헤더 자동 추가**
- **에러 로깅**

## 환경별 동작

### 웹 환경 (Chrome, Firefox, Safari)

- 프록시 서버를 통해 요청
- CORS 문제 해결

### 네이티브 환경 (Android, iOS, Windows, macOS, Linux)

- 직접 서버에 연결
- CORS 문제 없음

## 문제 해결

### 프록시 서버가 실행되지 않는 경우

1. Node.js가 설치되어 있는지 확인
2. 포트 3001이 사용 중인지 확인
3. 방화벽 설정 확인

### 여전히 CORS 오류가 발생하는 경우

1. 프록시 서버가 실행 중인지 확인
2. 브라우저 캐시 삭제
3. 브라우저 확장 프로그램 사용

## 보안 주의사항

- 프록시 서버는 개발 목적으로만 사용하세요
- 프로덕션 환경에서는 적절한 CORS 설정을 서버에서 구성하세요
- 민감한 정보가 프록시 서버를 통해 전송될 수 있으므로 주의하세요
