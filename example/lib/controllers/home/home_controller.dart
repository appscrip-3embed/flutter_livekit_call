import 'package:appscrip_live_stream_component_example/data/data.dart';
import 'package:appscrip_live_stream_component_example/models/models.dart';
import 'package:appscrip_live_stream_component_example/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  DBWrapper get dbWrapper => Get.find<DBWrapper>();

  late UserDetailsModel user;

  @override
  void onInit() {
    super.onInit();

    user = UserDetailsModel.fromJson(dbWrapper.getStringValue(LocalKeys.user));
  }

  void logout() async {
    await dbWrapper.deleteAllSecuredValues();
    dbWrapper.deleteBox();
    RouteManagement.goToLogin();
  }
}
