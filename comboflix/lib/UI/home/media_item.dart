import 'package:comboflix/models/media.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/hex_color.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';

class MediaItem extends StatelessWidget {
  final Media media;
  final bool shouldAdd;
  final bool checkBoxValue;
  final void Function(bool?)? onChanged;

  const MediaItem({
    required this.media,
    this.onChanged,
    this.checkBoxValue = false,
    this.shouldAdd = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(12.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (shouldAdd)
            Checkbox(
              value: checkBoxValue,
              onChanged: onChanged!,
              activeColor: Theme.of(context).buttonColor,
              checkColor: Colors.white,
              side: BorderSide(color: Colors.white),
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Adapt.px(12)))),
              padding: EdgeInsets.all(Adapt.px(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    media.name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    media.type + ' - ' + media.genre + ' - ' + media.language,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.star,
                            color: HexColor('ffd700'),
                          ),
                        ),
                        TextSpan(
                          text: media.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                  ),
                  Text(
                    Strings.ageRestriction +
                        ': ' +
                        (media.ageRestriction > 0
                            ? media.ageRestriction.toString()
                            : Strings.none),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
