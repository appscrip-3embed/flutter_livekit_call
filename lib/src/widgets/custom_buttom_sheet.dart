import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmLiveCustomButtomSheet extends StatelessWidget {
  const IsmLiveCustomButtomSheet({
    super.key,
    required this.title,
    this.leftOnTab,
    required this.leftLabel,
    required this.rightLabel,
    this.rightOnTab,
  });
  final String title;
  final VoidCallback? leftOnTab;
  final String leftLabel;
  final String rightLabel;
  final VoidCallback? rightOnTab;
  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmLiveDimens.edgeInsets16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IsmLiveDimens.boxHeight10,
            Text(
              title,
              style: context.textTheme.titleLarge,
            ),
            IsmLiveDimens.boxHeight20,
            Row(
              children: [
                Expanded(
                  child: IsmLiveButton.outlined(
                    label: leftLabel,
                    onTap: leftOnTab,
                  ),
                ),
                IsmLiveDimens.boxWidth16,
                Expanded(
                  child: IsmLiveButton(
                    label: rightLabel,
                    onTap: rightOnTab,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}