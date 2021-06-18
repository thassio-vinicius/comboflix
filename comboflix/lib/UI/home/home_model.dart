import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:comboflix/models/media.dart';
import 'package:comboflix/models/media_list.dart';
import 'package:comboflix/services/firestore_provider.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:comboflix/utils/validator.dart';
import 'package:flutter/cupertino.dart';

enum FormType { list, media }

class HomeModel with TextFieldValidators, ChangeNotifier {
  FirestoreProvider firestoreProvider;
  FirestoreUser user;
  FormType formType;
  String type;
  String description;
  String listName;
  String displayName;
  String language;
  String genre;
  String year;
  String ageRestriction;
  double? rating;
  bool isLoading;
  bool submitted;

  HomeModel({
    required this.firestoreProvider,
    required this.user,
    this.type = Strings.type + '*',
    this.description = '',
    this.displayName = '',
    this.language = Strings.language + '*',
    this.genre = Strings.genre + '*',
    this.year = Strings.yearOfLaunch + '*',
    this.listName = '',
    this.ageRestriction = '',
    this.rating,
    this.formType = FormType.media,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<bool> submit() async {
    print('submit');

    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        print('cant submit');
        updateWith(isLoading: false);
      } else {
        print('form type ' + formType.toString());

        updateWith(isLoading: true);

        if (formType == FormType.media) {
          Media media = Media(
            name: displayName,
            genre: genre,
            type: type,
            language: language,
            description: description,
            year: int.parse(year),
            ageRestriction: int.parse(ageRestriction),
            rating: rating!,
            creationDate: DateTime.now(),
          );

          print(media.toString());

          print(' set data');

          await firestoreProvider.updateData(
            collectionPath: 'users',
            documentPath: user.uid,
            data: {
              'medias': FieldValue.arrayUnion([media.toJson()])
            },
          );
        } else {
          await firestoreProvider.updateData(
            collectionPath: 'users',
            documentPath: user.uid,
            data: {
              'lists': FieldValue.arrayUnion([
                MediaList(name: listName, creationDate: DateTime.now()).toJson()
              ])
            },
          );
        }

        updateWith(isLoading: false);
      }

      return canSubmit;
    } catch (e, stackTrace) {
      print(stackTrace);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateLanguage(String? language) => updateWith(language: language);

  void updateDescription(String description) =>
      updateWith(description: description);

  void updateYear(String? year) => updateWith(year: year);

  void updateType(String? type) => updateWith(type: type);

  void updateAgeRestriction(String age) => updateWith(ageRestriction: age);

  void updateGenre(String? genre) => updateWith(genre: genre);

  void updateDisplayName(String displayName) =>
      updateWith(displayName: displayName);

  void updateListName(String listName) => updateWith(listName: listName);

  void updateRating(double rating) => updateWith(rating: rating);

  void updateFormType(FormType formType) => updateWith(formType: formType);

  void updateWith({
    String? language,
    String? description,
    String? displayName,
    String? listName,
    String? genre,
    String? type,
    String? year,
    String? ageRestriction,
    double? rating,
    FormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.language = language ?? this.language;
    this.description = description ?? this.description;
    this.displayName = displayName ?? this.displayName;
    this.year = year ?? this.year;
    this.type = type ?? this.type;
    this.ageRestriction = ageRestriction ?? this.ageRestriction;
    this.genre = genre ?? this.genre;
    this.rating = rating ?? this.rating;
    this.isLoading = isLoading ?? this.isLoading;
    this.listName = listName ?? this.listName;
    this.submitted = submitted ?? this.submitted;
    this.formType = formType ?? this.formType;
    notifyListeners();
  }

  // Getters

  bool get canSubmitAgeRestriction {
    return ageRestrictionSubmitValidator.isValid(ageRestriction) &&
        ageRestriction.isNotEmpty;
  }

  bool get canSubmitDescription {
    return descriptionSubmitValidator.isValid(description);
  }

  bool get canSubmitDisplayName {
    return displayNameSubmitValidator.isValid(displayName) &&
        displayName.isNotEmpty;
  }

  bool get canSubmitListName {
    return displayNameSubmitValidator.isValid(listName) && listName.isNotEmpty;
  }

  bool get canSubmitYear {
    return yearSubmitValidator.isValid(year) &&
        year.isNotEmpty &&
        year != Strings.yearOfLaunch + '*';
    ;
  }

  bool get canSubmitGenre {
    return genderSubmitValidator.isValid(genre) &&
        genre.isNotEmpty &&
        genre != Strings.genre + '*';
  }

  bool get canSubmitType {
    return genderSubmitValidator.isValid(type) &&
        type.isNotEmpty &&
        type != Strings.type + '*';
  }

  bool get canSubmitLanguage {
    return genderSubmitValidator.isValid(language) &&
        language.isNotEmpty &&
        language != Strings.language + '*';
  }

  bool get canSubmitRating {
    return rating != null && rating! >= 0 && rating! <= 5;
  }

  bool get canSubmitAdultMovie {
    if (ageRestriction.isNotEmpty) {
      if (int.parse(ageRestriction) >= 18) {
        return int.parse(user.year) >= 18;
      }
    }

    return true;
  }

  bool get canSubmit {
    late bool canSubmitFields;
    if (formType == FormType.media) {
      canSubmitFields = canSubmitYear &&
          canSubmitGenre &&
          canSubmitAgeRestriction &&
          canSubmitDisplayName &&
          canSubmitDescription &&
          canSubmitRating &&
          canSubmitType &&
          canSubmitAdultMovie &&
          canSubmitLanguage;
    } else {
      canSubmitFields = canSubmitListName;
    }

    print('canSubmitDisplayName ' + canSubmitDisplayName.toString());
    print('canSubmitYear ' + canSubmitYear.toString());
    print('canSubmitGenre ' + canSubmitGenre.toString());
    print('canSubmitAgeRestriction ' + canSubmitAgeRestriction.toString());
    print('canSubmitDescription ' + canSubmitDescription.toString());
    print('canSubmitRating ' + canSubmitRating.toString());
    print('canSubmitType ' + canSubmitType.toString());
    print('canSubmitAdultMovie ' + canSubmitAdultMovie.toString());
    print('canSubmitLanguage ' + canSubmitLanguage.toString());

    print(canSubmitFields);
    return canSubmitFields && !isLoading;
  }

  @override
  String toString() {
    return 'HomeModel{firestoreProvider: $firestoreProvider, user: $user, formType: $formType, type: $type, description: $description, listName: $listName, displayName: $displayName, language: $language, genre: $genre, year: $year, ageRestriction: $ageRestriction, rating: $rating, isLoading: $isLoading, submitted: $submitted}';
  }
}
