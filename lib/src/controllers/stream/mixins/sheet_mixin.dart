part of '../stream_controller.dart';

mixin StreamSheetMixin {
  IsmLiveStreamController get _controller => Get.find();

  void onExit({
    required bool isHost,
    required String streamId,
  }) {
    if (isHost || (_controller.isCopublisher ?? false)) {
      IsmLiveUtility.openBottomSheet(
        IsmLiveCustomButtomSheet(
          title: isHost
              ? IsmLiveStrings.areYouSureEndStream
              : IsmLiveStrings.areYouSureLeaveStream,
          leftLabel: 'Cancel',
          rightLabel: isHost ? 'End Stream' : 'Leave Stram',
          onLeft: Get.back,
          onRight: () async {
            Get.back();
            await _controller.disconnectStream(
              isHost: isHost,
              streamId: streamId,
            );
          },
        ),
        isDismissible: false,
      );
    } else {
      _controller.disconnectStream(
        isHost: isHost,
        streamId: streamId,
      );
    }
  }

  void giftsSheet() async {
    await IsmLiveUtility.openBottomSheet(
      IsmLiveGiftsSheet(
        onTap: (gift) => _controller.sendGiftMessage(
          streamId: _controller.streamId ?? '',
          gift: gift,
        ),
      ),
      isScrollController: true,
    );
  }

  void settingSheet() async {
    await IsmLiveUtility.openBottomSheet(
      const IsmLiveSettingsSheet(),
    );
  }

  void copublishingViewerSheet() async {
    await IsmLiveUtility.openBottomSheet(
      IsmLiveCopublishingViewerSheet(
        title: Get.context?.liveTranslations.requestCopublishingTitle ??
            IsmLiveStrings.requestCopublishingTitle,
        description:
            Get.context?.liveTranslations.requestCopublishingDescription ??
                IsmLiveStrings.requestCopublishingDescription,
        label: _controller.memberStatus.isRejected
            ? 'Request denied by the host'
            : _controller.memberStatus.didRequested
                ? 'Requested Co-publishing'
                : 'Send Request',
        images: [
          _controller.user?.profileUrl ?? '',
          _controller.hostDetails?.userProfileImageUrl ?? '',
        ],
        onTap: _controller.memberStatus.didRequested ||
                _controller.memberStatus.isRejected
            ? null
            : () async {
                if (!_controller.isModerator) {
                  final isSent = await _controller.requestCopublisher(
                    _controller.streamId ?? '',
                  );
                  if (isSent) {
                    _controller.memberStatus = IsmLiveMemberStatus.requested;
                  }
                }
              },
      ),
    );
  }

  void copublishingStartVideoSheet() async {
    await IsmLiveUtility.openBottomSheet(
      IsmLiveCopublishingViewerSheet(
        title:
            (Get.context?.liveTranslations.hostAcceptedCopublishRequestTitle ??
                    IsmLiveStrings.hostAcceptedCopublishRequestTitle)
                .trParams({
          'name': _controller.hostDetails?.userName ?? 'Host',
        }),
        description: Get.context?.liveTranslations
                .hostAcceptedCopublishRequestDescription ??
            IsmLiveStrings.hostAcceptedCopublishRequestDescription,
        label: 'Start Video',
        images: [
          _controller.user?.profileUrl ?? '',
        ],
        onTap: () async {
          var token = await _controller.switchViewer(
              streamId: _controller.streamId ?? '');
          if (token == null) {
            return;
          }

          await _controller.connectStream(
            token: token,
            streamId: _controller.streamId ?? '',
            isHost: false,
            isNewStream: false,
            isCopublisher: true,
          );

          await _controller.sortParticipants();
        },
      ),
    );
  }

  void copublishingHostSheet() async {
    await IsmLiveUtility.openBottomSheet(
      const IsmLiveCopublishingHostSheet(),
      isScrollController: true,
    );
  }
}
