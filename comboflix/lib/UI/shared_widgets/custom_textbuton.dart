import 'package:comboflix/utils/adapt.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function? onTap;
  final String? label;
  final Color? color;
  final bool underline;

  const CustomTextButton({
    required this.label,
    required this.onTap,
    this.color,
    this.underline = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.only(
          bottom: Adapt.px(.01),
        ),
        decoration: BoxDecoration(
          border: underline
              ? Border(
                  bottom: BorderSide(
                    color: color ?? Theme.of(context).indicatorColor,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Text(
          label!,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                color: color ?? Theme.of(context).indicatorColor,
              ),
        ),
      ),
    );
  }
}
