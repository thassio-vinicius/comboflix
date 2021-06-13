import 'package:comboflix/services/authentication_provider.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:comboflix/utils/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum EmailFormType { signIn, signUp, recoverPassword }

enum EmailSubmitState { cantSubmit, authException, success }

class EmailModel with TextFieldValidators, ChangeNotifier {
  EmailModel({
    required this.authProvider,
    required this.formType,
    this.email = '',
    this.password = '',
    this.displayName = '',
    this.confirmPassword = '',
    this.gender = Strings.select,
    this.year = Strings.yearHint,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthenticationProvider authProvider;
  String email;
  String password;
  String displayName;
  String confirmPassword;
  String gender;
  String year;
  EmailFormType formType;
  bool isLoading;
  bool submitted;

  Future<EmailSubmitState> submit() async {
    print('submit');

    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        print('cant submit');
        return EmailSubmitState.cantSubmit;
      }
      updateWith(isLoading: true);

      bool result;

      switch (formType) {
        case EmailFormType.signIn:
          result = await authProvider.signInVerifiedUser(
              email: email, password: password);

          updateWith(isLoading: false);
          return result
              ? EmailSubmitState.success
              : EmailSubmitState.authException;
        case EmailFormType.signUp:
          result = await authProvider.emailSignUp(
            email: email.trim(),
            password: password.trim(),
            displayName: displayName,
            year: year,
          );
          updateWith(isLoading: false);

          print('submit register');
          return result
              ? EmailSubmitState.success
              : EmailSubmitState.authException;
        case EmailFormType.recoverPassword:
          result = await authProvider.sendResetPasswordEmail(email);
          updateWith(isLoading: false);
          return result
              ? EmailSubmitState.success
              : EmailSubmitState.authException;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateYear(String? year) => updateWith(year: year);

  void updateGender(String? gender) => updateWith(gender: gender);

  void updateDisplayName(String displayName) =>
      updateWith(displayName: displayName);

  void updateConfirmPassword(String confirmPassword) =>
      updateWith(confirmPassword: confirmPassword);

  void updateWith({
    String? email,
    String? password,
    String? displayName,
    String? gender,
    String? year,
    String? confirmPassword,
    bool? isLoading,
    bool? submitted,
    EmailFormType? formType,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.displayName = displayName ?? this.displayName;
    this.year = year ?? this.year;
    this.gender = gender ?? this.gender;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    this.formType = formType ?? this.formType;
    notifyListeners();
  }

  void updateFormType(EmailFormType? formType) {
    updateWith(
      email: '',
      password: '',
      displayName: '',
      confirmPassword: '',
      gender: Strings.select,
      year: Strings.yearHint,
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  // Getters

  String? get primaryButtonText {
    return <EmailFormType, String>{
      EmailFormType.signUp: Strings.signUpConfirm,
      EmailFormType.signIn: Strings.login,
      EmailFormType.recoverPassword: Strings.sendResetLink,
    }[formType];
  }

  String? get errorAlertTitle {
    return <EmailFormType, String>{
      EmailFormType.signUp: Strings.signUpFailed,
      EmailFormType.signIn: Strings.signInFailed,
      EmailFormType.recoverPassword: Strings.passwordResetFailed,
    }[formType];
  }

  String? get title {
    return <EmailFormType, String>{
      EmailFormType.signUp: Strings.signUp,
      EmailFormType.signIn: Strings.login,
      EmailFormType.recoverPassword: Strings.forgotPassword,
    }[formType];
  }

  String? get secondaryButtonText {
    return <EmailFormType, String>{
      EmailFormType.signUp: Strings.haveAccount,
      EmailFormType.signIn: Strings.signUp,
      EmailFormType.recoverPassword: Strings.backToSignIn,
    }[formType];
  }

  EmailFormType? get secondaryActionFormType {
    return <EmailFormType, EmailFormType>{
      EmailFormType.signUp: EmailFormType.signIn,
      EmailFormType.signIn: EmailFormType.signUp,
      EmailFormType.recoverPassword: EmailFormType.signIn,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email) && email.isNotEmpty;
  }

  bool get canSubmitPassword {
    return passwordSubmitValidator.isValid(password) && password.isNotEmpty;
  }

  bool get canSubmitDisplayName {
    return displayNameSubmitValidator.isValid(displayName) &&
        displayName.isNotEmpty;
  }

  bool get canSubmitConfirmPassword {
    return confirmPasswordSubmitValidator.isValid(confirmPassword) &&
        password == confirmPassword;
  }

  bool get canSubmitYear {
    return yearSubmitValidator.isValid(year) && year.isNotEmpty;
  }

  bool get canSubmitGender {
    return genderSubmitValidator.isValid(gender) && gender.isNotEmpty;
  }

  bool get canSubmit {
    bool? canSubmitFields;

    switch (formType) {
      case EmailFormType.signIn:
        canSubmitFields = canSubmitEmail && canSubmitPassword;
        break;
      case EmailFormType.signUp:
        canSubmitFields = canSubmitEmail &&
            canSubmitPassword &&
            canSubmitConfirmPassword &&
            canSubmitYear &&
            canSubmitGender &&
            canSubmitDisplayName;
        break;
      case EmailFormType.recoverPassword:
        canSubmitFields = canSubmitEmail;
        break;
    }
    print(canSubmitFields);
    return canSubmitFields && !isLoading;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
        ? Strings.invalidEmailEmpty
        : Strings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? Strings.invalidPasswordEmpty
        : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  String? get confirmPasswordErrorText {
    final bool showErrorText = submitted && !canSubmitConfirmPassword;
    final String errorText = confirmPassword.isEmpty
        ? Strings.invalidConfirmPasswordEmpty
        : Strings.invalidPasswordsNoMatch;
    return showErrorText ? errorText : null;
  }

  String? get displayNameErrorText {
    final bool showErrorText = submitted && !canSubmitDisplayName;
    final String errorText = displayName.isEmpty
        ? Strings.invalidDisplayNameEmpty
        : Strings.invalidDisplayNameTooShort;
    return showErrorText ? errorText : null;
  }

  String? get yearErrorText {
    final bool showErrorText = submitted && !canSubmitYear;
    final String errorText = Strings.invalidYearRequired;
    return showErrorText ? errorText : null;
  }

  String? get genderErrorText {
    final bool showErrorText = submitted && !canSubmitGender;
    final String errorText = Strings.invalidGenderRequired;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, displayName: $displayName, password: $password, confirmPassword: $confirmPassword, gender: $gender, year: $year, isLoading: $isLoading, submitted: $submitted';
  }
}
