// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:appscrip_live_stream_component/appscrip_live_stream_component_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the AppscripLiveStreamComponentPlatform of the AppscripLiveStreamComponent plugin.
class AppscripLiveStreamComponentWeb
    extends AppscripLiveStreamComponentPlatform {
  /// Constructs a AppscripLiveStreamComponentWeb
  AppscripLiveStreamComponentWeb();

  static void registerWith(Registrar registrar) {
    AppscripLiveStreamComponentPlatform.instance =
        AppscripLiveStreamComponentWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
