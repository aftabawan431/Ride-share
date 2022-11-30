import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  Future<PackageInfoModel> get() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return PackageInfoModel(
        packageName: packageName, version: version, buildNumber: buildNumber);
  }
}

class PackageInfoModel {
  PackageInfoModel({
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });
  late final String packageName;
  late final String version;
  late final String buildNumber;

  PackageInfoModel.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    version = json['version'];
    buildNumber = json['buildNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['packageName'] = packageName;
    _data['version'] = version;
    _data['buildNumber'] = buildNumber;
    return _data;
  }
}
