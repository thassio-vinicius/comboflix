import 'dart:io';

import 'package:comboflix/UI/home/custom_drawer.dart';
import 'package:comboflix/UI/home/home_screen.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:comboflix/models/media_list.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class ListScreen extends StatefulWidget {
  final FirestoreUser user;
  const ListScreen({required this.user, Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<bool>? pressed;

  @override
  void initState() {
    pressed = widget.user.lists == null
        ? null
        : List.generate(widget.user.lists!.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: CustomDrawer(
        user: widget.user,
        onListsTap: () => Navigator.pop(context),
        onHomeTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(false),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          Strings.comboFlix,
          style: GoogleFonts.bangers(
            fontSize: Adapt.px(35),
            letterSpacing: 5,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Adapt.px(16)),
        child: widget.user.lists == null
            ? Center(
                child: Text(
                  'No media lists available',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : ListView.builder(
                itemCount: widget.user.lists?.length ?? 0,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: Adapt.px(12)),
                  child: listItem(
                    widget.user.lists![index],
                    pressed![index],
                    () {
                      setState(() {
                        pressed![index] = !pressed![index];
                      });
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Widget listItem(MediaList mediaList, bool pressed, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).buttonColor, shape: BoxShape.circle),
            height: Adapt.px(38),
            width: Adapt.px(38),
            child: Center(
              child: IconButton(
                onPressed: () {
                  String listContent = '';

                  mediaList.content!.forEach((e) {
                    listContent = listContent + '\n${e.name}' + '(${e.year})';
                  });

                  Share.share('Here\'s a list for you! ' +
                      mediaList.name +
                      listContent);
                },
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.share : Icons.share,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Adapt.px(12)),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
                ),
                padding: EdgeInsets.all(Adapt.px(12)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Text(
                            mediaList.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: AnimatedSwitcher(
                            duration: kThemeAnimationDuration,
                            child: pressed
                                ? Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    if (pressed)
                      Container(
                        height: calculateHeight(mediaList.content!.length),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mediaList.content!
                              .map(
                                (e) => Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Adapt.px(4)),
                                    child: Text(
                                      e.name +
                                          '(${e.year})' +
                                          ' - ' +
                                          e.type +
                                          ' - ' +
                                          e.genre,
                                      overflow: TextOverflow.visible,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(fontSize: Adapt.px(12)),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double? calculateHeight(int length) {
    return Adapt().hp(length * 3.5);
  }
}
