import 'package:comboflix/utils/adapt.dart';
import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  final Function? onPressed;
  final String? label;
  final bool loading;
  final double? height;
  final bool whiteTheme;
  final bool enabled;
  final bool icon;
  final IconData? iconData;
  final String? iconPath;
  final bool assetIcon;
  final double? radius;
  const CustomPrimaryButton({
    required this.onPressed,
    required this.label,
    this.height,
    this.iconData,
    this.iconPath,
    this.radius,
    this.enabled = true,
    this.whiteTheme = false,
    this.loading = false,
    this.icon = false,
    this.assetIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Center(
        child: loading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).buttonColor),
              )
            : icon
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      assetIcon
                          ? Image(image: AssetImage(iconPath!))
                          : Icon(iconData,
                              color: whiteTheme
                                  ? Theme.of(context).buttonColor
                                  : Theme.of(context)
                                      .textTheme
                                      .button!
                                      .color!
                                      .withOpacity(enabled ? 1 : 0.9)),
                      Padding(
                        padding: EdgeInsets.only(left: Adapt.px(6)),
                        child: Text(
                          label!,
                          style: whiteTheme
                              ? Theme.of(context).textTheme.headline5!.copyWith(
                                  color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.bold)
                              : Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .color!
                                      .withOpacity(enabled ? 1 : 0.9)),
                        ),
                      ),
                    ],
                  )
                : Text(
                    label!,
                    style: whiteTheme
                        ? Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context).textTheme.button!.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .headline6!
                                .color!
                                .withOpacity(enabled ? 1 : 0.9)),
                  ),
      ),
      onPressed: loading
          ? null
          //To avoid the call of the onPressed method even with the button disabled
          : enabled
              ? onPressed as void Function()?
              : () {
                  debugPrint("button disabled");
                },
      color: whiteTheme
          ? Colors.white
          : Theme.of(context).buttonColor.withOpacity(enabled ? 1 : 0.5),
      height: height ?? Adapt().hp(10),
      shape: RoundedRectangleBorder(
          side: whiteTheme
              ? BorderSide(color: Theme.of(context).buttonColor)
              : BorderSide.none,
          borderRadius:
              BorderRadius.all(Radius.circular(Adapt.px(radius ?? 4)))),
    );
  }
}
