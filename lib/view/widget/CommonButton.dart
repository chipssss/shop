import 'package:flutter/material.dart';
import 'package:shop/layout/letter_spacing.dart';

import '../colors.dart';
import '../theme.dart';

/// Ui-常用控件-按钮，样式再封装
class CommonButton extends RaisedButton {
  CommonButton({@required VoidCallback onPressed, @required String text})
      : super(
            onPressed: onPressed,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            color: shrinePink100,
            splashColor: shrineBrown600,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  text,
                  style: TextStyle(
                      letterSpacing: letterSpacingOrNone(largeLetterSpacing)),
                ))
  );
}
