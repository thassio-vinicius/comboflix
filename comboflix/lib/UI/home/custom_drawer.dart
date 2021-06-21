import 'dart:math' as math;

import 'package:comboflix/UI/onboarding/authentication_screen.dart';
import 'package:comboflix/UI/shared_widgets/custom_textbuton.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:comboflix/services/authentication_provider.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final FirestoreUser user;
  final Function? onHomeTap, onListsTap;
  const CustomDrawer(
      {required this.user, this.onHomeTap, this.onListsTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          padding: EdgeInsets.only(left: Adapt.px(12)),
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: Adapt.px(44),
                    child: Text(
                      user.name.substring(0, 2).toUpperCase(),
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: Adapt.px(36),
                          ),
                    ),
                    backgroundColor: Colors.primaries[
                        math.Random().nextInt(Colors.primaries.length)],
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: Adapt.px(8)),
                      child: Text(
                        user.name + ' - ' + user.year + ' years old',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: Adapt.px(16),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Adapt.px(46), bottom: Adapt.px(12)),
              child: CustomTextButton(
                label: Strings.home,
                onTap: onHomeTap,
                underline: false,
              ),
            ),
            CustomTextButton(
              label: Strings.mediaLists,
              onTap: onListsTap,
              underline: false,
            ),
            Padding(
              padding: EdgeInsets.only(top: Adapt.px(56)),
              child: CustomTextButton(
                label: Strings.logOut,
                underline: false,
                color: Colors.white,
                onTap: () =>
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .signOut()
                        .then(
                  (_) async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AuthenticationScreen(false),
                      ),
                      (_) => false,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
