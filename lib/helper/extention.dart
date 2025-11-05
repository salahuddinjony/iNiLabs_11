import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:url_launcher/url_launcher.dart';

extension RouteBasePathExt on String {
  String get addBasePath {
    return RoutePath.basePath + this;
  }
}

extension LaunchUrlExt on String {
  Future<void> launchExternal() async {
    final uri = Uri.parse(this);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      EasyLoading.showError('Could not open URL');
    }
  }
}
