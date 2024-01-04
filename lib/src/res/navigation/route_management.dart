import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livekit_client/livekit_client.dart';

abstract class IsmLiveRouteManagement {
  // static void goToMyMeetingsView(IsmLiveStreamConfig configuration) {
  //   Get.toNamed<void>(IsLiveRoutes.myMeetingsView, arguments: configuration);
  // }

  static void goToCreateMeetingScreen() {
    Get.toNamed(IsmLiveRoutes.createMeetingScreen);
  }

  static Future<void> goToRoomPage(
    Room room,
    EventsListener<RoomEvent> listener,
    String meetingId,
    bool audioCallOnly,
  ) async {
    await Get.toNamed(IsmLiveRoutes.roomPage, arguments: {
      'room': room,
      'listener': listener,
      'meetingId': meetingId,
      'audioCallOnly': audioCallOnly,
    });
  }

  static Future<void> goToStreamView({
    required bool isHost,
    required bool isNewStream,
    required Room room,
    required EventsListener<RoomEvent> listener,
    required String streamId,
    bool audioCallOnly = false,
  }) async {
    var arguments = {
      'room': room,
      'listener': listener,
      'streamId': streamId,
      'audioCallOnly': audioCallOnly,
      'isHost': isHost,
      'isNewStream': isNewStream,
    };
    if (isNewStream) {
      await Get.offNamed(
        IsmLiveRoutes.streamView,
        arguments: arguments,
      );
    } else {
      await Get.toNamed(
        IsmLiveRoutes.streamView,
        arguments: arguments,
      );
    }
  }

  static void goToSearchUserScreen() {
    Get.toNamed<void>(
      IsmLiveRoutes.searchUserScreen,
    );
  }

  static void goToEndStreamView() {
    Get.offAndToNamed<void>(
      IsmLiveRoutes.endStream,
    );
  }

  static void goToGoLiveView() {
    Get.toNamed<void>(
      IsmLiveRoutes.goLive,
    );
  }

  static void goToMyMeetingsView() {
    Get.offAndToNamed<void>(
      IsmLiveRoutes.myMeetingsView,
    );
  }

  static Future<XFile?> goToCamera(
    bool isPhotoRequired,
    bool isOnlyImage,
  ) async {
    if (IsmLiveUtility.cameras.isNotEmpty) {
      return await Get.to<XFile>(
        CameraScreenView(
          isPhotoRequired: isPhotoRequired,
          isOnlyImage: isOnlyImage,
        ),
      );
    } else {
      await IsmLiveUtility.showInfoDialog(
        IsmLiveResponseModel.message('Camera Not Available'),
      );
      return null;
    }
  }
}
