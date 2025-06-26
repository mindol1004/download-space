// 웹앱에서 web+magnet: 커스텀 스킴을 등록합니다.
if ('registerProtocolHandler' in navigator) {
  navigator.registerProtocolHandler(
    'web+magnet',
    window.location.origin + '/#/?magnet_url=%s',
    '토렌트 원격 제어 센터'
  );
} 