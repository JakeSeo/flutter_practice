import 'package:email_validator/email_validator.dart';

class CustomValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty.';
    } else if (!EmailValidator.validate(value)) {
      return 'Please check your email format.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty.';
    } else if (value.length < 8) {
      return 'Password needs to be at least 8 characters.';
    }
    return null;
  }

  static String? validateReneteredPassword(String? value, String password) {
    String? validatedPasswordMessage = validatePassword(value);
    if (validatedPasswordMessage != null) {
      return validatedPasswordMessage;
    } else if (password != value) {
      return 'Password does not match';
    }
    return null;
  }
}
