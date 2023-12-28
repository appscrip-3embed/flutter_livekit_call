import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmLiveThemeData with Diagnosticable {
  const IsmLiveThemeData({
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.buttonRadius,
    this.cardBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final BorderRadius? buttonRadius;
  final Color? cardBackgroundColor;

  IsmLiveThemeData copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? selectedTextColor,
    Color? unselectedTextColor,
    BorderRadius? buttonRadius,
    Color? cardBackgroundColor,
  }) =>
      IsmLiveThemeData(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        selectedTextColor: selectedTextColor ?? this.selectedTextColor,
        unselectedTextColor: unselectedTextColor ?? this.unselectedTextColor,
        buttonRadius: buttonRadius ?? this.buttonRadius,
        cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      );
}
