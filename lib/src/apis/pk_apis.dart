import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';

class IsmLivePkApis {
  const IsmLivePkApis(this._apiWrapper);
  final IsmLiveApiWrapper _apiWrapper;

  static const String baseUrl = IsmLiveApis.baseUrlStream;

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
      baseUrl: baseUrl,
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
      baseUrl: baseUrl,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
    );
  }

  Future<IsmLiveResponseModel> invitationPK({
    required String streamId,
    required String inviteId,
    required String response,
  }) async {
    var payload = {
      'streamId': streamId,
      'inviteId': inviteId,
      'response': response
    };
    return await _apiWrapper.makeRequest(
      IsmLiveApis.invitaionPK,
      baseUrl: baseUrl,
      type: IsmLiveRequestType.post,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
    );
  }

  Future<IsmLiveResponseModel> publishPk({
    required String streamId,
    required bool startPublish,
  }) async {
    var payload = {
      'streamId': streamId,
      'startPublish': startPublish,
    };
    return await _apiWrapper.makeRequest(
      IsmLiveApis.publish,
      type: IsmLiveRequestType.put,
      payload: payload,
      headers: IsmLiveUtility.tokenHeader(),
    );
  }
}
