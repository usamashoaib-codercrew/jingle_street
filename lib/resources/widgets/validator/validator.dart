class ValidatorScreen {
  static final RegExp emailPattern = RegExp(r'^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+');
  static final RegExp passwordPattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  static final RegExp phonePattern = RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$');

  static emailValidation(String value) {
    if (value == null ||value.isEmpty) {
      return "Enter Email";
    } else if (!emailPattern.hasMatch(value)&&!phonePattern.hasMatch(value)) {
      return "Wrong pattern";
    }
    return null;
  }

  static passwordValidation(String value) {
    if (value ==null ||value.isEmpty) {
      return "Enter Password";
    } else if (passwordPattern.hasMatch(value)) {
      return "at least 1 Uppercase Alphabet, Number, and !@#\$%^&*";
    }
  }

  static nameValidation(value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
  }

  static confirmPasswordValidation(value,String confirm) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    } else if (value != confirm) {
      return "Password doesn't match";
    }
    return null;
  }
}
