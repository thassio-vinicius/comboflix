import 'dart:async';

import 'package:comboflix/UI/home/home_model.dart';
import 'package:comboflix/UI/shared_widgets/custom_primarybutton.dart';
import 'package:comboflix/UI/shared_widgets/custom_textfield.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:comboflix/services/firestore_provider.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final bool fromSplash;
  const HomeScreen(this.fromSplash, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreProvider provider =
        Provider.of<FirestoreProvider>(context, listen: false);
    return StreamBuilder<FirestoreUser>(
      stream: provider.currentUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Theme.of(context).cardColor),
              ),
            ),
          );
        }

        return ChangeNotifierProvider(
          create: (_) =>
              HomeModel(firestoreProvider: provider, user: snapshot.data!),
          child: Consumer<HomeModel>(
            builder: (_, model, ___) =>
                _HomeScreen(model, fromSplash, snapshot.data!),
          ),
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

class __HomeScreenState extends State<_HomeScreen> {
  late double opacity;
  HomeModel get model => widget.model;
  final FocusScopeNode node = FocusScopeNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController listNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageRestrictionController = TextEditingController();

  List<String> years() {
    int year = DateTime.now().year;
    List<String> years = [];
    for (int i = year; i > year - 120; i--) {
      years.add(i.toString());
    }

    years.insert(0, Strings.yearOfLaunch);
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
    try {
      final bool result = await model.submit();
      if (result) {
        Navigator.pop(context);
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
      body: Center(
        child: widget.user.medias!.isNotEmpty && widget.user.medias != null
            ? ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(Adapt.px(12.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(Adapt.px(12)))),
                    padding: EdgeInsets.all(Adapt.px(8)),
                    child: Text(
                      widget.user.medias![index].name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              )
            : Text(
                Strings.noMovies,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => Container(
            height: Adapt().hp(75),
            padding: EdgeInsets.all(Adapt.px(16)),
            child: FocusScope(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
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
                      errorText: model.submitted && model.canSubmitDisplayName
                          ? Strings.name + Strings.cantBeEmpty
                          : null,
                      onChanged: model.updateDisplayName,
                      enabled: !model.isLoading,
                      onEditingComplete: displayNameEditingComplete,
                    ),
                    dropdownButton(
                      currentValue: model.year,
                      label: Strings.yearHint,
                      items: years(),
                      onChanged: model.updateYear,
                      enabled: !model.isLoading,
                      errorText: model.submitted && model.canSubmitYear
                          ? Strings.yearOfLaunch + Strings.cantBeEmpty
                          : null,
                    ),
                    dropdownButton(
                      currentValue: model.genre,
                      label: Strings.genre,
                      items: Strings.genres,
                      onChanged: model.updateGenre,
                      enabled: !model.isLoading,
                      errorText: model.submitted && !model.canSubmitGenre
                          ? Strings.genre + Strings.cantBeEmpty
                          : null,
                    ),
                    dropdownButton(
                      currentValue: model.language,
                      label: Strings.language,
                      items: Strings.languages,
                      onChanged: model.updateLanguage,
                      enabled: !model.isLoading,
                      errorText: model.submitted && !model.canSubmitLanguage
                          ? Strings.language + Strings.cantBeEmpty
                          : null,
                    ),
                    dropdownButton(
                      currentValue: model.type,
                      label: Strings.type,
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
                      errorText:
                          model.submitted && !model.canSubmitAgeRestriction
                              ? Strings.ageRestriction + Strings.cantBeEmpty
                              : null,
                      onChanged: model.updateAgeRestriction,
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
                    CustomPrimaryButton(
                        onPressed: () => submit(context),
                        label: Strings.confirm)
                  ],
                ),
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Adapt.px(12)),
              topRight: Radius.circular(Adapt.px(12)),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).buttonColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
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
