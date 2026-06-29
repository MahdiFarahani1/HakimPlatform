import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  AppVersion._();

  static final AppVersion instance = AppVersion._();

  String _version = '';
  String _buildNumber = '';

  String get version => _version;
  String get buildNumber => _buildNumber;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
    _buildNumber = info.buildNumber;
  }

  String get fullVersion => 'v$_version ($_buildNumber)';
}
