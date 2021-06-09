import 'package:comboflix/utils/adapt.dart';
import 'package:flutter/material.dart';

class CustomSecondaryButton extends StatelessWidget {
  final Function onTap;
  final double? height;
  final double? width;
  final String label;

  const CustomSecondaryButton({
    required this.label,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: height ?? Adapt().hp(6),
        width: width ?? Adapt().wp(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(20))),
          color: Colors.transparent,
          border: Border.all(width: 1, color: Theme.of(context).indicatorColor),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}
