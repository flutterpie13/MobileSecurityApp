class ValidationUtils {
  static String? validateEmail(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\$');
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must include an uppercase letter.';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must include a lowercase letter.';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must include a number.';
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must include a special character.';
    }
    return null;
  }

  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required.';
    }
    final urlRegex = RegExp(r'^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})\/?');
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL.';
    }
    return null;
  }
}
