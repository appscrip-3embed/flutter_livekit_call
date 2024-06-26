import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:appscrip_live_stream_component_example/controllers/controllers.dart';
import 'package:appscrip_live_stream_component_example/utils/utils.dart';
import 'package:appscrip_live_stream_component_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  AuthController(this._viewModel);
  final AuthViewModel _viewModel;

  AppConfig get _appConfig => Get.find();

  UserController get userController {
    if (!Get.isRegistered<UserController>()) {
      UserBinding().dependencies();
    }
    return Get.find<UserController>();
  }

  var loginFormKey = GlobalKey<FormState>();
  var signFormKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordControllerSignIn = TextEditingController();
  var userNameController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  Uint8List? bytes;

  final RxString _profileImage = ''.obs;
  String get profileImage => _profileImage.value;
  set profileImage(String value) => _profileImage.value = value;

  final RxBool _isEmailValid = false.obs;
  bool get isEmailValid => _isEmailValid.value;
  set isEmailValid(bool value) {
    _isEmailValid.value = value;
  }

  final RxBool _showPassward = false.obs;
  bool get showPassward => _showPassward.value;
  set showPassward(bool value) {
    _showPassward.value = value;
  }

  final RxBool _showConfirmPasswared = false.obs;
  bool get showConfirmPasswared => _showConfirmPasswared.value;
  set showConfirmPasswared(bool value) {
    _showConfirmPasswared.value = value;
  }

  // -------------------------------- Functions ------------------------------------

  void validateLogin() {
    if (loginFormKey.currentState!.validate()) {
      login();
    }
  }

  void validateSignUp() {
    if (signFormKey.currentState!.validate()) {
      signup();
    }
  }

  Future<void> login() async {
    var res = await _viewModel.login(
      userName: userNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      deviceId: _appConfig.deviceId!,
    );
    if (res == null) {
      return;
    }

    unawaited(userController.getUserData());
    RouteManagement.goToHome();
  }

  Future<void> signup() async {
    var creatUser = <String, dynamic>{
      'userProfileImageUrl': profileImage,
      'userName': userNameController.text.trim(),
      'userIdentifier': emailController.text.trim(),
      'password': confirmPasswordController.text.trim(),
      'metaData': {'country': 'India'}
    };
    var res = await _viewModel.signup(
      deviceId: _appConfig.deviceId!,
      isLoading: true,
      createUser: creatUser,
    );
    if (res == null) {
      return;
    }
    unawaited(userController.getUserData());
    RouteManagement.goToHome();
  }

  void uploadImage(ImageSource imageSource) async {
    XFile? result;
    if (imageSource == ImageSource.gallery) {
      result = await ImagePicker().pickImage(imageQuality: 25, source: ImageSource.gallery);
    } else {
      result = await ImagePicker().pickImage(
        imageQuality: 25,
        source: ImageSource.camera,
      );
    }
    if (result != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper'.tr,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          )
        ],
      );
      bytes = File(croppedFile!.path).readAsBytesSync();
      var extension = result.name.split('.').last;
      await getPresignedUrl(extension, bytes!);
    }
  }

  // / get Api for presigned Url.....
  Future<void> getPresignedUrl(String mediaExtension, Uint8List bytes) async {
    IsmLiveUtility.showLoader();
    var res = await _viewModel.getPresignedUrl(
      showLoader: false,
      userIdentifier: DateTime.now().millisecondsSinceEpoch.toString(),
      mediaExtension: mediaExtension,
    );
    if (res == null) {
      IsmLiveUtility.closeLoader();
      return;
    }
    var urlResponse = await updatePresignedUrl(res.presignedUrl ?? '', bytes);
    if (urlResponse == 200) {
      profileImage = res.mediaUrl ?? '';
    }
    IsmLiveUtility.closeLoader();
  }

  /// put Api for updatePresignedUrl...
  Future<int?> updatePresignedUrl(String presignedUrl, Uint8List bytes) async {
    var response = await _viewModel.updatePresignedUrl(showLoading: false, presignedUrl: presignedUrl, file: bytes);
    return response.statusCode;
  }
}
