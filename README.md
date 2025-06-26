# 토렌트 원격 제어 센터 (Torrent Remote Center)

Flutter 기반의 토렌트 원격 관리 애플리케이션입니다. Synology NAS와 qBittorrent 서버를 지원합니다.

## 주요 기능

- 🖥️ **다중 서버 지원**: Synology NAS, qBittorrent
- 📱 **크로스 플랫폼**: 웹, 데스크톱, 모바일 지원
- 🔗 **원격 제어**: 토렌트 추가, 삭제, 모니터링
- 📁 **다운로드 폴더 설정**: 서버별 다운로드 위치 지정
- 🌐 **다국어 지원**: 한국어, 영어
- 🔒 **연결 테스트**: 서버 연결 상태 확인

## 시작하기

### 1. 의존성 설치

```bash
flutter pub get
```

### 2. 웹 환경에서 CORS 문제 해결

웹 브라우저에서 실행할 때 CORS 정책 오류가 발생할 수 있습니다. 다음 방법 중 하나를 선택하세요:

#### 방법 1: 프록시 서버 사용 (권장)

```bash
# 프록시 서버 의존성 설치
npm install

# 프록시 서버 실행
npm start
# 또는 Windows: start-proxy.bat
# 또는 Linux/macOS: ./start-proxy.sh
```

#### 방법 2: 브라우저 확장 프로그램 사용

- **Chrome/Edge**: [CORS Unblock](https://chrome.google.com/webstore/detail/cors-unblock/lfhmikememgdcahcdlaciloancbhjino) 설치
- **Firefox**: [CORS Everywhere](https://addons.mozilla.org/en-US/firefox/addon/cors-everywhere/) 설치

### 3. 앱 실행

```bash
# 웹
flutter run -d chrome

# 데스크톱
flutter run -d windows
flutter run -d macos
flutter run -d linux

# 모바일
flutter run -d android
flutter run -d ios
```

## 사용법

1. **서버 추가**: 설정 → 서버 추가에서 토렌트 서버 정보 입력
2. **연결 테스트**: 서버 추가 시 연결 테스트 버튼으로 연결 확인
3. **다운로드 폴더 설정**: 서버별로 다운로드 위치 지정
4. **토렌트 추가**: 마그넷 링크 또는 토렌트 파일로 다운로드 추가
5. **모니터링**: 진행 상황, 속도, 상태 확인

## 지원하는 서버

### Synology NAS

- DSM 6.x 이상
- Download Station 패키지 필요
- 기본 포트: 5000 (HTTP), 5001 (HTTPS)

### qBittorrent

- qBittorrent 4.x 이상
- Web UI 활성화 필요
- 기본 포트: 8080

## 개발 환경

- Flutter 3.x
- Dart 3.x
- Node.js 16.x (프록시 서버용)

## 라이선스

MIT License

## 문제 해결

자세한 CORS 문제 해결 방법은 [CORS_SOLUTION.md](CORS_SOLUTION.md)를 참조하세요.
