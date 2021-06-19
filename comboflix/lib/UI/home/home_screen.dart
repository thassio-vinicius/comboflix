import 'dart:async';

import 'package:comboflix/UI/home/custom_drawer.dart';
import 'package:comboflix/UI/home/home_model.dart';
import 'package:comboflix/UI/home/list_screen.dart';
import 'package:comboflix/UI/home/media_item.dart';
import 'package:comboflix/UI/shared_widgets/custom_primarybutton.dart';
import 'package:comboflix/UI/shared_widgets/custom_textfield.dart';
import 'package:comboflix/UI/shared_widgets/loading_screen.dart';
import 'package:comboflix/UI/shared_widgets/star_rating.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:comboflix/models/media.dart';
import 'package:comboflix/services/firestore_provider.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final bool fromSplash;
  const HomeScreen(this.fromSplash, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreProvider provider =
        Provider.of<FirestoreProvider>(context, listen: false);
    return FutureBuilder<FirestoreUser>(
      future: provider.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        }

        return StreamBuilder<FirestoreUser>(
          initialData: snapshot.data,
          stream: provider.currentUserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return LoadingScreen();
            } else {
              print('data from snapshot ' + snapshot.data.toString());

              return ChangeNotifierProvider(
                create: (_) => HomeModel(
                    firestoreProvider: provider, user: snapshot.data!),
                child: Consumer<HomeModel>(
                  builder: (_, model, ___) =>
                      _HomeScreen(model, fromSplash, snapshot.data!),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _HomeScreen extends StatefulWidget {
  final bool fromSplash;
  final HomeModel model;
  final FirestoreUser user;

  const _HomeScreen(this.model, this.fromSplash, this.user);

  @override
  __HomeScreenState createState() => __HomeScreenState();
}

class __HomeScreenState extends State<_HomeScreen>
    with TickerProviderStateMixin {
  late double opacity;
  double listButtonOpacity = 0;

  HomeModel get model => widget.model;
  final FocusScopeNode node = FocusScopeNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController listNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageRestrictionController = TextEditingController();
  late AnimationController draggableController;
  bool showListButton = false;
  Tween<Offset> draggableTween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  bool showFloatingButton = true;
  List<Media> itemsForList = [];

  List<String> years() {
    int year = DateTime.now().year;
    List<String> years = [];
    for (int i = year; i > year - 120; i--) {
      years.add(i.toString());
    }

    years.insert(0, Strings.yearOfLaunch + '*');
    return years.toList();
  }

  @override
  void initState() {
    if (widget.fromSplash) {
      opacity = 0;
      Timer(Duration(seconds: 1), () {
        opacity = 1;
      });
    } else {
      opacity = 1;
    }
    draggableController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);

    draggableController.addStatusListener((status) {
      setState(() {
        print(status);
        showFloatingButton = status != AnimationStatus.completed;
        showListButton = status != AnimationStatus.completed;
      });
    });
    super.initState();
  }

  void listNameEditingComplete() {
    if (model.canSubmitListName) {
      node.nextFocus();
    }
  }

  void displayNameEditingComplete() {
    if (model.canSubmitDisplayName) {
      node.nextFocus();
    }
  }

  void ageRestrictionEditingComplete() {
    if (model.canSubmitAgeRestriction) {
      node.nextFocus();
    }
  }

  void descriptionEditingComplete() {
    if (!model.canSubmitDescription) {
      node.previousFocus();
      return;
    }
  }

  Future<void> submit(context) async {
    FocusScope.of(context).unfocus();
    print(model.toString());

    try {
      final bool result = await model.submit();
      if (result) {
        draggableController.reverse();
        if (model.formType == FormType.list) {
          setState(() {
            itemsForList = [];
            showListButton = false;
            showFloatingButton = true;
            Navigator.pop(context);
          });
          Fluttertoast.showToast(msg: 'List created successfully');
        }
      } else {
        //showExceptionAlertDialog(context: context, title: title, exception: exception)
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: CustomDrawer(
        user: widget.user,
        onHomeTap: () => Navigator.pop(context),
        onListsTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ListScreen(user: widget.user),
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
      body: body(context),
      floatingActionButton: showFloatingButton
          ? FloatingActionButton(
              onPressed: () {
                draggableController.forward();
                nameController.clear();
                listNameController.clear();
                descriptionController.clear();
                ageRestrictionController.clear();
                model.updateWith(
                  language: Strings.language + '*',
                  genre: Strings.genre + '*',
                  year: Strings.yearOfLaunch + '*',
                  displayName: '',
                  description: '',
                  listName: '',
                  ageRestriction: '',
                  rating: 0,
                  type: Strings.type + '*',
                  submitted: false,
                );
              },
              backgroundColor: Theme.of(context).buttonColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Stack body(BuildContext context) {
    return Stack(
      children: [
        widget.user.medias!.isNotEmpty
            ? ListView.builder(
                itemCount: widget.user.medias!.length,
                itemBuilder: (context, index) => MediaItem(
                  media: widget.user.medias![index],
                  checkBoxValue:
                      itemsForList.contains(widget.user.medias![index]),
                  onChanged: (value) {
                    if (value!) {
                      setState(() {
                        showListButton = true;
                        listButtonOpacity = 1;
                        showFloatingButton = false;
                        itemsForList.add(widget.user.medias![index]);
                      });
                    } else {
                      setState(() {
                        itemsForList.remove(widget.user.medias![index]);

                        if (itemsForList.isEmpty) {
                          showListButton = false;
                          listButtonOpacity = 0;
                          showFloatingButton = true;
                        }
                      });
                    }
                  },
                ),
              )
            : Center(
                child: Text(
                  Strings.noMovies,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
        SizedBox.expand(
          child: SlideTransition(
            position: draggableTween.animate(draggableController),
            child: DraggableScrollableSheet(
              initialChildSize: 0.50,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) => FocusScope(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: addMediaColumn(),
                ),
              ),
            ),
          ),
        ),
        if (showListButton)
          Positioned(
            bottom: 10,
            left: 60,
            right: 60,
            child: Padding(
              padding: EdgeInsets.all(Adapt.px(12)),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(2, -2),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(-2, 2),
                      blurRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
                ),
                height: Adapt().hp(10),
                child: AnimatedOpacity(
                    opacity: listButtonOpacity,
                    duration: kThemeAnimationDuration,
                    child: CustomPrimaryButton(
                        radius: 16,
                        whiteTheme: true,
                        loading: model.isLoading,
                        enabled: !model.isLoading,
                        onPressed: () {
                          model.updateFormType(FormType.list);
                          model.updateListContent(itemsForList);
                          model.updateListName('');
                          listNameController.clear();
                          return showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Adapt.px(8)),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(Adapt.px(12)),
                                child: SizedBox(
                                  height: Adapt().hp(35),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: Adapt.px(12)),
                                        child: Text(
                                          Strings.nameTheList,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                      ),
                                      CustomTextField(
                                        controller: listNameController,
                                        onChanged: model.updateListName,
                                        hint: Strings.name + '*',
                                        errorText: model.submitted &&
                                                !model.canSubmitDisplayName
                                            ? Strings.name +
                                                Strings.cantBeEmpty +
                                                Strings.nameSmaller
                                            : null,
                                        enabled: !model.isLoading,
                                        onEditingComplete:
                                            displayNameEditingComplete,
                                      ),
                                      CustomPrimaryButton(
                                        onPressed: () => submit(context),
                                        enabled: !model.isLoading,
                                        label: Strings.create,
                                        loading: model.isLoading,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        label: Strings.createList)),
              ),
            ),
          )
      ],
    );
  }

  Widget addMediaColumn() {
    return FocusScope(
      node: node,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Adapt.px(12)),
            topLeft: Radius.circular(Adapt.px(12)),
          ),
        ),
        padding: EdgeInsets.all(Adapt.px(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  //if (_animationController.isCompleted) {
                  draggableController.reverse();
                  FocusScope.of(context).unfocus();
                  //}
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
            Text(
              Strings.addMedia,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
            CustomTextField(
              controller: nameController,
              hint: Strings.name + '*',
              errorText: model.submitted && !model.canSubmitDisplayName
                  ? Strings.name + Strings.cantBeEmpty + Strings.nameSmaller
                  : null,
              onChanged: model.updateDisplayName,
              enabled: !model.isLoading,
              onEditingComplete: displayNameEditingComplete,
            ),
            dropdownButton(
              currentValue: model.year,
              label: Strings.yearOfLaunch + '*',
              items: years(),
              onChanged: model.updateYear,
              enabled: !model.isLoading,
              errorText: model.submitted && !model.canSubmitYear
                  ? Strings.yearOfLaunch + Strings.cantBeEmpty
                  : null,
            ),
            dropdownButton(
              currentValue: model.genre,
              label: Strings.genre + '*',
              items: Strings.genres,
              onChanged: model.updateGenre,
              enabled: !model.isLoading,
              errorText: model.submitted && !model.canSubmitGenre
                  ? Strings.genre + Strings.cantBeEmpty
                  : null,
            ),
            dropdownButton(
              currentValue: model.language,
              label: Strings.language + '*',
              items: Strings.languages.reversed.toList(),
              onChanged: model.updateLanguage,
              enabled: !model.isLoading,
              errorText: model.submitted && !model.canSubmitLanguage
                  ? Strings.language + Strings.cantBeEmpty
                  : null,
            ),
            dropdownButton(
              currentValue: model.type,
              label: Strings.type + '*',
              items: Strings.mediaTypes,
              onChanged: model.updateType,
              enabled: !model.isLoading,
              errorText: model.submitted && !model.canSubmitType
                  ? Strings.type + Strings.cantBeEmpty
                  : null,
            ),
            CustomTextField(
              controller: ageRestrictionController,
              hint: Strings.ageRestriction + '*',
              errorText: model.submitted && !model.canSubmitAgeRestriction
                  ? Strings.ageRestriction + Strings.cantBeEmpty
                  : null,
              onChanged: model.updateAgeRestriction,
              keyboardType: TextInputType.number,
              enabled: !model.isLoading,
              onEditingComplete: ageRestrictionEditingComplete,
            ),
            CustomTextField(
              controller: descriptionController,
              hint: Strings.description + '*',
              errorText: model.submitted && !model.canSubmitDescription
                  ? Strings.description + Strings.cantBeEmpty
                  : null,
              onChanged: model.updateDescription,
              enabled: !model.isLoading,
              onEditingComplete: descriptionEditingComplete,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.submitted && !model.canSubmitRating
                      ? Strings.rating + Strings.cantBeEmpty
                      : Strings.addRating + '*',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: model.submitted && !model.canSubmitRating
                          ? Colors.red
                          : Theme.of(context).textTheme.headline5!.color,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Adapt.px(12)),
                  child: StarRating(
                    onRatingChanged: model.updateRating,
                    rating: model.rating ?? 0,
                  ),
                ),
              ],
            ),
            CustomPrimaryButton(
              onPressed: () => submit(context),
              label: Strings.confirm,
              loading: model.isLoading,
              enabled: !model.isLoading,
            )
          ],
        ),
      ),
    );
  }

  dropdownButton({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    required String currentValue,
    String? errorText,
    required bool enabled,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: Adapt.px(12), horizontal: Adapt.px(3)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
        ),
        child: DropdownButtonFormField<String>(
          onTap: () => FocusScope.of(context).unfocus(),
          isExpanded: true,
          decoration: InputDecoration(
            errorText: errorText,
            enabled: enabled,
            errorStyle: Theme.of(context).textTheme.headline5!.copyWith(
                  fontSize: Adapt.px(15),
                  color: Colors.red,
                ),
            contentPadding: EdgeInsets.all(Adapt.px(10)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
                borderSide: BorderSide.none),
          ),
          value: currentValue,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).indicatorColor,
          ),
          itemHeight: Adapt.px(50),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              child: dropdownItem(
                  item,
                  Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: Adapt.px(15))),
              value: item,
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Text dropdownItem(String label, TextStyle? style) =>
      Text(label, style: style);
}
