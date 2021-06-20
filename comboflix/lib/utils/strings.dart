class Strings {
  static const String comboFlix = 'ComboFlix';
  static const String back = 'Back';
  static const String confirm = 'Confirm';
  static const String error = 'Unknown error. Please try again.';
  static const String none = 'None';
  static const String create = 'Create';
  static const String home = 'Home';
  static const String mediaLists = 'Media Lists';
  static const String ok = 'Ok';
  static const String cancel = 'Cancel';
  static const String close = 'Close';

  //home section
  static const String addMedia = 'New Media';
  static const String noMovies =
      'No movies available\nTap \'+\' to add a new movie';
  static const String noLists =
      'No lists available\nTap \'+\' to add a new list';
  static const String noDescription = 'No description';
  static const String logOut = 'Log out';
  static const String createList = 'Create List';
  static const String nameTheList = 'Put a name on your list!';

  //media section
  static const String notOldEnough = 'Not old enough';
  static const String adultMovieException =
      'You have to be 18 or older to add and share adult movies';
  static const String addRating = 'Add Rating';
  static const String cantBeEmpty = ' can\'t be empty';
  static const String yearOfLaunch = 'Year of launch';
  static const String ageRestriction = 'Age Restriction';
  static const String genre = 'Genre';
  static const String language = 'Language';
  static const String description = 'Description';
  static const String type = 'Type';
  static const String rating = 'Rating';
  static const String nameSmaller = ' or smaller than 2 characters';

  static const List<String> genres = [
    'Action',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Thriller',
    'Western',
    Strings.genre + '*',
  ];
  static const List<String> mediaTypes = [
    'Movie',
    'TV Show',
    'Documentary',
    Strings.type + '*',
  ];
  static const List<String> languages = [
    'English',
    'Portuguese',
    'Korean',
    'German',
    'Mandarin',
    'Japanese',
    'French',
    'Spanish',
    'Russian',
    'Arabic',
    'Turkish',
    'Italian',
    'Greek',
    'Dutch',
    'Polish',
    'Hindi',
    Strings.language + '*',
  ];

  //authentication section
  static const String continueWith = "Continue with ";
  static const String signUp = "Sign up";
  static const String or = "Or";
  static const String haveAccount = "Already have an account?";
  static const String noAccount = "Doesn't have an account?";
  static const String verifyAccount =
      'To access eargym please verify your account';
  static const String verificationSent = 'A verification email was sent to';
  static const String checkInbox = 'Check your inbox to complete verification.';
  static const String didntReceiveEmail = 'Didn\'t receive an email?';
  static const String resendEmail = 'Resend verification Email';
  static const String verificationSuccess = 'Verification successful!';
  static const String verificationSuccessDesc =
      'You’re all set. Continue to start your journey of hearing discovery and training.';
  static const String login = "Log in";
  static const String select = "Select";
  static const String termsPrivacy =
      "By continuing you agree to eargym’s terms & conditions and privacy policy";
  static const String name = "Name";
  static const String emailHint = "Email Address";
  static const String passwordHint = "Password";
  static const String confirmPasswordHint = "Confirm Password";
  static const String genderHint = "Gender";
  static const String yearHint = "How old are you?";
  static const String signUpConfirm = "Create Account";
  static const String signUpFailed = "Error with Account Creation";
  static const String signInTitle = "Create your Account";
  static const String backToSignIn = "Back to Log in";
  static const String forgotPassword = "Forgot your password?";
  static const String passwordResetFailed =
      "There was an error with your password recovery";
  static const String signInFailed = "Log in error";
  static const String sendResetLink = "Send reset link";
  static const String invalidConfirmPasswordEmpty =
      "Confirm Password can't be empty";
  static const String invalidPasswordsNoMatch =
      "Password and Confirm Password don't match";
  static const String invalidDisplayNameTooShort =
      "Full Name can't be less than 3 characters";
  static const String invalidDisplayNameEmpty = "Full Name can't be empty";
  static const String invalidPasswordEmpty = "Password can't be empty";
  static const String invalidGenderRequired = "Gender is required";
  static const String invalidYearRequired = "Year is required";
  static const String invalidPasswordTooShort =
      "Password can't be less than 6 characters";
  static const String invalidEmailEmpty = "Email can't be empty";
  static const String invalidEmailErrorText = "Invalid Email";
  static const String male = "Male";
  static const String female = "Female";
  static const String nonBinary = "Non binary";
  static const String transgender = "Transgender";
  static const String interSex = "Intersex";
  static const String other = "Other";
}
