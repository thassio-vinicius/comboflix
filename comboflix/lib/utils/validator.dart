import 'package:comboflix/utils/strings.dart';
import 'package:flutter/services.dart';

abstract class StringValidator {
  isValid(String? value);
}

class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});
  final String? regexSource;

  @override
  bool isValid(String? value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource!);
      final Iterable<Match> matches = regex.allMatches(value!);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({this.editingValidator});
  final StringValidator? editingValidator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator!.isValid(oldValue.text);
    final bool newValueValid = editingValidator!.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String? value) {
    return value!.isNotEmpty;
  }
}

class NotSelectedStringValidator extends StringValidator {
  @override
  bool isValid(String? value) {
    return value != Strings.select;
  }
}

class AlwaysValidStringValidator extends StringValidator {
  @override
  bool isValid(String? value) {
    return true;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String? value) {
    return value!.length >= minLength;
  }
}

class TextFieldValidators {
  final TextInputFormatter emailInputFormatter =
      ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordSubmitValidator = MinLengthStringValidator(6);
  final StringValidator displayNameSubmitValidator =
      MinLengthStringValidator(3);
  final StringValidator confirmPasswordSubmitValidator =
      NonEmptyStringValidator();
  final StringValidator yearSubmitValidator = NotSelectedStringValidator();
  final StringValidator genderSubmitValidator = AlwaysValidStringValidator();
  final StringValidator hearingTestCodeSubmitValidator =
      AlwaysValidStringValidator();
}