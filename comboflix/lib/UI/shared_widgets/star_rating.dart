import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/hex_color.dart';
import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color color = HexColor('#ffd700');

  StarRating({this.onRatingChanged, this.rating = .0});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: Adapt.px(50),
        color: color,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: Adapt.px(50),
        color: color,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: Adapt.px(50),
        color: color,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) => buildStar(context, index)));
  }
}
