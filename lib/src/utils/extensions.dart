import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:flutter/material.dart';

extension IsmLiveNullString on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

extension IsmLiveMapExtension on Map<String, dynamic> {
  Map<String, dynamic> removeNullValues() {
    var result = <String, dynamic>{};
    for (var entry in entries) {
      var k = entry.key;
      if (entry.value != null) {
        if (entry.value.runtimeType.toString().contains('Map')) {
          result[k] = (entry.value as Map<String, dynamic>).removeNullValues();
        } else {
          result[k] = entry.value;
        }
      }
    }
    return result;
  }

  String makeQuery() {
    var res = [];
    for (var entry in removeNullValues().entries) {
      var key = entry.key;
      var value = entry.value;
      res.add('$key=$value');
    }
    return res.join('&');
  }
}

extension IsmLiveStreamTypeExtension on IsmLiveStreamType {
  IsmLiveStreamQueryModel get queryModel {
    var model = const IsmLiveStreamQueryModel();
    switch (this) {
      case IsmLiveStreamType.all:
        return model;
      case IsmLiveStreamType.audioOnly:
        return model.copyWith(audioOnly: true);
      case IsmLiveStreamType.multilive:
        return model.copyWith(multiLive: true);
      case IsmLiveStreamType.private:
        return model.copyWith(public: false);
      case IsmLiveStreamType.ecommerce:
        return model.copyWith(productsLinked: true);
      case IsmLiveStreamType.restream:
        return model.copyWith(reStream: true);
      case IsmLiveStreamType.hd:
        return model.copyWith(hdBroadcast: true);
      case IsmLiveStreamType.recorded:
        return model.copyWith(recorded: true);
    }
  }
}

extension IsmLiveEditingExtension on TextEditingController {
  bool get isEmpty => text.trim().isEmpty;

  bool get isNotEmpty => text.trim().isNotEmpty;
}

extension IsmLiveContextExtension on BuildContext {
  IsmLiveThemeData get liveTheme => IsmLiveTheme.of(this);

  IsmLiveConfigData get liveConfig => IsmLiveConfig.of(this);

  IsmLiveTranslationsData get liveTranslations => IsmLiveTranslations.of(this);

  IsmLivePropertiesData get liveProperties => IsmLiveProperties.of(this);
}

extension IsmLiveMaterialStateExtension on Set<MaterialState> {
  bool get isDisabled => any((e) => [MaterialState.disabled].contains(e));
}

extension IsmLiveDurationExtension on Duration {
  String get formattedTime {
    final h = inHours.toString().padLeft(2, '0');
    final m = (inMinutes % 60).toString().padLeft(2, '0');
    final s = (inSeconds % 60).toString().padLeft(2, '0');
    return [h, m, s].join(':');
  }
}

extension IsmLiveIntExtensions on int {
  double get sheetHeight => IsmLiveDimens.oneHundredTwenty + this * IsmLiveDimens.sixty;
}
