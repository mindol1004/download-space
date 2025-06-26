import 'package:flutter/cupertino.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'ko': {
      'appTitle': '토렌트 매니저',
      'downloadList': '다운로드 목록',
      'serverManagement': '서버 관리',
      'addServer': '서버 추가',
      'editServer': '서버 수정',
      'serverName': '서버 이름',
      'serverType': '서버 타입',
      'address': '주소',
      'port': '포트',
      'username': '사용자 이름',
      'password': '비밀번호',
      'add': '추가',
      'edit': '수정',
      'save': '저장',
      'cancel': '취소',
      'delete': '삭제',
      'serverSelection': '서버 선택',
      'noTorrentTasks': '토렌트 작업이 없습니다',
      'noServers': '등록된 서버가 없습니다',
      'status': '상태',
      'progress': '진행률',
      'addDownload': '다운로드 추가',
      'errorOccurred': '에러가 발생했습니다',
      'deleteServerConfirm': '서버 삭제',
      'deleteServerMessage': '{serverName}을(를) 삭제하시겠습니까?',
      'requiredField': '필수 입력',
      'language': '언어',
      'korean': '한국어',
      'english': '영어',
      'settings': '설정',
      'magnetLink': '마그넷 링크',
      'enterMagnetLink': '마그넷 링크를 입력하세요.',
      'addMagnet': '마그넷 추가',
      'torrentFile': '.torrent 파일',
      'selectServerFirst': '서버를 먼저 선택하세요.',
      'magnetAddFailed': '마그넷 추가 실패: {error}',
      'fileAddFailed': '파일 추가 실패: {error}',
      'addFirstServer': '첫 번째 서버 추가',
      'or': '또는',
      'addingDownload': '다운로드 추가 중',
      'loadingTorrentList': '토렌트 목록 로드 중',
      'addNewDownload': '새로운 다운로드 추가',
      'paste': '붙여넣기',
      'selectFile': '파일 선택',
      'serverNameRequired': '서버 이름을 입력하세요.',
      'serverAddressRequired': '서버 주소를 입력하세요.',
      'portRequired': '포트를 입력하세요.',
      'portMustBeNumber': '포트는 숫자여야 합니다.',
      'portRangeError': '포트는 1에서 65535 사이여야 합니다.',
      'downloadFolder': '다운로드 폴더',
      'selectDownloadFolder': '다운로드 폴더 선택',
      'testConnection': '연결 테스트',
      'connectionSuccess': '연결 성공',
      'connectionFailed': '연결 실패',
      'selectFolderFirst': '폴더를 먼저 선택하세요.',
    },
    'en': {
      'appTitle': 'Torrent Manager',
      'downloadList': 'Download List',
      'serverManagement': 'Server Management',
      'addServer': 'Add Server',
      'editServer': 'Edit Server',
      'serverName': 'Server Name',
      'serverType': 'Server Type',
      'address': 'Address',
      'port': 'Port',
      'username': 'Username',
      'password': 'Password',
      'add': 'Add',
      'edit': 'Edit',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'serverSelection': 'Server Selection',
      'noTorrentTasks': 'No torrent tasks',
      'noServers': 'No servers registered',
      'status': 'Status',
      'progress': 'Progress',
      'addDownload': 'Add Download',
      'errorOccurred': 'An error occurred',
      'deleteServerConfirm': 'Delete Server',
      'deleteServerMessage': 'Are you sure you want to delete {serverName}?',
      'requiredField': 'Required field',
      'language': 'Language',
      'korean': 'Korean',
      'english': 'English',
      'settings': 'Settings',
      'magnetLink': 'Magnet Link',
      'enterMagnetLink': 'Please enter a magnet link.',
      'addMagnet': 'Add Magnet',
      'torrentFile': '.torrent File',
      'selectServerFirst': 'Please select a server first.',
      'magnetAddFailed': 'Magnet link addition failed: {error}',
      'fileAddFailed': 'File addition failed: {error}',
      'addFirstServer': 'Add First Server',
      'or': 'Or',
      'addingDownload': 'Adding Download',
      'loadingTorrentList': 'Loading Torrent List',
      'addNewDownload': 'Add New Download',
      'paste': 'Paste',
      'selectFile': 'Select File',
      'serverNameRequired': 'Please enter a server name.',
      'serverAddressRequired': 'Please enter a server address.',
      'portRequired': 'Please enter a port.',
      'portMustBeNumber': 'Port must be a number.',
      'portRangeError': 'Port must be between 1 and 65535.',
      'downloadFolder': 'Download Folder',
      'selectDownloadFolder': 'Select Download Folder',
      'testConnection': 'Test Connection',
      'connectionSuccess': 'Connection Successful',
      'connectionFailed': 'Connection Failed',
      'selectFolderFirst': 'Please select a folder first.',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get downloadList =>
      _localizedValues[locale.languageCode]!['downloadList']!;
  String get serverManagement =>
      _localizedValues[locale.languageCode]!['serverManagement']!;
  String get addServer => _localizedValues[locale.languageCode]!['addServer']!;
  String get editServer =>
      _localizedValues[locale.languageCode]!['editServer']!;
  String get serverName =>
      _localizedValues[locale.languageCode]!['serverName']!;
  String get serverType =>
      _localizedValues[locale.languageCode]!['serverType']!;
  String get address => _localizedValues[locale.languageCode]!['address']!;
  String get port => _localizedValues[locale.languageCode]!['port']!;
  String get username => _localizedValues[locale.languageCode]!['username']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get serverSelection =>
      _localizedValues[locale.languageCode]!['serverSelection']!;
  String get noTorrentTasks =>
      _localizedValues[locale.languageCode]!['noTorrentTasks']!;
  String get noServers => _localizedValues[locale.languageCode]!['noServers']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get progress => _localizedValues[locale.languageCode]!['progress']!;
  String get addDownload =>
      _localizedValues[locale.languageCode]!['addDownload']!;
  String get errorOccurred =>
      _localizedValues[locale.languageCode]!['errorOccurred']!;
  String get deleteServerConfirm =>
      _localizedValues[locale.languageCode]!['deleteServerConfirm']!;
  String get requiredField =>
      _localizedValues[locale.languageCode]!['requiredField']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get korean => _localizedValues[locale.languageCode]!['korean']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;

  String deleteServerMessage(String serverName) {
    return _localizedValues[locale.languageCode]!['deleteServerMessage']!
        .replaceAll('{serverName}', serverName);
  }

  String get magnetLink =>
      _localizedValues[locale.languageCode]!['magnetLink']!;
  String get enterMagnetLink =>
      _localizedValues[locale.languageCode]!['enterMagnetLink']!;
  String get addMagnet => _localizedValues[locale.languageCode]!['addMagnet']!;
  String get torrentFile =>
      _localizedValues[locale.languageCode]!['torrentFile']!;
  String get selectServerFirst =>
      _localizedValues[locale.languageCode]!['selectServerFirst']!;

  String magnetAddFailed(String error) {
    return _localizedValues[locale.languageCode]!['magnetAddFailed']!
        .replaceAll('{error}', error);
  }

  String fileAddFailed(String error) {
    return _localizedValues[locale.languageCode]!['fileAddFailed']!
        .replaceAll('{error}', error);
  }

  String get addFirstServer =>
      _localizedValues[locale.languageCode]!['addFirstServer']!;
  String get or => _localizedValues[locale.languageCode]!['or']!;
  String get addingDownload =>
      _localizedValues[locale.languageCode]!['addingDownload']!;
  String get loadingTorrentList =>
      _localizedValues[locale.languageCode]!['loadingTorrentList']!;
  String get addNewDownload =>
      _localizedValues[locale.languageCode]!['addNewDownload']!;

  String get paste => _localizedValues[locale.languageCode]!['paste']!;

  String get selectFile =>
      _localizedValues[locale.languageCode]!['selectFile']!;

  String get serverNameRequired => _localizedValues[locale.languageCode]!['serverNameRequired']!;
  String get serverAddressRequired => _localizedValues[locale.languageCode]!['serverAddressRequired']!;
  String get portRequired => _localizedValues[locale.languageCode]!['portRequired']!;
  String get portMustBeNumber => _localizedValues[locale.languageCode]!['portMustBeNumber']!;
  String get portRangeError => _localizedValues[locale.languageCode]!['portRangeError']!;
  String get downloadFolder => _localizedValues[locale.languageCode]!['downloadFolder']!;
  String get selectDownloadFolder => _localizedValues[locale.languageCode]!['selectDownloadFolder']!;
  String get testConnection => _localizedValues[locale.languageCode]!['testConnection']!;
  String get connectionSuccess => _localizedValues[locale.languageCode]!['connectionSuccess']!;
  String get connectionFailed => _localizedValues[locale.languageCode]!['connectionFailed']!;
  String get selectFolderFirst => _localizedValues[locale.languageCode]!['selectFolderFirst']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ko', 'en'].contains(locale.languageCode) ||
        ['ko_KR', 'en_US'].contains(locale.toString());
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
