// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '토렌트 매니저';

  @override
  String get downloadList => '다운로드 목록';

  @override
  String get serverManagement => '서버 관리';

  @override
  String get addServer => '서버 추가';

  @override
  String get editServer => '서버 수정';

  @override
  String get serverName => '서버 이름';

  @override
  String get serverType => '서버 타입';

  @override
  String get address => '주소';

  @override
  String get port => '포트';

  @override
  String get username => '사용자 이름';

  @override
  String get password => '비밀번호';

  @override
  String get add => '추가';

  @override
  String get edit => '수정';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get serverSelection => '서버 선택';

  @override
  String get noTorrentTasks => '토렌트 작업이 없습니다';

  @override
  String get noServers => '등록된 서버가 없습니다';

  @override
  String get status => '상태';

  @override
  String get progress => '진행률';

  @override
  String get addDownload => '다운로드 추가';

  @override
  String get errorOccurred => '에러가 발생했습니다';

  @override
  String get deleteServerConfirm => '서버 삭제';

  @override
  String deleteServerMessage(String serverName) {
    return '$serverName을(를) 삭제하시겠습니까?';
  }

  @override
  String get requiredField => '필수 입력 항목입니다.';

  @override
  String get language => '언어';

  @override
  String get korean => '한국어';

  @override
  String get english => '영어';

  @override
  String get settings => '설정';

  @override
  String get magnetLink => '마그넷 링크';

  @override
  String get enterMagnetLink => '마그넷 링크를 입력하세요.';

  @override
  String get addMagnet => '마그넷 추가';

  @override
  String get torrentFile => '.torrent 파일';

  @override
  String get selectServerFirst => '서버를 먼저 선택하세요.';

  @override
  String magnetAddFailed(String error) {
    return '마그넷 추가 실패: $error';
  }

  @override
  String fileAddFailed(String error) {
    return '파일 추가 실패: $error';
  }

  @override
  String get addFirstServer => '첫 번째 서버를 추가해보세요';

  @override
  String get or => '또는';

  @override
  String get addingDownload => '다운로드를 추가하는 중...';

  @override
  String get loadingTorrentList => '토렌트 목록을 불러오는 중...';

  @override
  String get addNewDownload => '새로운 다운로드를 추가해보세요';

  @override
  String get paste => '붙여넣기';

  @override
  String get selectFile => '파일 선택';

  @override
  String get torrentFileSelect => '토렌트 파일 선택';

  @override
  String get serverNameRequired => '서버 이름을 입력하세요';

  @override
  String get serverAddressRequired => '서버 주소를 입력하세요';

  @override
  String get portRequired => '포트 번호를 입력하세요';

  @override
  String get portMustBeNumber => '포트 번호는 숫자여야 합니다';

  @override
  String get portRangeError => '포트 번호는 1-65535 사이여야 합니다';

  @override
  String get downloadFolder => '다운로드 폴더';

  @override
  String get selectDownloadFolder => '다운로드 폴더 선택';

  @override
  String get testConnection => '연결 테스트';

  @override
  String get connectionSuccess => '연결 성공';

  @override
  String get connectionFailed => '연결 실패';

  @override
  String get selectFolderFirst => '먼저 다운로드 폴더를 선택하세요';

  @override
  String get corsError => 'CORS 오류가 발생했습니다';

  @override
  String get corsErrorDescription => '프록시 서버를 실행하거나 브라우저 확장 프로그램을 사용하세요';

  @override
  String get proxyServerNotRunning => '프록시 서버가 실행되지 않았습니다';

  @override
  String get proxyServerNotRunningDescription =>
      '프록시 서버를 먼저 실행해주세요 (npm start)';

  @override
  String get networkError => '네트워크 오류';

  @override
  String get networkErrorDescription => '서버에 연결할 수 없습니다. 주소와 포트를 확인하세요';
}
