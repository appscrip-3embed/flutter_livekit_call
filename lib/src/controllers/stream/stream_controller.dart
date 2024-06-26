import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'mixins/api_mixin.dart';
part 'mixins/join_mixin.dart';
part 'mixins/message_mixin.dart';
part 'mixins/ongoing_mixin.dart';
part 'mixins/restream_mixin.dart';
part 'mixins/sheet_mixin.dart';

class IsmLiveStreamController extends GetxController
    with GetTickerProviderStateMixin, StreamAPIMixin, StreamJoinMixin, StreamOngoingMixin, StreamMessageMixin, StreamSheetMixin, RestreamMixin {
  IsmLiveStreamController(this._viewModel);

  final IsmLiveStreamViewModel _viewModel;

  IsmLiveMqttController? get _mqttController {
    if (Get.isRegistered<IsmLiveMqttController>()) {
      return Get.find<IsmLiveMqttController>();
    }
    return null;
  }

  IsmLiveConfigData? configuration;

  UserDetails? user;

  // --------- Start Stream Variables ---------------

  final Rx<Room?> _room = Rx<Room?>(null);
  Room? get room => _room.value;
  set room(Room? value) => _room.value = value;

  final Rx<RoomListener?> _listener = Rx<RoomListener?>(null);
  RoomListener? get listener => _listener.value;
  set listener(RoomListener? value) => _listener.value = value;

  final RxList<Widget> _heartList = <Widget>[].obs;
  List<Widget> get heartList => _heartList;
  set heartList(List<Widget> value) => _heartList.value = value;

  var giftMessages = <IsmLiveMessageModel>[];

  final RxList<Widget> _giftList = <Widget>[].obs;
  List<Widget> get giftList => _giftList;
  set giftList(List<Widget> value) => _giftList.value = value;

  // --------- End Stream Variables ---------------

  PageController? pageController;

  var previousStreamIndex = 0;

  bool isHdBroadcast = false;

  bool isRecordingBroadcast = false;

  bool isRestreamBroadcast = false;

  bool usePersistentStreamKey = false;

  bool isSchedulingBroadcast = false;

  bool isPk = false;

  bool restreamFacebook = false;
  bool restreamYoutube = false;
  bool restreamInstagram = false;

  DateTime scheduleLiveDate = DateTime.now();

  IsmGoLiveTabItem selectedGoLiveTabItem = IsmGoLiveTabItem.defaultLive;

  bool isRestreamType(IsmLiveRestreamType type) => switch (type) {
        IsmLiveRestreamType.facebook => restreamFacebook,
        IsmLiveRestreamType.youtube => restreamYoutube,
        IsmLiveRestreamType.instagram => restreamInstagram,
      };

  TextEditingController rtmlUrl = TextEditingController();
  TextEditingController streamKey = TextEditingController();

  String? streamId;

  final RxDouble _pkLoadingValue = 0.0.obs;
  double get pkLoadingValue => _pkLoadingValue.value;
  set pkLoadingValue(double value) => _pkLoadingValue.value = value;

  IsmLiveChatModel? parentMessage;

  IsmLiveStreamAnalyticsModel? streamAnalytis;

  final Rx<IsmLiveMemberStatus> _memberStatus = IsmLiveMemberStatus.notMember.obs;
  IsmLiveMemberStatus get memberStatus => _memberStatus.value;
  set memberStatus(IsmLiveMemberStatus value) => _memberStatus.value = value;

  bool get isMember => memberStatus.isMember;

  final RxBool _speakerOn = true.obs;
  bool get speakerOn => _speakerOn.value;
  set speakerOn(bool value) => _speakerOn.value = value;

  final RxBool _videoOn = true.obs;
  bool get videoOn => _videoOn.value;
  set videoOn(bool value) => _videoOn.value = value;

  final RxBool _audioOn = true.obs;
  bool get audioOn => _audioOn.value;
  set audioOn(bool value) => _audioOn.value = value;

  final RxBool _showEmojiBoard = false.obs;
  bool get showEmojiBoard => _showEmojiBoard.value;
  set showEmojiBoard(bool value) => _showEmojiBoard.value = value;

  final RxList<IsmLiveMemberDetailsModel> _streamMembersList = <IsmLiveMemberDetailsModel>[].obs;
  List<IsmLiveMemberDetailsModel> get streamMembersList => _streamMembersList;
  set streamMembersList(List<IsmLiveMemberDetailsModel> value) => _streamMembersList.value = value;

  final RxList<IsmLiveViewerModel> _streamViewersList = <IsmLiveViewerModel>[].obs;
  List<IsmLiveViewerModel> get streamViewersList => _streamViewersList;
  set streamViewersList(List<IsmLiveViewerModel> value) => _streamViewersList.value = value;

  final RxList<IsmLiveChatModel> _streamMessagesList = <IsmLiveChatModel>[].obs;
  List<IsmLiveChatModel> get streamMessagesList => _streamMessagesList;
  set streamMessagesList(List<IsmLiveChatModel> value) => _streamMessagesList.value = value;

  int get streamIndex => streams.indexWhere((e) => e.streamId == streamId);

  IsmLiveMemberDetailsModel? hostDetails;

  Uint8List? bytes;

  int messagesCount = 0;

  CameraController? cameraController;

  final getStreamDebouncer = IsmLiveDebouncer();

  Future? cameraFuture;

  XFile? pickedImage;

  final RxList<IsmLiveParticipantTrack> _participantTracks = <IsmLiveParticipantTrack>[].obs;
  List<IsmLiveParticipantTrack> get participantTracks => _participantTracks;
  set participantTracks(List<IsmLiveParticipantTrack> value) => _participantTracks.value = value;

  CameraPosition position = CameraPosition.front;

  late TabController tabController;
  late TabController giftsTabController;
  late TabController cobublisTabController;
  late TabController pkTabController;
  late TabController pkViewersTabController;

  var descriptionController = TextEditingController();

  var messageFieldController = TextEditingController();

  var searchModeratorFieldController = TextEditingController();

  var searchCopublisherFieldController = TextEditingController();

  var searchExistingMembesFieldController = TextEditingController();

  var searchMembersFieldController = TextEditingController();

  var searchUserFieldController = TextEditingController();

  var searchProductFieldController = TextEditingController();

  ScrollController viewerListController = ScrollController();

  ScrollController productListController = ScrollController();

  ScrollController userListController = ScrollController();

  ScrollController moderatorListController = ScrollController();

  ScrollController copublisherListController = ScrollController();

  ScrollController existingMembersListController = ScrollController();

  ScrollController membersListController = ScrollController();

  ScrollController messagesListController = ScrollController();

  final _streamRefreshControllers = <IsmLiveStreamType, RefreshController>{};

  final _streams = <IsmLiveStreamType, List<IsmLiveStreamModel>>{};

  RefreshController get streamRefreshController => _streamRefreshControllers[streamType]!;

  List<IsmLiveStreamModel> get streams => _streams[streamType]!;

  List<UserDetails> usersList = [];

  List<UserDetails> moderatorsList = [];

  List<UserDetails> copublisherRequestsList = [];

  List<UserDetails> eligibleMembersList = [];

  List<IsmLiveProductModel> productsList = [];

  List<IsmLiveProductModel> selectedProductsList = [];

  IsmLiveUserRole? userRole;

  bool get isHost => userRole?.isHost ?? false;

  bool get isModerator => userRole?.isModerator ?? false;

  bool get isCopublisher => userRole?.isCopublisher ?? false;

  bool get isPublishing => isHost || isCopublisher;

  final Rx<IsmLiveStreamType> _streamType = IsmLiveStreamType.all.obs;
  IsmLiveStreamType get streamType => _streamType.value;
  set streamType(IsmLiveStreamType value) => _streamType.value = value;

  final Rx<IsmLiveGiftType> _giftType = IsmLiveGiftType.normal.obs;
  IsmLiveGiftType get giftType => _giftType.value;
  set giftType(IsmLiveGiftType value) => _giftType.value = value;

  final Rx<IsmLiveCopublisher> _copublisher = IsmLiveCopublisher.users.obs;
  IsmLiveCopublisher get copublisher => _copublisher.value;
  set copublisher(IsmLiveCopublisher value) => _copublisher.value = value;

  final Rx<IsmLivePk> _pk = IsmLivePk.inviteList.obs;
  IsmLivePk get pk => _pk.value;
  set pk(IsmLivePk value) => _pk.value = value;

  final Rx<IsmLivePkViewers> _pkViewers = IsmLivePkViewers.audiencelist.obs;
  IsmLivePkViewers get pkViewers => _pkViewers.value;
  set pkViewers(IsmLivePkViewers value) => _pkViewers.value = value;

  bool isModerationWarningVisible = true;

  FocusNode messageFocusNode = FocusNode();

  Timer? _streamTimer;

  final Rx<Duration> _streamDuration = Duration.zero.obs;
  Duration get streamDuration => _streamDuration.value;
  set streamDuration(Duration value) => _streamDuration.value = value;

  // late AnimationController animationController;

  // late Animation<Alignment> alignmentAnimation;
  // late Animation<Alignment> alignmentAnimationRight;

  @override
  void onInit() {
    super.onInit();
    configuration = IsmLiveUtility.config;
    tabController = TabController(
      vsync: this,
      length: IsmLiveStreamType.values.length,
    );
    giftsTabController = TabController(
      vsync: this,
      length: IsmLiveGiftType.values.length,
    );
    cobublisTabController = TabController(
      vsync: this,
      length: IsmLiveCopublisher.values.length,
    );
    pkTabController = TabController(
      vsync: this,
      length: IsmLivePk.values.length,
    );
    pkViewersTabController = TabController(
      vsync: this,
      length: IsmLivePkViewers.values.length,
    );
    // animationController = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );

    // // Define a Tween for Alignment
    // var alignmentTween = Tween<Alignment>(
    //   begin: const Alignment(-1, -0.5),
    //   end: const Alignment(-0.1, -0.5),
    // );
    // var alignmentTweenRight = Tween<Alignment>(
    //   begin: const Alignment(1, -0.5),
    //   end: const Alignment(0.1, -0.5),
    // );

    // animationController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {}
    // });

    // Create an Animation with the Tween and the Controller
    // alignmentAnimation = alignmentTween.animate(animationController);
    // alignmentAnimationRight = alignmentTweenRight.animate(animationController);

    // Start the animation automatically

    generateVariables();
  }

  @override
  void onReady() {
    super.onReady();
    IsmLiveUtility.updateLater(startOnInit);
  }

  bool isViewesApiCall = false;
  bool isUsersApiCall = false;
  bool isModeratorsApiCall = false;
  bool isCopublisherApiCall = false;
  bool isMembersApiCall = false;
  bool isMessagesApiCall = false;
  bool isExistingMembersApiCall = false;
  bool isProductApiCall = false;

  // Pagination method
  void pagination(String streamId) {
    viewerListController.addListener(() async {
      if (viewerListController.position.maxScrollExtent * 0.8 <= viewerListController.position.pixels) {
        if (isViewesApiCall) {
          return;
        }
        isViewesApiCall = true;

        await getStreamViewer(streamId: streamId, limit: 10, skip: streamViewersList.length);
        isViewesApiCall = false;
      }
    });

    productListController.addListener(() async {
      if (productListController.position.maxScrollExtent * 0.8 <= productListController.position.pixels) {
        if (isProductApiCall) {
          return;
        }
        isProductApiCall = true;

        await fetchProducts(
          limit: 10,
          skip: productsList.length,
          forceFetch: true,
          searchTag: searchProductFieldController.text.trim().isEmpty ? null : searchProductFieldController.text.trim(),
        );
        isProductApiCall = false;
      }
    });

    userListController.addListener(() async {
      if (userListController.position.maxScrollExtent * 0.8 <= userListController.position.pixels) {
        if (isUsersApiCall) {
          return;
        }
        isUsersApiCall = true;
        await fetchUsers(
          forceFetch: true,
          skip: usersList.length,
          searchTag: searchUserFieldController.text.trim().isEmpty ? null : searchUserFieldController.text.trim(),
        );
        isUsersApiCall = false;
      }
    });

    moderatorListController.addListener(() async {
      if (moderatorListController.position.maxScrollExtent * 0.8 <= moderatorListController.position.pixels) {
        if (isModeratorsApiCall) {
          return;
        }
        isModeratorsApiCall = true;
        await fetchModerators(
          forceFetch: true,
          streamId: streamId,
          skip: moderatorsList.length,
          searchTag: searchModeratorFieldController.text.trim().isEmpty ? null : searchModeratorFieldController.text.trim(),
        );
        isModeratorsApiCall = false;
      }
    });

    copublisherListController.addListener(() async {
      if (copublisherListController.position.maxScrollExtent * 0.8 <= copublisherListController.position.pixels) {
        if (isCopublisherApiCall) {
          return;
        }
        isCopublisherApiCall = true;
        await fetchCopublisherRequests(
          forceFetch: true,
          streamId: streamId,
          skip: copublisherRequestsList.length,
          searchTag: searchCopublisherFieldController.text.trim().isEmpty ? null : searchCopublisherFieldController.text.trim(),
        );
        isCopublisherApiCall = false;
      }
    });

    existingMembersListController.addListener(() async {
      if (existingMembersListController.position.maxScrollExtent * 0.8 <= existingMembersListController.position.pixels) {
        if (isExistingMembersApiCall) {
          return;
        }
        isExistingMembersApiCall = true;
        await getStreamMembers(
          streamId: streamId,
          skip: streamMembersList.length,
          searchTag: searchExistingMembesFieldController.text.trim().isEmpty ? null : searchExistingMembesFieldController.text.trim(),
        );
        isExistingMembersApiCall = false;
      }
    });

    membersListController.addListener(() async {
      if (membersListController.position.maxScrollExtent * 0.8 <= membersListController.position.pixels) {
        if (isMembersApiCall) {
          return;
        }
        isMembersApiCall = true;
        await fetchEligibleMembers(
          forceFetch: true,
          streamId: streamId,
          skip: eligibleMembersList.length,
          searchTag: searchMembersFieldController.text.trim().isEmpty ? null : searchMembersFieldController.text.trim(),
        );
        isMembersApiCall = false;
      }
    });

    messagesListController.addListener(() {
      if (messagesListController.position.minScrollExtent == messagesListController.position.pixels) {
        if (isMessagesApiCall) {
          return;
        }
        isMessagesApiCall = true;
        if (messagesCount != 0) {
          fetchMessages(
            showLoading: false,
            getMessageModel: IsmLiveGetMessageModel(
              streamId: streamId,
              messageType: [IsmLiveMessageType.normal.value],
              skip: messagesCount < 10 ? 0 : (messagesCount - 10),
              limit: _controller.messagesCount < 10 ? _controller.messagesCount : 10,
              sort: 1,
            ),
          );
        }
        isMessagesApiCall = false;
      }
    });
  }

// Method to start operations on initialization
  void startOnInit() async {
    unawaited(getUserDetails());
    unawaited(subscribeUser());
    unawaited(getStreams());

    tabController.addListener(() {
      streamType = IsmLiveStreamType.values[tabController.index];
    });
    giftsTabController.addListener(() {
      giftType = IsmLiveGiftType.values[giftsTabController.index];
    });
    cobublisTabController.addListener(() {
      copublisher = IsmLiveCopublisher.values[cobublisTabController.index];
    });
    pkTabController.addListener(() {
      pk = IsmLivePk.values[pkTabController.index];
    });
    pkViewersTabController.addListener(() {
      pkViewers = IsmLivePkViewers.values[pkViewersTabController.index];
    });
  }

  void generateVariables() {
    for (var type in IsmLiveStreamType.values) {
      _streamRefreshControllers[type] = RefreshController();
      _streams[type] = [];
    }
  }

  Future<bool> subscribeUser() => _subscribeUser(true);

  Future<bool> unsubscribeUser() => _subscribeUser(false);

  void onChangeHdBroadcast(bool value) {
    isHdBroadcast = value;
    update([IsmGoLiveView.updateId]);
  }

  void onChangeRecording(bool value) {
    isRecordingBroadcast = value;

    update([IsmGoLiveView.updateId]);
  }

  void onChangePersistent(bool value) {
    usePersistentStreamKey = value;

    update([IsmGoLiveView.updateId]);
  }

  void onChangeRestream(bool value) {
    isRestreamBroadcast = value;

    update([IsmGoLiveView.updateId]);
  }

  void onChangeSchedule(bool value) async {
    if (value) {
      await IsmLiveUtility.openBottomSheet(const IsmLiveScheduleTimeBottomSheet());
    }
    isSchedulingBroadcast = value;

    update([IsmGoLiveView.updateId]);
  }

  void searchUser(String values) async {
    usersList.clear();
    if (values.trim().isNotEmpty || searchUserFieldController.isNotEmpty) {
      await fetchUsers(
        forceFetch: true,
        searchTag: values.trim(),
      );
    } else {
      await fetchUsers(
        forceFetch: true,
      );
    }
  }

  void searchModerators(String values) async {
    moderatorsList.clear();
    if (values.trim().isNotEmpty || searchModeratorFieldController.isNotEmpty) {
      await fetchModerators(
        forceFetch: true,
        streamId: streamId ?? '',
        searchTag: values.trim(),
      );
    } else {
      await fetchModerators(
        forceFetch: true,
        streamId: streamId ?? '',
      );
    }
  }

  void searchRequest(String values) async {
    copublisherRequestsList.clear();
    if (values.trim().isNotEmpty || copublisherRequestsList.isNotEmpty) {
      await fetchCopublisherRequests(
        forceFetch: true,
        streamId: streamId ?? '',
        searchTag: values.trim(),
      );
    } else {
      await fetchCopublisherRequests(
        forceFetch: true,
        streamId: streamId ?? '',
      );
    }
  }

  void searchMember(String values) async {
    streamMembersList.clear();
    if (values.trim().isNotEmpty || streamMembersList.isNotEmpty) {
      await getStreamMembers(
        streamId: streamId ?? '',
        searchTag: values.trim(),
      );
    } else {
      await getStreamMembers(
        streamId: streamId ?? '',
      );
    }
  }

  toggleEmojiBoard(BuildContext context) async {
    if (messageFocusNode.hasFocus) {
      messageFocusNode.unfocus();
    }
    showEmojiBoard = !showEmojiBoard;
  }

  void searchMembers(String values) async {
    eligibleMembersList.clear();
    if (values.trim().isNotEmpty || eligibleMembersList.isNotEmpty) {
      await fetchEligibleMembers(
        forceFetch: true,
        streamId: streamId ?? '',
        searchTag: values.trim(),
      );
    } else {
      await fetchEligibleMembers(
        forceFetch: true,
        streamId: streamId ?? '',
      );
    }
  }

  Future<void> askPublish() async {
    try {
      if (room == null || room?.localParticipant == null) {
        return;
      }
      await Future.wait([
        room!.localParticipant!.setCameraEnabled(true),
        room!.localParticipant!.setMicrophoneEnabled(true),
      ]);
    } catch (e) {
      IsmLiveLog.error(e);
    }
  }

  void toggleVideo({
    bool? value,
  }) async {
    final participant = room?.localParticipant;
    if (participant == null) {
      return;
    }
    videoOn = value ?? !videoOn;
    try {
      await participant.setCameraEnabled(videoOn);
    } catch (error) {
      videoOn = !videoOn;
      IsmLiveLog('muteUnmuteVideo function  error  $error');
    }
  }

  void toggleCamera() async {
    final participant = room?.localParticipant;
    if (participant == null) {
      return;
    }
    final track = participant.videoTrackPublications.firstOrNull?.track;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      position = newPosition;
      update();
    } catch (error) {
      IsmLiveLog('could not restart track: $error');
      return;
    }
  }

  Future<void> animateToPage(int index) async => await pageController?.animateToPage(
        index,
        duration: IsmLiveConstants.animationDuration,
        curve: Curves.easeInOut,
      );

  void pkLoading(Timer? timer) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (pkLoadingValue > 1.0) {
        timer.cancel();
        Get.back();
      }
      pkLoadingValue = pkLoadingValue + 0.1;
    });
  }
}
