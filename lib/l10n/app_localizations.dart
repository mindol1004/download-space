import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ko'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In ko, this message translates to:
  /// **'토렌트 매니저'**
  String get appTitle;

  /// Title for download list screen
  ///
  /// In ko, this message translates to:
  /// **'다운로드 목록'**
  String get downloadList;

  /// Title for server management screen
  ///
  /// In ko, this message translates to:
  /// **'서버 관리'**
  String get serverManagement;

  /// Title for adding server
  ///
  /// In ko, this message translates to:
  /// **'서버 추가'**
  String get addServer;

  /// Title for editing server
  ///
  /// In ko, this message translates to:
  /// **'서버 수정'**
  String get editServer;

  /// Label for server name field
  ///
  /// In ko, this message translates to:
  /// **'서버 이름'**
  String get serverName;

  /// Label for server type field
  ///
  /// In ko, this message translates to:
  /// **'서버 타입'**
  String get serverType;

  /// Label for address field
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get address;

  /// Label for port field
  ///
  /// In ko, this message translates to:
  /// **'포트'**
  String get port;

  /// Label for username field
  ///
  /// In ko, this message translates to:
  /// **'사용자 이름'**
  String get username;

  /// Label for password field
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// Button text for adding
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get add;

  /// Button text for editing
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get edit;

  /// Button text for saving
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// Button text for canceling
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// Button text for deleting
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// Label for server selection dropdown
  ///
  /// In ko, this message translates to:
  /// **'서버 선택'**
  String get serverSelection;

  /// Message when no torrent tasks exist
  ///
  /// In ko, this message translates to:
  /// **'토렌트 작업이 없습니다'**
  String get noTorrentTasks;

  /// Message when no servers are registered
  ///
  /// In ko, this message translates to:
  /// **'등록된 서버가 없습니다'**
  String get noServers;

  /// Label for status
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get status;

  /// Label for progress
  ///
  /// In ko, this message translates to:
  /// **'진행률'**
  String get progress;

  /// Button text for adding download
  ///
  /// In ko, this message translates to:
  /// **'다운로드 추가'**
  String get addDownload;

  /// Message when an error occurs
  ///
  /// In ko, this message translates to:
  /// **'에러가 발생했습니다'**
  String get errorOccurred;

  /// Title for delete server confirmation dialog
  ///
  /// In ko, this message translates to:
  /// **'서버 삭제'**
  String get deleteServerConfirm;

  /// Message for delete server confirmation
  ///
  /// In ko, this message translates to:
  /// **'{serverName}을(를) 삭제하시겠습니까?'**
  String deleteServerMessage(String serverName);

  /// Validation message for required fields
  ///
  /// In ko, this message translates to:
  /// **'필수 입력 항목입니다.'**
  String get requiredField;

  /// Label for language selection
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// Korean language option
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// English language option
  ///
  /// In ko, this message translates to:
  /// **'영어'**
  String get english;

  /// Title for settings screen
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// Label for magnet link field
  ///
  /// In ko, this message translates to:
  /// **'마그넷 링크'**
  String get magnetLink;

  /// Validation message for magnet link field
  ///
  /// In ko, this message translates to:
  /// **'마그넷 링크를 입력하세요.'**
  String get enterMagnetLink;

  /// Button text for adding magnet link
  ///
  /// In ko, this message translates to:
  /// **'마그넷 추가'**
  String get addMagnet;

  /// Button text for torrent file upload
  ///
  /// In ko, this message translates to:
  /// **'.torrent 파일'**
  String get torrentFile;

  /// Error message when no server is selected
  ///
  /// In ko, this message translates to:
  /// **'서버를 먼저 선택하세요.'**
  String get selectServerFirst;

  /// Error message when magnet link addition fails
  ///
  /// In ko, this message translates to:
  /// **'마그넷 추가 실패: {error}'**
  String magnetAddFailed(String error);

  /// Error message when torrent file addition fails
  ///
  /// In ko, this message translates to:
  /// **'파일 추가 실패: {error}'**
  String fileAddFailed(String error);

  /// Message to encourage adding first server
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 서버를 추가해보세요'**
  String get addFirstServer;

  /// Text for 'or' separator
  ///
  /// In ko, this message translates to:
  /// **'또는'**
  String get or;

  /// Loading message when adding download
  ///
  /// In ko, this message translates to:
  /// **'다운로드를 추가하는 중...'**
  String get addingDownload;

  /// Loading message when fetching torrent list
  ///
  /// In ko, this message translates to:
  /// **'토렌트 목록을 불러오는 중...'**
  String get loadingTorrentList;

  /// Message to encourage adding new download
  ///
  /// In ko, this message translates to:
  /// **'새로운 다운로드를 추가해보세요'**
  String get addNewDownload;

  /// No description provided for @paste.
  ///
  /// In ko, this message translates to:
  /// **'붙여넣기'**
  String get paste;

  /// No description provided for @selectFile.
  ///
  /// In ko, this message translates to:
  /// **'파일 선택'**
  String get selectFile;

  /// No description provided for @torrentFileSelect.
  ///
  /// In ko, this message translates to:
  /// **'토렌트 파일 선택'**
  String get torrentFileSelect;

  /// No description provided for @serverNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'서버 이름을 입력하세요'**
  String get serverNameRequired;

  /// No description provided for @serverAddressRequired.
  ///
  /// In ko, this message translates to:
  /// **'서버 주소를 입력하세요'**
  String get serverAddressRequired;

  /// No description provided for @portRequired.
  ///
  /// In ko, this message translates to:
  /// **'포트 번호를 입력하세요'**
  String get portRequired;

  /// No description provided for @portMustBeNumber.
  ///
  /// In ko, this message translates to:
  /// **'포트 번호는 숫자여야 합니다'**
  String get portMustBeNumber;

  /// No description provided for @portRangeError.
  ///
  /// In ko, this message translates to:
  /// **'포트 번호는 1-65535 사이여야 합니다'**
  String get portRangeError;

  /// No description provided for @downloadFolder.
  ///
  /// In ko, this message translates to:
  /// **'다운로드 폴더'**
  String get downloadFolder;

  /// No description provided for @selectDownloadFolder.
  ///
  /// In ko, this message translates to:
  /// **'다운로드 폴더 선택'**
  String get selectDownloadFolder;

  /// No description provided for @testConnection.
  ///
  /// In ko, this message translates to:
  /// **'연결 테스트'**
  String get testConnection;

  /// No description provided for @connectionSuccess.
  ///
  /// In ko, this message translates to:
  /// **'연결 성공'**
  String get connectionSuccess;

  /// No description provided for @connectionFailed.
  ///
  /// In ko, this message translates to:
  /// **'연결 실패'**
  String get connectionFailed;

  /// No description provided for @selectFolderFirst.
  ///
  /// In ko, this message translates to:
  /// **'먼저 다운로드 폴더를 선택하세요'**
  String get selectFolderFirst;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
