// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Torrent Manager';

  @override
  String get downloadList => 'Download List';

  @override
  String get serverManagement => 'Server Management';

  @override
  String get addServer => 'Add Server';

  @override
  String get editServer => 'Edit Server';

  @override
  String get serverName => 'Server Name';

  @override
  String get serverType => 'Server Type';

  @override
  String get address => 'Address';

  @override
  String get port => 'Port';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get serverSelection => 'Server Selection';

  @override
  String get noTorrentTasks => 'No torrent tasks';

  @override
  String get noServers => 'No servers registered';

  @override
  String get status => 'Status';

  @override
  String get progress => 'Progress';

  @override
  String get addDownload => 'Add Download';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get deleteServerConfirm => 'Delete Server';

  @override
  String deleteServerMessage(String serverName) {
    return 'Are you sure you want to delete $serverName?';
  }

  @override
  String get requiredField => 'Required field';

  @override
  String get language => 'Language';

  @override
  String get korean => 'Korean';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get magnetLink => 'Magnet Link';

  @override
  String get enterMagnetLink => 'Please enter a magnet link.';

  @override
  String get addMagnet => 'Add Magnet';

  @override
  String get torrentFile => '.torrent File';

  @override
  String get selectServerFirst => 'Please select a server first.';

  @override
  String magnetAddFailed(String error) {
    return 'Magnet link addition failed: $error';
  }

  @override
  String fileAddFailed(String error) {
    return 'File addition failed: $error';
  }

  @override
  String get addFirstServer => 'Add your first server';

  @override
  String get or => 'or';

  @override
  String get addingDownload => 'Adding download...';

  @override
  String get loadingTorrentList => 'Loading torrent list...';

  @override
  String get addNewDownload => 'Add a new download';

  @override
  String get paste => 'Paste';

  @override
  String get selectFile => 'Select File';

  @override
  String get torrentFileSelect => 'Select torrent file';

  @override
  String get serverNameRequired => 'Please enter server name';

  @override
  String get serverAddressRequired => 'Please enter server address';

  @override
  String get portRequired => 'Please enter port number';

  @override
  String get portMustBeNumber => 'Port number must be a number';

  @override
  String get portRangeError => 'Port number must be between 1-65535';

  @override
  String get downloadFolder => 'Download Folder';

  @override
  String get selectDownloadFolder => 'Select Download Folder';

  @override
  String get testConnection => 'Test Connection';

  @override
  String get connectionSuccess => 'Connection successful';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String get selectFolderFirst => 'Please select download folder first';

  @override
  String get corsError => 'CORS error occurred';

  @override
  String get corsErrorDescription => 'Please run proxy server or use browser extension';

  @override
  String get proxyServerNotRunning => 'Proxy server is not running';

  @override
  String get proxyServerNotRunningDescription => 'Please start proxy server first (npm start)';

  @override
  String get networkError => 'Network error';

  @override
  String get networkErrorDescription => 'Cannot connect to server. Please check address and port';
}
