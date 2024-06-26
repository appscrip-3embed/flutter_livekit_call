import 'dart:typed_data';

import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';

class IsmLiveStreamRepository {
  const IsmLiveStreamRepository(this._apiWrapper);
  final IsmLiveApiWrapper _apiWrapper;

  Future<IsmLiveResponseModel> getUserDetails() async =>
      _apiWrapper.makeRequest(
        IsmLiveApis.userDetails,
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
      );

  Future<IsmLiveResponseModel> subscribeUser({
    required bool isSubscribing,
  }) {
    var api = IsmLiveApis.userSubscription;
    if (!isSubscribing) {
      api = '$api?streamStartChannel=true';
    }
    return _apiWrapper.makeRequest(
      api,
      type: isSubscribing ? IsmLiveRequestType.put : IsmLiveRequestType.delete,
      payload: !isSubscribing
          ? null
          : {
              'streamStartChannel': true,
            },
      headers: IsmLiveUtility.tokenHeader(),
    );
  }

  Future<IsmLiveResponseModel> getStreams({
    required IsmLiveStreamQueryModel queryModel,
  }) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.getStreams}?${queryModel.toMap().makeQuery()}',
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
        showDialog: false,
      );

  Future<IsmLiveResponseModel> getRTCToken(String streamId, bool showLoader) =>
      _apiWrapper.makeRequest(
        IsmLiveApis.viewer,
        type: IsmLiveRequestType.post,
        headers: IsmLiveUtility.tokenHeader(),
        payload: {
          'streamId': streamId,
        },
        showLoader: showLoader,
      );

  Future<IsmLiveResponseModel> leaveStream(
    String streamId,
  ) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.leaveStream}?streamId=$streamId',
        type: IsmLiveRequestType.delete,
        headers: IsmLiveUtility.tokenHeader(),
        showLoader: true,
      );

  Future<IsmLiveResponseModel> createStream(
    IsmLiveCreateStreamModel streamModel,
  ) =>
      _apiWrapper.makeRequest(
        IsmLiveApis.stream,
        type: IsmLiveRequestType.post,
        headers: IsmLiveUtility.tokenHeader(),
        payload: streamModel.toMap(),
        showLoader: true,
      );

  Future<IsmLiveResponseModel> stopStream(
    String streamId,
  ) =>
      _apiWrapper.makeRequest(
        IsmLiveApis.stream,
        type: IsmLiveRequestType.put,
        headers: IsmLiveUtility.tokenHeader(),
        payload: {
          'streamId': streamId,
        },
        showLoader: true,
      );

  Future<IsmLiveResponseModel> getPresignedUrl({
    required bool showLoader,
    required String userIdentifier,
    required String mediaExtension,
  }) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.presignedurl}?userIdentifier=$userIdentifier&mediaExtension=$mediaExtension',
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.secretHeader(),
        showLoader: showLoader,
      );

  Future<IsmLiveResponseModel> getStreamMembers({
    required String streamId,
    required int limit,
    required int skip,
    String? searchTag,
  }) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.getStreamMembers}?streamId=$streamId&limit=$limit&skip=$skip',
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
        showLoader: false,
        showDialog: false,
      );

  Future<IsmLiveResponseModel> getStreamViewer({
    required String streamId,
    required int limit,
    required int skip,
    String? searchTag,
  }) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.getStreamViewer}?streamId=$streamId&limit=$limit&skip=$skip',
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
        showLoader: false,
        showDialog: false,
      );

  Future<IsmLiveResponseModel> updatePresignedUrl({
    required bool showLoading,
    required String presignedUrl,
    required Uint8List file,
  }) =>
      _apiWrapper.makeRequest(
        presignedUrl,
        baseUrl: '',
        type: IsmLiveRequestType.put,
        payload: file,
        headers: {},
        showLoader: showLoading,
        shouldEncodePayload: false,
      );

  // Future<IsmLiveResponseModel> getEndStream({
  //   required bool showLoading,
  //   required String streamId,
  // }) =>
  //     _apiWrapper.makeRequest(
  //       '${IsmLiveApis.getEndStream}?streamId=$streamId',
  //       type: IsmLiveRequestType.get,
  //       headers: IsmLiveUtility.tokenHeader(),
  //       showLoader: showLoading,
  //     );

  Future<IsmLiveResponseModel> sendMessage({
    required bool showLoading,
    required Map<String, dynamic> payload,
  }) =>
      _apiWrapper.makeRequest(
        IsmLiveApis.postMessage,
        type: IsmLiveRequestType.post,
        headers: IsmLiveUtility.tokenHeader(),
        payload: payload,
        showLoader: showLoading,
      );

  Future<IsmLiveResponseModel> replyMessage({
    required bool showLoading,
    required Map<String, dynamic> payload,
  }) =>
      _apiWrapper.makeRequest(
        IsmLiveApis.replyMessage,
        type: IsmLiveRequestType.post,
        headers: IsmLiveUtility.tokenHeader(),
        payload: payload,
        showLoader: showLoading,
      );

  Future<IsmLiveResponseModel> fetchMessages({
    required bool showLoading,
    required Map<String, dynamic> payload,
  }) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.messages}?${payload.makeQuery()}',
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
        showLoader: showLoading,
      );

  Future<IsmLiveResponseModel> fetchMessagesCount({
    required bool showLoading,
    required Map<String, dynamic> payload,
  }) =>
      _apiWrapper.makeRequest(
        '${IsmLiveApis.messagesCount}?${payload.makeQuery()}',
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
        showLoader: showLoading,
        showDialog: false,
      );

  Future<IsmLiveResponseModel> kickoutViewer({
    required String streamId,
    required String viewerId,
  }) {
    var payload = {
      'streamId': streamId,
      'viewerId': viewerId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.viewer}?${payload.makeQuery()}',
      type: IsmLiveRequestType.delete,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> deleteMessage({
    required String streamId,
    required String messageId,
  }) {
    var payload = {
      'streamId': streamId,
      'messageId': messageId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.deleteMessage}?${payload.makeQuery()}',
      type: IsmLiveRequestType.delete,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: false,
    );
  }

  Future<IsmLiveResponseModel> fetchUsers({
    required bool isLoading,
    required int skip,
    required int limit,
    String? searchTag,
  }) async {
    var payload = {
      'skip': skip,
      'limit': limit,
      'searchTag': searchTag,
    };

    var res = await _apiWrapper.makeRequest(
      '${IsmLiveApis.getUsers}?${payload.makeQuery()}',
      type: IsmLiveRequestType.get,
      showLoader: isLoading,
      showDialog: false,
      headers: IsmLiveUtility.secretHeader(),
    );

    return res;
  }

  Future<IsmLiveResponseModel> fetchModerators({
    required bool isLoading,
    required int skip,
    required String streamId,
    required int limit,
    String? searchTag,
  }) async {
    var payload = {
      'streamId': streamId,
      'skip': skip,
      'limit': limit,
      'searchTag': searchTag,
    };

    var res = await _apiWrapper.makeRequest(
      '${IsmLiveApis.getModerators}?${payload.makeQuery()}',
      type: IsmLiveRequestType.get,
      showLoader: isLoading,
      showDialog: false,
      headers: IsmLiveUtility.tokenHeader(),
    );

    return res;
  }

  Future<IsmLiveResponseModel> makeModerator({
    required String streamId,
    required String moderatorId,
  }) {
    var payload = {
      'streamId': streamId,
      'moderatorId': moderatorId,
    };
    return _apiWrapper.makeRequest(
      IsmLiveApis.moderator,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> removeModerator({
    required String streamId,
    required String moderatorId,
  }) {
    var payload = {
      'streamId': streamId,
      'moderatorId': moderatorId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.moderator}?${payload.makeQuery()}',
      type: IsmLiveRequestType.delete,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> leaveModerator(String streamId) {
    var payload = {
      'streamId': streamId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.leaveModerator}?${payload.makeQuery()}',
      type: IsmLiveRequestType.delete,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> requestCopublisher(String streamId) {
    var payload = {
      'streamId': streamId,
    };
    return _apiWrapper.makeRequest(
      IsmLiveApis.copublisherRequest,
      type: IsmLiveRequestType.post,
      headers: IsmLiveUtility.tokenHeader(),
      payload: payload,
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> fetchCopublisherRequests({
    required int skip,
    required String streamId,
    required int limit,
    String? searchTag,
  }) async {
    var payload = {
      'streamId': streamId,
      'skip': skip,
      'limit': limit,
      'searchTag': searchTag,
    };

    return await _apiWrapper.makeRequest(
      '${IsmLiveApis.copublishersRequests}?${payload.makeQuery()}',
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
      showDialog: false,
    );
  }

  Future<IsmLiveResponseModel> fetchEligibleMembers({
    required int skip,
    required String streamId,
    required int limit,
    String? searchTag,
  }) async {
    var payload = {
      'streamId': streamId,
      'skip': skip,
      'limit': limit,
      'searchTag': searchTag,
    };

    return await _apiWrapper.makeRequest(
      '${IsmLiveApis.eligibleMembers}?${payload.makeQuery()}',
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
      showDialog: false,
    );
  }

  Future<IsmLiveResponseModel> acceptCopublisherRequest({
    required String streamId,
    required String requestById,
  }) {
    var payload = {
      'streamId': streamId,
      'requestByUserId': requestById,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.acceptCopublisher}?${payload.makeQuery()}',
      type: IsmLiveRequestType.post,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> denyCopublisherRequest({
    required String streamId,
    required String requestById,
  }) {
    var payload = {
      'streamId': streamId,
      'requestByUserId': requestById,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.denyCopublisher}?${payload.makeQuery()}',
      type: IsmLiveRequestType.post,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> addMember({
    required String streamId,
    required String memberId,
  }) {
    var payload = {
      'streamId': streamId,
      'memberId': memberId,
    };
    return _apiWrapper.makeRequest(
      IsmLiveApis.member,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> removeMember({
    required String streamId,
    required String memberId,
  }) {
    var payload = {
      'streamId': streamId,
      'memberId': memberId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.member}?${payload.makeQuery()}',
      type: IsmLiveRequestType.delete,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> leaveMember({
    required String streamId,
  }) {
    var payload = {
      'streamId': streamId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.leaveMember}?${payload.makeQuery()}',
      type: IsmLiveRequestType.delete,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> statusCopublisherRequest({
    required String streamId,
  }) {
    var payload = {
      'streamId': streamId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.statusCopublisher}?${payload.makeQuery()}',
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: false,
      showDialog: false,
    );
  }

  Future<IsmLiveResponseModel> switchViewer({
    required String streamId,
  }) {
    var payload = {
      'streamId': streamId,
    };
    return _apiWrapper.makeRequest(
      IsmLiveApis.switchProfile,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> fetchProductDetails() {
    var parameter = {
      'url':
          'https://www.lenskart.com/vincent-chase-vc-s13981-c3-sunglasses.html',
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.productDetails}?${parameter.makeQuery()}',
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> fetchProducts({
    required int skip,
    required int limit,
    String? searchTag,
  }) async {
    var payload = {
      'skip': skip,
      'limit': limit,
      'searchTag': searchTag,
    };

    return await _apiWrapper.makeRequest(
      '${IsmLiveApis.products}?${payload.makeQuery()}',
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
    );
  }

  Future<IsmLiveResponseModel> getRestreamChannels() => _apiWrapper.makeRequest(
        IsmLiveApis.restreamChannel,
        type: IsmLiveRequestType.get,
        headers: IsmLiveUtility.tokenHeader(),
        showLoader: false,
        showDialog: false,
      );

  Future<IsmLiveResponseModel> addRestreamChannel({
    required String url,
    required bool enable,
  }) {
    final payload = {
      'ingestUrl': url,
      'enabled': enable,
      'channelType': 1,
      'channelName': 'Youtube',
    };
    return _apiWrapper.makeRequest(
      IsmLiveApis.restreamChannel,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
      showDialog: true,
    );
  }

  Future<IsmLiveResponseModel> streamAnalytics({
    required String streamId,
  }) {
    var payload = {
      'streamId': streamId,
    };

    return _apiWrapper.makeRequest(
      '${IsmLiveApis.streamAnalytics}?${payload.makeQuery()}',
      baseUrl: IsmLiveApis.devBaseUrl,
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> streamAnalyticsViewers({
    required String streamId,
  }) {
    var payload = {
      'streamId': streamId,
    };
    return _apiWrapper.makeRequest(
      '${IsmLiveApis.streamAnalyticsViewers}?${payload.makeQuery()}',
      baseUrl: IsmLiveApis.devBaseUrl,
      type: IsmLiveRequestType.get,
      headers: IsmLiveUtility.tokenHeader(),
      showLoader: true,
    );
  }

  Future<IsmLiveResponseModel> getUsersToInviteForPK({
    required int skip,
    required int limit,
    String? searchTag,
  }) async {
    var payload = {
      'skip': skip,
      'limit': limit,
      'q': searchTag,
    };

    return await _apiWrapper.makeRequest(
      '${IsmLiveApis.getUsersToInviteForPK}?${payload.makeQuery()}',
      baseUrl: IsmLiveApis.devBaseUrl,
      type: IsmLiveRequestType.get,
      showDialog: false,
      headers: IsmLiveUtility.tokenHeader(),
    );
  }

  Future<IsmLiveResponseModel> sendInvitationToUserForPK({
    required String reciverStreamId,
    required String userId,
    required String senderStreamId,
  }) async {
    var payload = {
      'reciverStreamId': reciverStreamId,
      'senderStreamId': senderStreamId,
      'userId': userId
    };
    return await _apiWrapper.makeRequest(
      IsmLiveApis.getUsersToInviteForPK,
      baseUrl: IsmLiveApis.devBaseUrl,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
    );
  }
}
