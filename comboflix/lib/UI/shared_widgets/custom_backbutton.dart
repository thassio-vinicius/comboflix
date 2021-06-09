import 'package:comboflix/utils/adapt.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onPressed;
  final String label;
  final bool lightTheme;
  const CustomBackButton(this.label, this.onPressed, {this.lightTheme = false});

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      padding: EdgeInsets.zero,
      height: Adapt().hp(5),
      onPressed: onPressed as void Function()?,
      label: Text(
        label,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontSize: Adapt.px(14),
              color: lightTheme
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).indicatorColor,
            ),
      ),
      icon: Icon(
        Icons.arrow_back_ios,
        color: lightTheme
            ? Theme.of(context).backgroundColor
            : Theme.of(context).indicatorColor,
        size: Adapt.px(20),
      ),
    );
  }
}
