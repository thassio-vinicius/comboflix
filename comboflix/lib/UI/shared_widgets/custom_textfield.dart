import 'package:comboflix/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? errorText;
  final bool usesSuffix;
  final bool obscureText;
  final bool enabled;
  final bool autoCorrect;
  final bool border;
  final Color? color;
  final Widget? dropdownButton;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Function? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  CustomTextField({
    this.errorText,
    this.hint,
    this.onEditingComplete,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.dropdownButton,
    this.color,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.autoCorrect = false,
    this.usesSuffix = false,
    this.obscureText = false,
    this.border = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(12)),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
          border: border
              ? Border.all(
                  color: Theme.of(context).indicatorColor,
                  width: 3,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: usesSuffix ? 9 : 10,
              child: Padding(
                padding: EdgeInsets.only(left: Adapt.px(8)),
                child: TextField(
                  enabled: enabled,
                  inputFormatters: inputFormatters,
                  onEditingComplete: onEditingComplete as void Function()?,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  autocorrect: autoCorrect,
                  onChanged: onChanged,
                  controller: controller,
                  style: Theme.of(context).textTheme.headline3,
                  obscureText: obscureText,
                  cursorColor: Theme.of(context).indicatorColor,
                  decoration: InputDecoration(
                    errorText: errorText,
                    hintText: hint,
                    errorStyle: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: Adapt.px(15),
                          color: Theme.of(context).buttonColor,
                        ),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: Adapt.px(15)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (usesSuffix)
              Flexible(
                  child: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).indicatorColor,
              ))
            /*
              Flexible(
                  flex: 1,
                  child: Image(
                      image: AssetImage(
                          'assets/images/icons/authentication/${suffixName}_icon.png')))

               */
          ],
        ),
      ),
    );
  }
}
