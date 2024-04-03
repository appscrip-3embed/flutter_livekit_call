import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:appscrip_live_stream_component/src/live_handler.dart';
import 'package:get/get.dart';

class IsmLiveDelegate {
  factory IsmLiveDelegate() => instance;

  const IsmLiveDelegate._();

  static const IsmLiveDelegate instance = IsmLiveDelegate._();

  IsmLiveDBWrapper get _dbWrapper => Get.find();

  Future<void> initialize(IsmLiveConfigData config) => Future.wait([
        IsmLiveHandler.initialize(),
        _dbWrapper.saveValueSecurely(IsmLiveLocalKeys.configDetails, config.toJson()),
        IsmLiveUtility.initialize(config),
      ]);
}