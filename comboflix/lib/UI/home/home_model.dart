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
  double rating;
  bool isLoading;
  bool submitted;

  HomeModel({
    required this.firestoreProvider,
    required this.user,
    this.type = Strings.type,
    this.description = '',
    this.displayName = '',
    this.language = Strings.language,
    this.genre = Strings.genre,
    this.year = Strings.yearOfLaunch,
    this.listName = '',
    this.ageRestriction = '',
    this.rating = 0.0,
    this.formType = FormType.media,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<bool> submit() async {
    print('submit');

    updateWith(isLoading: true);

    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        print('cant submit');
        updateWith(isLoading: false);
      } else {
        if (formType == FormType.media) {
          List<Media>? medias = user.medias;

          if (medias != null) {
            medias.add(
              Media(
                  name: displayName,
                  genre: genre,
                  type: type,
                  language: language,
                  year: int.parse(year),
                  ageRestriction: int.parse(ageRestriction),
                  rating: rating,
                  creationDate: DateTime.now()),
            );
          } else {
            medias = [];

            medias.add(
              Media(
                  name: displayName,
                  genre: genre,
                  type: type,
                  language: language,
                  year: int.parse(year),
                  ageRestriction: int.parse(ageRestriction),
                  rating: rating,
                  creationDate: DateTime.now()),
            );
          }

          firestoreProvider.updateData(
            collectionPath: 'users',
            documentPath: user.uid,
            data: {'medias': medias.map((e) => e.toJson()).toList()},
          );
        } else {
          List<MediaList>? lists = user.lists;
          if (lists != null) {
            lists.add(MediaList(name: listName, creationDate: DateTime.now()));
          } else {
            lists = [];

            lists.add(MediaList(name: listName, creationDate: DateTime.now()));
          }

          firestoreProvider.updateData(
            collectionPath: 'users',
            documentPath: user.uid,
            data: {'lists': lists.map((e) => e.toJson()).toList()},
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
    return yearSubmitValidator.isValid(year) && year.isNotEmpty;
  }

  bool get canSubmitGenre {
    return genderSubmitValidator.isValid(genre) && genre.isNotEmpty;
  }

  bool get canSubmitType {
    return genderSubmitValidator.isValid(genre) && genre.isNotEmpty;
  }

  bool get canSubmitLanguage {
    return genderSubmitValidator.isValid(genre) && genre.isNotEmpty;
  }

  bool get canSubmitRating {
    return rating >= 0 && rating <= 5;
  }

  bool get canSubmitAdultMovie {
    return int.parse(ageRestriction) >= 18 && int.parse(user.year) >= 18;
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

    print(canSubmitFields);
    return canSubmitFields && !isLoading;
  }
}
