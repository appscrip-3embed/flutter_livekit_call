import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';

class ControlsWidget extends StatelessWidget {
  const ControlsWidget(
    this.room,
    this.participant, {
    super.key,
    required this.meetingId,
    required this.audioCallOnly,
  });

  final Room room;
  final LocalParticipant participant;
  final String meetingId;
  final bool audioCallOnly;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmLiveCallingController>(
        initState: (state) {
          final streamController = Get.find<IsmLiveCallingController>();

          participant.addListener(streamController.update);
        },
        dispose: (state) async {
          final streamController = Get.find<IsmLiveCallingController>();

          participant.removeListener(streamController.update);
        },
        builder: (controller) => Container(
          margin: IsmLiveDimens.edgeInsetsB20,
          padding: IsmLiveDimens.edgeInsets10,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                dimension: IsmLiveDimens.fifty,
                icon: Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: IsmLiveDimens.twentyFive,
                ),
                onTap: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  // PIPView.of(context)?.presentBelow(Chat());
                },
                radius: IsmLiveDimens.fifty,
              ),
              CustomIconButton(
                dimension: IsmLiveDimens.fifty,
                icon: Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: IsmLiveDimens.twentyFive,
                ),
                onTap: () {
                  controller.onTapDisconnect(room, meetingId);
                },
                color: Colors.red,
                radius: IsmLiveDimens.fifty,
              ),
              participant.isMicrophoneEnabled()
                  ? CustomIconButton(
                      dimension: IsmLiveDimens.fifty,
                      icon: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: IsmLiveDimens.twentyFive,
                      ),
                      onTap: () {
                        controller.disableAudio(participant);
                      },
                    )
                  : CustomIconButton(
                      dimension: IsmLiveDimens.fifty,
                      icon: Icon(
                        Icons.mic_off,
                        color: Colors.white,
                        size: IsmLiveDimens.twentyFive,
                      ),
                      onTap: () {
                        controller.enableAudio(participant);
                      },
                    ),
              if (!audioCallOnly)
                participant.isCameraEnabled()
                    ? CustomIconButton(
                        dimension: IsmLiveDimens.fifty,
                        icon: Icon(
                          Icons.videocam_sharp,
                          color: Colors.white,
                          size: IsmLiveDimens.twentyFive,
                        ),
                        onTap: () {
                          controller.disableVideo(participant);
                        },
                      )
                    : CustomIconButton(
                        dimension: IsmLiveDimens.fifty,
                        icon: Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          size: IsmLiveDimens.twentyFive,
                        ),
                        onTap: () {
                          controller.enableVideo(participant);
                        },
                      ),
              if (!audioCallOnly)
                CustomIconButton(
                  dimension: IsmLiveDimens.fifty,
                  icon: Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                    size: IsmLiveDimens.twentyFive,
                  ),
                  onTap: () {
                    controller.toggleCamera(participant);
                  },
                ),
            ],
          ),
        ),
      );
}

class MyBackgroundScreen extends StatelessWidget {
  const MyBackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('This is my background screen!'),
        ),
      );
}
