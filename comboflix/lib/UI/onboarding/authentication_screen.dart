import 'dart:async';

import 'package:comboflix/UI/home/home_screen.dart';
import 'package:comboflix/UI/shared_widgets/custom_backbutton.dart';
import 'package:comboflix/UI/shared_widgets/custom_exceptiondialog.dart';
import 'package:comboflix/UI/shared_widgets/custom_primarybutton.dart';
import 'package:comboflix/UI/shared_widgets/custom_textbuton.dart';
import 'package:comboflix/UI/shared_widgets/custom_textfield.dart';
import 'package:comboflix/services/authentication_provider.dart';
import 'package:comboflix/utils/adapt.dart';
import 'package:comboflix/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'email_model.dart';

class AuthenticationScreen extends StatelessWidget {
  final EmailFormType formType;
  final bool fromSplash;
  const AuthenticationScreen(this.fromSplash,
      {this.formType = EmailFormType.signIn});

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return ChangeNotifierProvider<EmailModel>(
      create: (_) => EmailModel(
        formType: formType,
        authProvider: authProvider,
      ),
      child: Consumer<EmailModel>(
        builder: (_, model, __) => _EmailSignOptionScreen(
          model: model,
          formType: formType,
          fromSplash: fromSplash,
        ),
      ),
    );
  }
}

class _EmailSignOptionScreen extends StatefulWidget {
  const _EmailSignOptionScreen(
      {required this.model, required this.formType, required this.fromSplash});
  final EmailModel model;
  final EmailFormType formType;
  final bool fromSplash;

  @override
  _EmailSignOptionScreenState createState() => _EmailSignOptionScreenState();
}

class _EmailSignOptionScreenState extends State<_EmailSignOptionScreen> {
  final FocusScopeNode node = FocusScopeNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  List<String> years() {
    int year = DateTime.now().year;
    List<String> years = [];
    for (int i = year; i > year - 120; i--) {
      years.add(i.toString());
    }

    years.insert(0, Strings.yearHint);
    return years.toList();
  }

  EmailModel get model => widget.model;

  bool usesInitialFormType = true;

  late double opacity;

  @override
  void initState() {
    if (widget.fromSplash) {
      opacity = 0;
      Timer(Duration(seconds: 1), () {
        setState(() {
          opacity = 1;
        });
      });
    } else {
      opacity = 1;
    }
    super.initState();
  }

  @override
  void dispose() {
    node.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showSignInError(EmailModel model, dynamic exception) async {
    await showExceptionAlertDialog(
      context: context,
      title: model.errorAlertTitle,
      exception: exception,
    );
  }

  Future<void> submit() async {
    try {
      final EmailSubmitState result = await model.submit();
      if (result == EmailSubmitState.success) {
        if (model.formType == EmailFormType.recoverPassword) {
          updateFormType(EmailFormType.signIn);
        } else {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(false),
                settings: RouteSettings(name: 'HomeScreen'),
              ),
            );
          });
        }
      } else {
        if (result == EmailSubmitState.authException)
          showSignInError(model, "unknown");
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showSignInError(model, e);
    }
  }

  void updateFormType(EmailFormType? formType) {
    usesInitialFormType = false;
    model.updateFormType(formType);
    emailController.clear();
    passwordController.clear();
    displayNameController.clear();
    confirmPasswordController.clear();
  }

  void emailEditingComplete() {
    if (model.canSubmitEmail) {
      node.nextFocus();
    }
  }

  void displayNameEditingComplete() {
    if (model.canSubmitDisplayName) {
      node.nextFocus();
    }
  }

  void passwordEditingComplete() {
    if (!model.canSubmitPassword) {
      node.nextFocus();
    }
  }

  void confirmPasswordEditingComplete() {
    if (!model.canSubmitPassword) {
      node.previousFocus();
      return;
    }
    submit();
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

  Widget buildFields() {
    late List<Widget> children;

    switch (usesInitialFormType ? widget.formType : model.formType) {
      case EmailFormType.signIn:
        children = [
          CustomTextField(
              controller: emailController,
              hint: Strings.emailHint + '*',
              errorText: model.emailErrorText,
              onChanged: model.updateEmail,
              keyboardType: TextInputType.emailAddress,
              enabled: !model.isLoading,
              onEditingComplete: emailEditingComplete,
              inputFormatters: <TextInputFormatter>[model.emailInputFormatter]),
          CustomTextField(
            controller: passwordController,
            hint: Strings.passwordHint + '*',
            errorText: model.passwordErrorText,
            enabled: !model.isLoading,
            obscureText: true,
            onChanged: model.updatePassword,
            onEditingComplete: passwordEditingComplete,
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(8)),
            child: CustomPrimaryButton(
              label: model.primaryButtonText,
              loading: model.isLoading,
              onPressed: model.isLoading ? null : submit,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.noAccount,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Adapt.px(4)),
                  child: CustomTextButton(
                    label: model.secondaryButtonText,
                    onTap: model.isLoading
                        ? null
                        : () => updateFormType(model.secondaryActionFormType),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(12)),
            child: CustomTextButton(
              label: Strings.forgotPassword,
              onTap: model.isLoading
                  ? null
                  : () => updateFormType(EmailFormType.recoverPassword),
            ),
          ),
        ];
        break;
      case EmailFormType.signUp:
        children = <Widget>[
          CustomTextField(
              controller: emailController,
              hint: Strings.emailHint + '*',
              errorText: model.emailErrorText,
              keyboardType: TextInputType.emailAddress,
              onChanged: model.updateEmail,
              enabled: !model.isLoading,
              onEditingComplete: emailEditingComplete,
              inputFormatters: <TextInputFormatter>[model.emailInputFormatter]),
          CustomTextField(
            controller: displayNameController,
            hint: Strings.displayNameHint + '*',
            errorText: model.displayNameErrorText,
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
            errorText: model.yearErrorText,
          ),
          CustomTextField(
            controller: passwordController,
            hint: Strings.passwordHint + '*',
            errorText: model.passwordErrorText,
            enabled: !model.isLoading,
            obscureText: true,
            onChanged: model.updatePassword,
            onEditingComplete: passwordEditingComplete,
          ),
          CustomTextField(
            controller: confirmPasswordController,
            hint: Strings.confirmPasswordHint + '*',
            errorText: model.confirmPasswordErrorText,
            obscureText: true,
            enabled: !model.isLoading,
            textInputAction: TextInputAction.done,
            onChanged: model.updateConfirmPassword,
            onEditingComplete: confirmPasswordEditingComplete,
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(8)),
            child: CustomPrimaryButton(
              label: model.primaryButtonText,
              loading: model.isLoading,
              onPressed: model.isLoading ? null : submit,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(8)),
            child: CustomTextButton(
              label: model.secondaryButtonText,
              onTap: model.isLoading
                  ? null
                  : () => updateFormType(model.secondaryActionFormType),
            ),
          ),
        ];
        break;
      case EmailFormType.recoverPassword:
        children = [
          CustomTextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              hint: Strings.emailHint + '*',
              errorText: model.emailErrorText,
              onChanged: model.updateEmail,
              enabled: !model.isLoading,
              onEditingComplete: emailEditingComplete,
              inputFormatters: <TextInputFormatter>[model.emailInputFormatter]),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(8)),
            child: CustomPrimaryButton(
              label: model.primaryButtonText,
              loading: model.isLoading,
              onPressed: model.isLoading ? null : submit,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(8)),
            child: CustomTextButton(
              label: model.secondaryButtonText,
              onTap: model.isLoading
                  ? null
                  : () => updateFormType(model.secondaryActionFormType),
            ),
          ),
        ];
        break;
    }
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Adapt.px(12)),
            child: AnimatedOpacity(
              opacity: opacity,
              duration: kThemeAnimationDuration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(
                      Strings.back,
                      () => Navigator.pop(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: Adapt.px(18.0)),
                      child: Text(model.title!,
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ),
                  FocusScope(
                    node: node,
                    child: buildFields(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
